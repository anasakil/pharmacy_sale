import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/pharmacy_model.dart';

class PharmacyViewModel extends ChangeNotifier {
  List<Pharmacy> pharmacies = [];

  Future<void> fetchPharmacies() async {
    final response = await http.get(Uri.parse('http://localhost:3000/pharmacies'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      pharmacies = data.map((json) => Pharmacy.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception("Failed to load pharmacies");
    }
  }

  void showPharmacyDetails(BuildContext context, Pharmacy pharmacy) {
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
