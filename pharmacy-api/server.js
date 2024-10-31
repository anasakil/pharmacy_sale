
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const pharmacyRoutes = require('./routes/pharmacy.routes');

const app = express();
const PORT = process.env.PORT || 3000;
const MONGODB_URI = 'mongodb+srv://farawiakil:QE9uMObj1ldNssdo@cluster0.gpmspgl.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0'; 

app.use(cors());
app.use(bodyParser.json());
app.use('/pharmacies', pharmacyRoutes);

mongoose.connect(MONGODB_URI, {  })
  .then(() => {
    console.log('Connected to MongoDB');
    app.listen(PORT, () => {
      console.log(`Server is running on http://localhost:${PORT}`);
    });
  })
  .catch(err => console.log(err));
