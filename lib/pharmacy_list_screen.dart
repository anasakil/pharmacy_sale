import 'package:flutter/material.dart';
import 'viewmodels/pharmacy_viewmodel.dart';
import 'package:provider/provider.dart';

class PharmacyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PharmacyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmacyyy List"),
        backgroundColor: Color.fromARGB(255, 88, 179, 14),
      ),
     body: viewModel.pharmacies.isEmpty
    ? Center(child: CircularProgressIndicator())
    : ListView.builder(
        itemCount: viewModel.pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = viewModel.pharmacies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),  
              ),
              elevation: 4.0,  // Card shadow
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0), 
                    Text(
                      pharmacy.address,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 12.0), 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => viewModel.showPharmacyDetails(context, pharmacy),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 88, 179, 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text("View Details"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

    );
  }
}
