function loadAccountantView(view) {
    const content = document.getElementById("accountant-content");

    switch (view) {
        case 'status':
            content.innerHTML = `
                <h2>Update Booking Status</h2>
                <form action="php/update_status.php" method="POST">
                    <input type="text" name="booking_id" placeholder="Booking ID" required>
                    <input type="text" name="booking_status" placeholder="Booking Status">
                    <input type="text" name="payment_status" placeholder="Payment Status">
                    <button type="submit">Update</button>
                </form>
            `;
            break;
        default:
            content.innerHTML = `<p>Select an action from the sidebar.</p>`;
    }

    // Fetch outlier bookings
    fetch('php/view_outliers.php')
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                const tableRows = data.data.map(row => `
                    <tr>
                        <td>${row.Booking_ID}</td>
                        <td>${row.Passenger_ID}</td>
                        <td>${row.Airline_Name}</td>
                        <td>${row.Passenger_Name}</td>
                        <td>${row.Gender}</td>
                        <td>$${parseFloat(row.Total_Amount).toFixed(2)}</td>
                        <td>$${parseFloat(row.Discount).toFixed(2)}</td>
                    </tr>
                `).join('');

                content.innerHTML += `
                    <h2>Bookings with Non-Average Payments</h2>
                    <table border="1">
                        <tr>
                            <th>Booking ID</th>
                            <th>Passenger ID</th>
                            <th>Airline Name</th>
                            <th>Passenger Name</th>
                            <th>Gender</th>
                            <th>Total Amount</th>
                            <th>Discount</th>
                        </tr>
                        ${tableRows}
                    </table>
                `;
            } else {
                content.innerHTML += `<p>Failed to load data.</p>`;
            }
        })
        .catch(err => {
            content.innerHTML += `<p>Error loading data.</p>`;
            console.error(err);
        });
}
