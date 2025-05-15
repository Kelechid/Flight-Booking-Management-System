function loadCustomerView(view) {
  const content = document.getElementById("customer-content");

  switch (view) {
    case 'book':
      content.innerHTML = `
        <h2>Add Profile</h2>
        <form id="addPassengerForm">
          <input type="hidden" name="action" value="save">
          <input type="text" name="P_Firstname" placeholder="First Name" required>
          <input type="text" name="P_Lastname" placeholder="Last Name" required>
          <input type="email" name="Email" placeholder="Email" required>
          <input type="text" name="Passport_Number" placeholder="Passport Number" required>
          <input type="date" name="Date_Of_Birth" required>
          <input type="text" name="Gender" placeholder="Gender">
          <input type="text" name="Country_Code" placeholder="Country Code">
          <input type="text" name="Tel_Number" placeholder="Phone Number">
          <button type="submit">Save Info</button>
        </form>
        <div id="addPassengerMsg"></div>

        <hr>

        <h2>Update Passenger</h2>
        <form id="updatePassengerForm">
          <input type="hidden" name="action" value="update">
          <input type="text" name="Passenger_ID" placeholder="Passenger ID (e.g. P001)" required>
          <input type="text" name="P_Firstname" placeholder="First Name">
          <input type="text" name="P_Lastname" placeholder="Last Name">
          <input type="email" name="Email" placeholder="Email">
          <input type="text" name="Passport_Number" placeholder="Passport Number">
          <input type="date" name="Date_Of_Birth">
          <input type="text" name="Gender" placeholder="Gender">
          <input type="text" name="Country_Code" placeholder="Country Code">
          <input type="text" name="Tel_Number" placeholder="Phone Number">
          <button type="submit">Update Info</button>
        </form>
        <div id="updatePassengerMsg"></div>

        <hr>

        <h2>Delete Passenger</h2>
        <form id="deletePassengerForm">
          <input type="hidden" name="action" value="delete">
          <input type="text" name="Passenger_ID" placeholder="Passenger ID (e.g. P001)" required>
          <button type="submit" style="background-color:red; color:white;">Delete Passenger</button>
        </form>
        <div id="deletePassengerMsg"></div>

        <hr>

        <h2>Book a Flight</h2>
        <form action="php/book_flight.php" method="POST">
          <select name="flight_id">
            <option disabled selected>Select Flight</option>
          </select>
          <select name="airline_name">
            <option disabled selected>Select Airline</option>
          </select>
          <input type="text" name="Seat_Number" placeholder="Seat Number">
          <input type="text" name="Passenger_ID" placeholder="Passenger ID">
          <button type="submit">Book Flight</button>
        </form>
      `;

      // Fetch-based form handler
      function handlePassengerForm(formId, messageId) {
        const form = document.getElementById(formId);
        const msgDiv = document.getElementById(messageId);

        if (form) {
          form.addEventListener("submit", async function (e) {
            e.preventDefault();
            const formData = new FormData(form);
            try {
              const res = await fetch("php/manage_passenger.php", {
                method: "POST",
                body: formData
              });
              const result = await res.json();
              msgDiv.innerHTML = `<p style="color: ${result.status === "success" ? "green" : "red"};">${result.message}</p>`;
              if (result.status === "success") loadPassengers();
            } catch (err) {
              msgDiv.innerHTML = `<p style="color:red;">Error processing request.</p>`;
              console.error(err);
            }
          });
        }
      }

      handlePassengerForm("addPassengerForm", "addPassengerMsg");
      handlePassengerForm("updatePassengerForm", "updatePassengerMsg");
      handlePassengerForm("deletePassengerForm", "deletePassengerMsg");
      break;

    case 'myflights':
      content.innerHTML = `
        <h2>My Bookings</h2>
        <ul><li>Flight A - Confirmed</li></ul>
      `;
      break;

    case 'history':
      content.innerHTML = `
        <h2>Flight History</h2>
        <ul><li>Flight X - Completed on 10/04/2025</li></ul>
      `;
      break;

    case 'payment':
      content.innerHTML = `
        <h2>Make Payment</h2>
        <form action="php/make_payment.php" method="POST">
          <input type="text" name="booking_id" placeholder="Booking ID" required>
          <input type="text" name="payment_method" placeholder="Payment Method" required>
          <input type="number" step="0.01" name="amount" placeholder="Amount" required>
          <button type="submit">Pay</button>
        </form>
      `;
      break;

    default:
      content.innerHTML = `<p>Choose a section to view your flight details.</p>`;
  }
}

document.addEventListener("DOMContentLoaded", () => {
  loadPassengers();
});

function loadPassengers() {
  fetch("php/manage_passenger.php?action=read")
    .then(res => res.json())
    .then(data => {
      const tbody = document.querySelector("#passengerTable tbody");
      if (!tbody) return;
      tbody.innerHTML = "";
      data.forEach(p => {
        tbody.innerHTML += `
          <tr>
            <td>${p.Passenger_ID}</td>
            <td><input value="${p.P_Firstname}" data-id="${p.Passenger_ID}" data-field="P_Firstname"></td>
            <td><input value="${p.P_Lastname}" data-id="${p.Passenger_ID}" data-field="P_Lastname"></td>
            <td><input value="${p.Email}" data-id="${p.Passenger_ID}" data-field="Email"></td>
            <td>
              <button onclick="updatePassenger('${p.Passenger_ID}')">Update</button>
              <button onclick="deletePassenger('${p.Passenger_ID}')">Delete</button>
            </td>
          </tr>
        `;
      });
    });
}

function updatePassenger(id) {
  const inputs = document.querySelectorAll(`input[data-id="${id}"]`);
  const formData = new FormData();
  formData.append("action", "update");
  formData.append("Passenger_ID", id);
  inputs.forEach(input => {
    formData.append(input.dataset.field, input.value);
  });

  fetch("php/manage_passenger.php", {
    method: "POST",
    body: formData
  }).then(res => res.json())
    .then(data => {
      alert(data.message);
      if (data.status === "success") loadPassengers();
    });
}

function deletePassenger(id) {
  if (!confirm("Delete passenger?")) return;
  const formData = new FormData();
  formData.append("action", "delete");
  formData.append("Passenger_ID", id);

  fetch("php/manage_passenger.php", {
    method: "POST",
    body: formData
  }).then(res => res.json())
    .then(data => {
      alert(data.message);
      if (data.status === "success") loadPassengers();
    });
}
