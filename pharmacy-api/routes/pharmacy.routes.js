
const express = require('express');
const router = express.Router();
const Pharmacy = require('../models/pharmacy.model');

// Create a new pharmacy
router.post('/', async (req, res) => {
  const { name, phone, address, latitude, longitude } = req.body;
  const newPharmacy = new Pharmacy({ name, phone, address, latitude, longitude });
  
  try {
    await newPharmacy.save();
    res.status(201).json(newPharmacy);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Get all pharmacies
router.get('/', async (req, res) => {
  try {
    const pharmacies = await Pharmacy.find();
    res.status(200).json(pharmacies);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get a pharmacy by ID
router.get('/:id', async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findById(req.params.id);
    if (!pharmacy) return res.status(404).json({ message: 'Pharmacy not found' });
    res.status(200).json(pharmacy);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update a pharmacy
router.put('/:id', async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!pharmacy) return res.status(404).json({ message: 'Pharmacy not found' });
    res.status(200).json(pharmacy);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Delete a pharmacy
router.delete('/:id', async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findByIdAndDelete(req.params.id);
    if (!pharmacy) return res.status(404).json({ message: 'Pharmacy not found' });
    res.status(200).json({ message: 'Pharmacy deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
