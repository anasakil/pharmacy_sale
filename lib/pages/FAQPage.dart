import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "How do I locate a pharmacy?",
      "answer": "Use the map view to see nearby pharmacies. Tap on a marker to view details or navigate."
    },
    {
      "question": "How can I change the travel mode?",
      "answer": "Use the buttons at the bottom of the map to select walking or driving mode."
    },
    {
      "question": "What apps can I use for navigation?",
      "answer": "You can navigate using Apple Maps or Waze from the pharmacy action menu."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQs"),
        backgroundColor: const Color.fromARGB(255, 88, 179, 14),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return ExpansionTile(
            title: Text(
              faq['question']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(faq['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}
