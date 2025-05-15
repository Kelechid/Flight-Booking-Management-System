function loadAdminView(view) {
  const content = document.getElementById("admin-content");

  switch (view) {
    case 'users':
      content.innerHTML = `
        <h3>PL/SQL Admin Actions</h3>
        <div>
          <button onclick="runPLSQL('cancelled_bookings')">Passengers with Cancelled Bookings</button>
        </div>
        <form id="phoneForm" style="margin-top: 15px;">
          <input type="text" name="passenger_id" placeholder="Passenger ID" required>
          <input type="text" name="country_code" placeholder="Country Code (e.g. +234)">
          <input type="number" name="tel_number" placeholder="Phone Number" required>
          <button type="submit">Add Phone Number</button>
        </form>
        <div id="plsql-result" style="margin-top: 15px;"></div>
        <div id="phone-result"></div>
      `;

      // Attach form submission for phoneForm
      document.getElementById('phoneForm').addEventListener('submit', function (e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        fetch('php/insert-phone.php', {
          method: 'POST',
          body: formData
        })
          .then(res => res.json())
          .then(data => {
            document.getElementById('phone-result').textContent = data.message;
          })
          .catch(error => {
            console.error('Error:', error);
            document.getElementById('phone-result').textContent = 'An error occurred.';
          });
      });
      break;

    case 'flights':
      content.innerHTML = `
        <h2>All Booked Flights</h2>
        <button onclick="fetchStat('most-booked')">Most Booked Flights</button>
        <button onclick="fetchStat('airport-revenue')">Revenue by Airport</button>
        <button onclick="fetchStat('daily-bookings')">Daily Booking Volume</button>
        <div id="stats-result" style="margin-top: 20px;"></div>
      `;
      break;

    case 'bookings':
      fetch('php/bookings.php')
        .then(res => res.text())
        .then(html => {
          content.innerHTML = html;

          // Reattach "Show Paid Bookings" logic here
          const btn = document.getElementById('showBookingsBtn');
          if (btn) {
            btn.addEventListener('click', () => {
              fetch('php/get_paid_bookings.php')
                .then(response => response.text())
                .then(data => {
                  document.getElementById('bookings-table-container').innerHTML = data;
                })
                .catch(error => {
                  document.getElementById('bookings-table-container').innerHTML =
                    "<p style='color:red;'>Error loading bookings.</p>";
                  console.error(error);
                });
            });
          }
        });
      break;

    case 'add-flight':
    case 'Remove-flight':
      fetch('partials/admin-flight-management.html')
        .then(res => res.text())
        .then(html => {
          content.innerHTML = html;
          attachFlightManagementEvents();
          loadFlights();
        });
      break;

    default:
      content.innerHTML = `<p>Select an action from the sidebar.</p>`;
  }
}


// Attach extra logic after loading specific views
if (view === 'bookings') {
  setTimeout(() => {
    const btn = document.getElementById('showBookingsBtn');
    if (btn) {
      btn.addEventListener('click', () => {
        fetch('php/get_paid_bookings.php')
          .then(response => response.text())
          .then(data => {
            const container = document.getElementById('bookings-table-container');
            if (container) {
              container.innerHTML = data;
            }
          })
          .catch(error => {
            console.error('Error fetching paid bookings:', error);
            const container = document.getElementById('bookings-table-container');
            if (container) {
              container.innerHTML = "<p style='color:red;'>Error loading bookings.</p>";
            }
          });
      });
    }
  }, 100); // Slight delay to ensure DOM elements are rendered
}


if (view === 'add-flight' || view === 'Remove-flight') {
  attachFlightManagementEvents(); // Attach form events
  loadFlights(); // Load existing flights
}



function attachFlightManagementEvents() {
  const flightForm = document.getElementById("flightForm");
  if (flightForm) {
    flightForm.addEventListener("submit", function (e) {
      e.preventDefault();
      const formData = new FormData(flightForm);
      fetch("php/manage_flights_actual.php", {
        method: "POST",
        body: formData
      })
        .then(res => res.json())
        .then(data => {
          alert(data.message);
          if (data.status === "success") {
            loadFlights(); // reload updated list
          }
        });
    });
  }

  const deleteForm = document.getElementById("deleteFlightForm");
  if (deleteForm) {
    deleteForm.addEventListener("submit", function (e) {
      e.preventDefault();
      const formData = new FormData(deleteForm);
      formData.append("action", "delete");

      fetch("php/manage_flights_actual.php", {
        method: "POST",
        body: formData
      })
        .then(res => res.json())
        .then(data => {
          alert(data.message);
          if (data.status === "success") {
            loadFlights();
          }
        });
    });
  }
}

