// lib/viewmodels/pharmacy_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/pharmacy_model.dart';

class PharmacyViewModel extends ChangeNotifier {
  // Pharmacy location details
  final Pharmacy pharmacy = Pharmacy(
    name: "Pharmacy Garde",
    phone: "+123456789",
    address: "34.0634, -6.7745",
    latitude: 34.06346399450203,
    longitude: -6.774515380780635,
  );

  void showPharmacyDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pharmacy.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Phone: ${pharmacy.phone}"),
            Text("Address: ${pharmacy.address}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
