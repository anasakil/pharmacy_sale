import 'package:flutter/material.dart';
import '../models/pharmacy_model.dart';

class PharmacyViewModel extends ChangeNotifier {
  List<Pharmacy> _pharmacies = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  List<Pharmacy> get pharmacies => _pharmacies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPharmacies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 2));

      _pharmacies = [
        Pharmacy(
          name: 'Pharmacie NASSIHA',
          phone: '+123456789',
          address: 'sale maroc 232',
          latitude: 34.0725919737151,
          longitude: -6.794645637003693,
        ),
        Pharmacy(
          name: 'Pharmacie NASS',
          phone: '+123456789',
          address: '73 SALE ',
          latitude: 34.06224878784792,
          longitude: -6.781348303380826,
        ),
        Pharmacy(
          name: 'Pharmacie rabat',
          phone: '+123456789',
          address: '1232 sale',
          latitude: 34.02343983994658,
          longitude: -6.831924792441817,
        ),
        Pharmacy(
          name: 'Pharmacie hasaan',
          phone: '+123456789',
          address: '123 rabat',
          latitude: 34.01889516187029,
          longitude: -6.823075974405207,
        ),
        Pharmacy(
          name: 'Pharmacie ASS',
          phone: '+123456789',
          address: '456 sale',
          latitude: 34.04299642944245,
          longitude: -6.794148088209815,
        ),
      ];
    } catch (e) {
      _errorMessage = 'Impossible de charger les pharmacies. Veuillez réessayer.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Affiche les détails d'une pharmacie dans une boîte de dialogue
  void showPharmacyDetails(BuildContext context, Pharmacy pharmacy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pharmacy.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📞 Téléphone: ${pharmacy.phone}"),
            SizedBox(height: 10),
            Text("📍 Adresse: ${pharmacy.address}"),
            SizedBox(height: 10),
            Text("🌍 Latitude: ${pharmacy.latitude}"),
            Text("🌍 Longitude: ${pharmacy.longitude}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Fermer"),
          ),
        ],
      ),
    );
  }
}