function loadFlights() {
  fetch("php/get-flights.php")
    .then(res => res.json())
    .then(data => {
      const container = document.querySelector("#flightList");
      container.innerHTML = "";
      data.forEach(flight => {
        const row = document.createElement("div");
        row.innerHTML = `
          <div onclick='fillForm(${JSON.stringify(flight)})'>
            ${flight.Flight_ID} - ${flight.Flight_Number}
          </div>`;
        container.appendChild(row);
      });
    });
}

function fillForm(flight) {
  document.getElementById("flight_id_input").disabled = false;
  document.querySelector("input[name='flight_id']").value = flight.Flight_ID;
  document.querySelector("input[name='flight_number']").value = flight.Flight_Number;
  document.querySelector("input[name='d_datetime']").value = flight.D_DateTime;
  document.querySelector("input[name='a_datetime']").value = flight.A_DateTime;
  document.querySelector("input[name='d_airport_id']").value = flight.D_Airport_ID;
  document.querySelector("input[name='a_airport_id']").value = flight.A_Airport_ID;
  document.querySelector("input[name='available_seats']").value = flight.Available_Seats;
  document.querySelector("input[name='total_seats']").value = flight.Total_Seats;
  document.querySelector("input[name='price']").value = flight.Price;
}

function clearFlightForm() {
  const flightForm = document.getElementById("flightForm");
  flightForm.reset();
  document.getElementById("flightAction").value = "add";
  document.getElementById("flight_id_input").disabled = true;
}

function fetchStat(type) {
  fetch(`php/admin-stats.php?type=${type}`)
    .then(res => res.json())
    .then(data => {
      const container = document.getElementById('stats-result');
      container.innerHTML = '';

      if (data.length === 0) {
        container.innerHTML = '<p>No data available.</p>';
        return;
      }

      const table = document.createElement('table');
      table.border = '1';
      const thead = table.createTHead();
      const headerRow = thead.insertRow();

      Object.keys(data[0]).forEach(key => {
        const th = document.createElement('th');
        th.textContent = key;
        headerRow.appendChild(th);
      });

      const tbody = table.createTBody();
      data.forEach(row => {
        const tr = tbody.insertRow();
        Object.values(row).forEach(value => {
          const td = tr.insertCell();
          td.textContent = value;
        });
      });

      container.appendChild(table);
    })
    .catch(error => {
      console.error('Error fetching data:', error);
      document.getElementById('stats-result').innerHTML = '<p>Error loading data.</p>';
    });
}

function runPLSQL(type) {
  const output = document.getElementById('plsql-result');
  output.innerHTML = 'Loading...';

  let url = '';
  if (type === 'cancelled_bookings') {
    url = 'php/plsql-admin.php?type=cancelled_bookings';
  } else if (type === 'total_payment') {
    const uid = document.getElementById('paymentUserId').value;
    if (!uid) {
      output.innerHTML = 'Please enter a User ID';
      return;
    }
    url = `php/plsql-admin.php?type=total_payment&uid=${uid}`;
  }

  fetch(url)
    .then(res => res.json())
    .then(data => {
      output.innerHTML = '';

      if (Array.isArray(data)) {
        if (data.length === 0) {
          output.innerHTML = '<p>No results found.</p>';
          return;
        }

        const table = document.createElement('table');
        table.border = '1';
        const thead = table.createTHead();
        const headerRow = thead.insertRow();

        Object.keys(data[0]).forEach(key => {
          const th = document.createElement('th');
          th.textContent = key;
          headerRow.appendChild(th);
        });

        const tbody = table.createTBody();
        data.forEach(row => {
          const tr = tbody.insertRow();
          Object.values(row).forEach(value => {
            const td = tr.insertCell();
            td.textContent = value;
          });
        });

        output.appendChild(table);
      } else {
        output.innerHTML = `<p>${data.message}</p>`;
      }
    });
}
