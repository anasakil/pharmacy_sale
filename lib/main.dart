import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/pharmacy_viewmodel.dart';
import 'components/CustomDrawer.dart';
import 'pages/PharmacyMapPage.dart';
import 'pages/PharmacyListPage.dart';
import 'pages/AboutPage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PharmacyViewModel()..fetchPharmacies()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PharmacyMapPage(),
        routes: {
          '/map': (context) => PharmacyMapPage(),
          '/list': (context) => PharmacyListPage(),
          '/about': (context) => AboutPage(),
        },
      ),
    ),
  );
}
