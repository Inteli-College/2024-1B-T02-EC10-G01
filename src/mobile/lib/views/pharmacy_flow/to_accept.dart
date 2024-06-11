import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asky/widgets/pharmacy_flow_widgets/accept_solicitation_card.dart'; // Make sure this path is correct

class AcceptSolicitationPage extends StatefulWidget {
  @override
  _AcceptSolicitationPageState createState() => _AcceptSolicitationPageState();
}

class _AcceptSolicitationPageState extends State<AcceptSolicitationPage> {
  List<Map<String, dynamic>> medications = [
    {
      'medicineName': 'Ibuprofeno',
      'pyxis': '01',
      'isUrgent': "Urgente",
      'floor': 'Floor 1', 
          },
    {
      'medicineName': 'Paracetamol',
      'pyxis': '02',
      'isUrgent': "",
      'floor': 'Floor 2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Requests', style: GoogleFonts.notoSans()),
      ),
      body: ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final item = medications[index];
          return AcceptSolicitationCard(
            medicineName: item['medicineName'],
            pyxis: item['pyxis'],
            floor: item['floor'], // Pass floor
            isUrgent: item['isUrgent'] // Pass status
          );
        },
      ),
    );
  }
}