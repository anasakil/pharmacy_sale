import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/pharmacy_viewmodel.dart';
import 'components/CustomDrawer.dart';
import 'pages/PharmacyMapPage.dart';
import 'pages/PharmacyListPage.dart';
import 'pages/AboutPage.dart';
import 'pages/FAQPage.dart';
import 'components/SplashScreen.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PharmacyViewModel()..fetchPharmacies()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<PharmacyViewModel>(
        builder: (context, pharmacyViewModel, _) {
          return pharmacyViewModel.isLoading
              ? SplashScreen() 
              : PharmacyMapPage(); 
        },
      ),
      routes: {
        '/map': (context) => PharmacyMapPage(),
        '/list': (context) => PharmacyListPage(),
        '/about': (context) => AboutPage(),
        '/faq': (context) => FAQPage(),
      },
    );
  }
}
