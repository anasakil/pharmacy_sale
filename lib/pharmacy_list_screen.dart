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
      ),
      body: viewModel.pharmacies.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading if pharmacies are empty
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
