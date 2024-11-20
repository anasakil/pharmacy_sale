import 'package:flutter/material.dart';

import '../models/pharmacy_model.dart';

class PharmacyViewModel extends ChangeNotifier {
  List<Pharmacy> pharmacies = [
   
   
    Pharmacy(
      name: 'Pharmacie NASSIHA',
      phone: '+123456789',
      address: '123 Main St',
      latitude: 34.0725919737151,
      longitude: -6.794645637003693,
    ),
    Pharmacy(
      name: 'Pharmacie es',
      phone: '+123456789',
      address: '123 Main St',
      latitude: 34.04299642944245,
      longitude: -6.794148088209815,
    ),
  ];

  void fetchPharmacies() {
    notifyListeners();
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















// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../models/pharmacy_model.dart';

// class PharmacyViewModel extends ChangeNotifier {
//   List<Pharmacy> pharmacies = [];

//   Future<void> fetchPharmacies() async {
//     final response = await http.get(Uri.parse('http://localhost:3000/pharmacies'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       pharmacies = data.map((json) => Pharmacy.fromJson(json)).toList();
//       notifyListeners();
//     } else {
//       throw Exception("Failed to load pharmacies");
//     }
//   }

//   void showPharmacyDetails(BuildContext context, Pharmacy pharmacy) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(pharmacy.name),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Phone: ${pharmacy.phone}"),
//             Text("Address: ${pharmacy.address}"),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }
// }
