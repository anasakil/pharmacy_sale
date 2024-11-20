import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/CustomDrawer.dart';
import '../viewmodels/pharmacy_viewmodel.dart';
import '../utils/tokenmapbox.dart'; // Import the token here

class PharmacyMapPage extends StatefulWidget {
  @override
  _PharmacyMapPageState createState() => _PharmacyMapPageState();
}

class _PharmacyMapPageState extends State<PharmacyMapPage> {
  List<LatLng> routePoints = [];
  String travelTime = "";
  String selectedMode = 'driving';
  LatLng userLocation = LatLng(34.06854820134339, -6.7639096);

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    getUserLocation();
  }

  Future<void> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> fetchRouteAndTime(LatLng destination) async {
    final String url =
        'https://api.mapbox.com/directions/v5/mapbox/$selectedMode/${userLocation.longitude},${userLocation.latitude};${destination.longitude},${destination.latitude}?geometries=geojson&access_token=$mapboxToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0];
      final geometry = route['geometry']['coordinates'];
      final durationInSeconds = route['duration'];

      setState(() {
        routePoints = geometry.map<LatLng>((coord) {
          return LatLng(coord[1], coord[0]);
        }).toList();
        travelTime = '${(durationInSeconds / 60).toStringAsFixed(1)} min';
      });
    } else {
      print('Failed to fetch route data');
    }
  }

  // Function to open Apple Maps
  void openAppleMaps(LatLng location) async {
    final url =
        'https://maps.apple.com/?daddr=${location.latitude},${location.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('Could not open Apple Maps');
    }
  }

  // Function to open Waze
  void openWaze(LatLng location) async {
    final url = Uri.parse(
        'https://waze.com/ul?ll=${location.latitude},${location.longitude}&navigate=yes');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not open Waze in the browser');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PharmacyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("L9a Pharmacy"),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 199, 15),
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(center: userLocation, zoom: 14.0),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: userLocation,
                    builder: (ctx) => Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 40.0,
                    ),
                  ),
                ]..addAll(
                    viewModel.pharmacies.map((pharmacy) {
                      return Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(pharmacy.latitude, pharmacy.longitude),
                        builder: (ctx) => GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Select Action'),
                                content: Text('What would you like to do?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      fetchRouteAndTime(LatLng(
                                          pharmacy.latitude, pharmacy.longitude));
                                    },
                                    child: Text("Navigate"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      viewModel.showPharmacyDetails(
                                          context, pharmacy);
                                    },
                                    child: Text("View Details"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      openAppleMaps(LatLng(pharmacy.latitude,
                                          pharmacy.longitude));
                                    },
                                    child: Text("Apple Maps"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      openWaze(LatLng(pharmacy.latitude,
                                          pharmacy.longitude));
                                    },
                                    child: Text("Waze"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Icon(Icons.location_on,
                              color: Colors.green, size: 40.0),
                        ),
                      );
                    }).toList(),
                  ),
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(polylines: [
                  Polyline(
                      points: routePoints, strokeWidth: 4.0, color: Colors.blue)
                ]),
            ],
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Column(
              children: [
                if (travelTime.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Text(
                      'Estimated travel time: $travelTime',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedMode = 'walking';
                        });
                        if (viewModel.pharmacies.isNotEmpty) {
                          fetchRouteAndTime(LatLng(
                              viewModel.pharmacies[0].latitude,
                              viewModel.pharmacies[0].longitude));
                        }
                      },
                      child: Text('walking'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedMode = 'driving';
                        });
                        if (viewModel.pharmacies.isNotEmpty) {
                          fetchRouteAndTime(LatLng(
                              viewModel.pharmacies[0].latitude,
                              viewModel.pharmacies[0].longitude));
                        }
                      },
                      child: Text('driving'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
