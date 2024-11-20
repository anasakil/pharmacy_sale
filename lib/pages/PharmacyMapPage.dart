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
import '../utils/tokenmapbox.dart';

class PharmacyMapPage extends StatefulWidget {
  @override
  _PharmacyMapPageState createState() => _PharmacyMapPageState();
}

class _PharmacyMapPageState extends State<PharmacyMapPage> {
  List<LatLng> routePoints = [];
  String travelTime = "";
  String selectedMode = 'driving';
  LatLng userLocation = LatLng(34.064820134339, -6.7639096);
  bool isRouteVisible = false;
  MapController mapController = MapController(); 

  @override
  void initState() {
    super.initState();
    checkLocationPermission(); // Vérifie la permission de localisation à l'initialisation
    getUserLocation(); // Récupère la localisation de l'utilisateur
  }

  // Fonction pour vérifier la permission de localisation
  Future<void> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request(); // Demande la permission si elle n'est pas accordée
    }
  }

  // Fonction pour récupérer la localisation de l'utilisateur
  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude); // Met à jour la position de l'utilisateur
    });
  }

  // Fonction pour récupérer l'itinéraire et le temps de trajet entre l'utilisateur et la pharmacie
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
        travelTime = '${(durationInSeconds / 60).toStringAsFixed(1)} min'; // Calcule et affiche le temps estimé
        isRouteVisible = true; // Affiche l'itinéraire
      });
    } else {
      print('Échec de la récupération des données d\'itinéraire');
    }
  }

  // Fonction pour ouvrir l'application Waze avec la destination
  void openWaze(LatLng location) async {
    final url = Uri.parse(
        'https://waze.com/ul?ll=${location.latitude},${location.longitude}&navigate=yes');
    if (await canLaunchUrl(url)) {
      await launchUrl(url); // Ouvre Waze avec la destination
    } else {
      print('Impossible d\'ouvrir Waze dans le navigateur');
    }
  }

  // Fonction pour ouvrir Google Maps avec la destination et le mode de transport
  void openGoogleMaps(LatLng location) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}&travelmode=$selectedMode';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); // Ouvre Google Maps avec la destination
    } else {
      print('Impossible d\'ouvrir Google Maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PharmacyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("L9a Pharmacy"), // Titre de l'application
        ),
        backgroundColor: const Color.fromARGB(255, 98, 199, 15),
      ),
      drawer: CustomDrawer(), // Menu latéral personnalisé
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController, 
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
                                  // Options de navigation ou d'affichage des détails
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      fetchRouteAndTime(LatLng(
                                          pharmacy.latitude,
                                          pharmacy.longitude)); // Récupère l'itinéraire vers la pharmacie
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.directions,
                                            color: Colors.blue), 
                                        SizedBox(width: 8),
                                        Text("Navigate in this app"),
                                      ],
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      viewModel.showPharmacyDetails(
                                          context, pharmacy); // Affiche les détails de la pharmacie
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.info,
                                            color:
                                                Colors.green), 
                                        SizedBox(width: 8),
                                        Text("View Details"),
                                      ],
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      openWaze(LatLng(pharmacy.latitude,
                                          pharmacy.longitude)); // Ouvre Waze avec la pharmacie sélectionnée
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.directions_car,
                                            color: Colors.red), 
                                        SizedBox(width: 8),
                                        Text("Navigate with Waze"),
                                      ],
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      openGoogleMaps(LatLng(pharmacy.latitude,
                                          pharmacy.longitude)); // Ouvre Google Maps avec la pharmacie sélectionnée
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.map,
                                            color: Colors.blue), 
                                        SizedBox(width: 8),
                                        Text("Navigate with Google Maps"),
                                      ],
                                    ),
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
              if (isRouteVisible)
                PolylineLayer(polylines: [
                  Polyline(
                      points: routePoints, strokeWidth: 4.0, color: Colors.blue)
                ]), // Affiche l'itinéraire sur la carte
            ],
          ),
          if (isRouteVisible)
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    routePoints.clear(); // Efface l'itinéraire
                    travelTime = '';
                    isRouteVisible = false;
                  });
                },
                child: Text('Close Route'), // Bouton pour fermer l'itinéraire
              ),
            ),
          if (isRouteVisible && travelTime.isNotEmpty)
            Positioned(
              bottom: 80.0,
              left: 16.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.white,
                child: Text(
                  'Estimated travel time: $travelTime', // Affiche le temps estimé de trajet
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                mapController.move(userLocation, 14.0); // Centre la carte sur la position de l'utilisateur
              },
              child: Icon(Icons.my_location),
              backgroundColor: const Color.fromARGB(255, 7, 214, 25),
            ),
          ),
        ],
      ),
    );
  }
}
