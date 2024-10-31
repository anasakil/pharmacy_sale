import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'viewmodels/pharmacy_viewmodel.dart';
import 'pharmacy_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PharmacyViewModel()..fetchPharmacies()),
      ],
      child: PharmacyLocatorApp(),
    ),
  );
}

class PharmacyLocatorApp extends StatefulWidget {
  @override
  _PharmacyLocatorAppState createState() => _PharmacyLocatorAppState();
}

class _PharmacyLocatorAppState extends State<PharmacyLocatorApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pharmacy Locator"),
        ),
        body: _selectedIndex == 0 ? _buildPharmacyMap(context) : PharmacyListScreen(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildPharmacyMap(BuildContext context) {
    final viewModel = Provider.of<PharmacyViewModel>(context);

    if (viewModel.pharmacies.isEmpty) {
      return Center(child: Text("No pharmacies available"));
    }

    final LatLng pharmacyLocation = LatLng(
      viewModel.pharmacies[0].latitude,
      viewModel.pharmacies[0].longitude,
    );

    return FlutterMap(
      options: MapOptions(
        center: pharmacyLocation,
        zoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5hc2FraWwiLCJhIjoiY20ydnpqM3BtMDFpMDJrc2cwaWVpa3lkNiJ9.Q0rlhR-xTsJ-iV4YkEuwtg",
        ),
        MarkerLayer(
          markers: viewModel.pharmacies.map((pharmacy) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(pharmacy.latitude, pharmacy.longitude),
              builder: (ctx) => GestureDetector(
                onTap: () => viewModel.showPharmacyDetails(context, pharmacy),
                child: Icon(
                  Icons.location_on,
                  color: const Color.fromARGB(255, 28, 80, 4),
                  size: 40.0,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
