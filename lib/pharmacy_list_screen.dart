import 'package:flutter/material.dart';
import 'viewmodels/pharmacy_viewmodel.dart';
import 'package:provider/provider.dart';

class PharmacyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PharmacyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmacy List"),
        backgroundColor: Color.fromARGB(255, 88, 179, 14),
      ),
      body: viewModel.pharmacies.isEmpty
          ? Center(child: CircularProgressIndicator()) 
          : ListView.builder(
              itemCount: viewModel.pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = viewModel.pharmacies[index];
                return ListTile(
                  title: Text(pharmacy.name),
                  subtitle: Text(pharmacy.address),
                  onTap: () => viewModel.showPharmacyDetails(context, pharmacy),
                );
              },
            ),
    );
  }
}
