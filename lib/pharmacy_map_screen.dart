// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:provider/provider.dart';
// import 'package:latlong2/latlong.dart';
// import 'viewmodels/pharmacy_viewmodel.dart';

// class PharmacyMapScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<PharmacyViewModel>(context);

//     if (viewModel.pharmacies.isEmpty) {
//       return Center(child: CircularProgressIndicator()); 
//     }

//     return FlutterMap(
//       options: MapOptions(
//         center: LatLng(
//           viewModel.pharmacies[0].latitude,
//           viewModel.pharmacies[0].longitude,
//         ),
//         zoom: 14.0,
//       ),
//       children: [
//         TileLayer(
//           urlTemplate:
//               "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5hc2FraWwiLCJhIjoiY20ydnpqM3BtMDFpMDJrc2cwaWVpa3lkNiJ9.Q0rlhR-xTsJ-iV4YkEuwtg",
//         ),
//         MarkerLayer(
//           markers: viewModel.pharmacies.map((pharmacy) {
//             return Marker(
//               width: 80.0,
//               height: 80.0,
//               point: LatLng(pharmacy.latitude, pharmacy.longitude),
//               builder: (ctx) => GestureDetector(
//                 onTap: () => viewModel.showPharmacyDetails(context, pharmacy),
//                 child: Icon(
//                   Icons.location_on,
//                   color: const Color.fromARGB(255, 95, 255, 20),
//                   size: 40.0,
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
