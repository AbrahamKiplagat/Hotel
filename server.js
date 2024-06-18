const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const cors = require('cors'); // Import CORS package

const app = express();
app.use(bodyParser.json());
app.use(cors()); // Enable CORS for all routes

const consumerKey = 'CGQThG0NffJzBDIRqxfLYpFWaS0FkqNbSN8CYlPyshEnQBO6';
const consumerSecret = 'dftK65sJvLT6XfXOxeZkAYKME79ycyWVT3U2srnXXsNODEAm7JeYyL9dlRujdwNA';
const shortCode = '174379'; // demo code
const lipaNaMpesaOnlineUrl = 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
const tokenUrl = 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
const passKey = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';

// Function to get access token
async function getAccessToken() {
  const credentials = Buffer.from(`${consumerKey}:${consumerSecret}`).toString('base64');
  try {
    const response = await axios.get(tokenUrl, {
      headers: {
        'Authorization': `Basic ${credentials}`,
      },
    });
    return response.data.access_token;
  } catch (error) {
    throw new Error('Failed to get access token');
  }
}

// Route to initiate STK push
app.post('/initiateSTKPush', async (req, res) => {
  const { phoneNumber } = req.body; // Extract phoneNumber from request body
  const amount = 100; // Example amount, replace with actual logic to get amount

  try {
    const accessToken = await getAccessToken();
    const timestamp = new Date().toISOString().replace(/[-:.TZ]/g, '').slice(0, 14); // format timestamp
    const password = Buffer.from(`${shortCode}${passKey}${timestamp}`).toString('base64');

    const response = await axios.post(lipaNaMpesaOnlineUrl, {
      BusinessShortCode: shortCode,
      Password: password,
      Timestamp: timestamp,
      TransactionType: 'CustomerPayBillOnline',
      Amount: amount,
      PartyA: phoneNumber, // Use phoneNumber from request body
      PartyB: shortCode,
      PhoneNumber: phoneNumber,
      CallBackURL: 'https://your-callback-url.com/callback',
      AccountReference: 'HotelBooking123',
      TransactionDesc: 'Hotel Room Payment',
    }, {
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
    });

    res.status(200).send('STK Push initiated successfully');
  } catch (error) {
    res.status(500).send(`Failed to initiate STK Push: ${error.message}`);
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
