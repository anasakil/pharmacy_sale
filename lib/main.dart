// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'viewmodels/pharmacy_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PharmacyViewModel()),
      ],
      child: PharmacyLocatorApp(),
    ),
  );
}

class PharmacyLocatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PharmacyMapScreen(),
    );
  }
}

class PharmacyMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PharmacyViewModel>(context);
    final LatLng pharmacyLocation = LatLng(
      viewModel.pharmacy.latitude,
      viewModel.pharmacy.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmacy Locator"),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: pharmacyLocation,
          zoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5hc2FraWwiLCJhIjoiY20ydnpqM3BtMDFpMDJrc2cwaWVpa3lkNiJ9.Q0rlhR-xTsJ-iV4YkEuwtg",
            additionalOptions: {
              'access_token':
                  'pk.eyJ1IjoiYW5hc2FraWwiLCJhIjoiY20ydnpqM3BtMDFpMDJrc2cwaWVpa3lkNiJ9.Q0rlhR-xTsJ-iV4YkEuwtg',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: pharmacyLocation,
                builder: (ctx) => GestureDetector(
                  onTap: () => viewModel.showPharmacyDetails(context),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
