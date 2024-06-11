import 'package:flutter/material.dart';

class AcceptSolicitationCard extends StatelessWidget {
  final String medicineName;
  final String floor;
  final String pyxis;
  final String isUrgent;  // 'Urgente' or 'Comum'
  
  const AcceptSolicitationCard({
    Key? key,
    required this.medicineName,
    required this.floor,
    required this.pyxis,
    required this.isUrgent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(medicineName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Andar $floor | Pyxis $pyxis", style: TextStyle(fontSize: 16, color: Colors.grey[850])),
              SizedBox(height: 8),
              Text(isUrgent, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isUrgent == 'Urgente' ? Colors.red : Colors.black)),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(top: 30), 
              child: FloatingActionButton(
                onPressed: () {
                  //
                  //
                  //
                  //
                },
                child: Text('Aceitar', style: TextStyle(color: Colors.white)), // Text color set to white
                backgroundColor: Color(0xFF1A365D), // Hex color converted to Flutter color
                // Removed mini: true to use default size, adjust if a specific size is needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}