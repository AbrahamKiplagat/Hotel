// const express = require('express');
// const axios = require('axios');
// const bodyParser = require('body-parser');
// const cors = require('cors');

// const app = express();
// app.use(bodyParser.json());
// app.use(cors());

// const consumerKey = 'CGQThG0NffJzBDIRqxfLYpFWaS0FkqNbSN8CYlPyshEnQBO6';
// const consumerSecret = 'dftK65sJvLT6XfXOxeZkAYKME79ycyWVT3U2srnXXsNODEAm7JeYyL9dlRujdwNA';
// const shortCode = '174379'; // Your short code
// const lipaNaMpesaOnlineUrl = 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
// const tokenUrl = 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
// const passKey = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';
// // Function to get access token
// async function getAccessToken() {
//   const credentials = Buffer.from(`${consumerKey}:${consumerSecret}`).toString('base64');
//   try {
//     const response = await axios.get(tokenUrl, {
//       headers: {
//         'Authorization': `Basic ${credentials}`,
//       },
//     });
//     return response.data.access_token;
//   } catch (error) {
//     throw new Error('Failed to get access token');
//   }
// }

// // Route to initiate STK push
// app.post('/initiateSTKPush', async (req, res) => {
//   const { phoneNumber, amount } = req.body;

//   try {
//     const accessToken = await getAccessToken();
//     const timestamp = new Date().toISOString().replace(/[-:.TZ]/g, '').slice(0, 14);
//     const password = Buffer.from(`${shortCode}${passKey}${timestamp}`).toString('base64');

//     const response = await axios.post(lipaNaMpesaOnlineUrl, {
//       BusinessShortCode: shortCode,
//       Password: password,
//       Timestamp: timestamp,
//       TransactionType: 'CustomerPayBillOnline',
//       Amount: amount,
//       PartyA: phoneNumber,
//       PartyB: shortCode,
//       PhoneNumber: phoneNumber,
//       CallBackURL: 'https://your-callback-url.com/callback', // Replace with your callback URL
//       AccountReference: 'HotelBooking123',
//       TransactionDesc: 'Hotel Room Payment',
//     }, {
//       headers: {
//         'Authorization': `Bearer ${accessToken}`,
//         'Content-Type': 'application/json',
//       },
//     });

//     res.status(200).send('STK Push initiated successfully');
//   } catch (error) {
//     res.status(500).send(`Failed to initiate STK Push: ${error.message}`);
//   }
// });

// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => {
//   console.log(`Server is running on port ${PORT}`);
// });
const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(bodyParser.json());
app.use(cors());

const paystackSecretKey = 'sk_test_48e846f7f8dc3a8a2bba852a4b1c8c3ab1cb20d5'; // Your Paystack secret key

// Route to initiate Paystack transaction
app.post('/initiatePaystackTransaction', async (req, res) => {
  const { phoneNumber, amount } = req.body;

  try {
    // Initialize transaction
    const response = await axios.post('https://api.paystack.co/transaction/initialize', {
      email: 'kurerelagat01@gmail.com', // Replace with customer's email
      amount: amount * 100, // Paystack amount is in kobo (1 NGN = 100 kobo)
      callback_url: 'https://your-callback-url.com/paystack_callback', // Replace with your callback URL
      metadata: {
        custom_fields: [
          {
            display_name: 'Payment for',
            variable_name: 'payment_for',
            value: 'Hotel Room Payment',
          },
        ],
      },
    }, {
      headers: {
        Authorization: `Bearer ${paystackSecretKey}`,
        'Content-Type': 'application/json',
      },
    });

    // If successful, return the authorization URL to the client
    res.status(200).json({
       status: true,
        authorization_url: response.data.data.authorization_url,
        
       });
       console.log`200 init: ${response.data.data.authorization_url} `

  } catch (error) {
    // Log detailed error information
    console.error('Failed to initiate Paystack transaction:', error.response ? error.response.data : error.message);
    
    // Return appropriate error message to the client
    if (error.response && error.response.data) {
      res.status(error.response.status || 500).json({ status: false, message: `Failed to initiate Paystack transaction: ${error.response.data.message}` });
    } else {
      res.status(500).json({ status: false, message: `Failed to initiate Paystack transaction: ${error.message}` });
    }
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
