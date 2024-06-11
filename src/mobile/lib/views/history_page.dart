import 'package:flutter/material.dart';
import 'package:asky/constants.dart'; // Ensure constants are defined in this import
import 'package:asky/views/request_details_screen.dart'; // Assuming this is the route for RequestDetailsScreen

class HistoryPage extends StatelessWidget {
  final String medicineName;
  final int currentStep;
  final int totalSteps;
  final String pyxis;
  final String id;

  const HistoryPage({
    Key? key, 
    required this.pyxis,
    required this.id,
    required this.medicineName, 
    required this.currentStep, 
    required this.totalSteps
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text('Última Solicitação', style: TextStyle(fontSize: 20, color: Constants.askyBlue, fontWeight: FontWeight.bold)),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context, 
              '/nurse_request', // This is the route name for RequestDetailsScreen
              arguments: {'requestId': id} // Passing id as an argument
            );
          },
          child: Card(
            color: Constants.askyBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Medicamento: $medicineName', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Pyxis $pyxis', style: TextStyle(fontSize: 16, color: Colors.white)),

                  SizedBox(height: 20),
                  StepProgressIndicator(totalSteps: totalSteps, currentStep: currentStep),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  StepProgressIndicator({required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) => Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          height: 10,
          decoration: BoxDecoration(
            color: index < currentStep ? Colors.white.withOpacity(0.9) : Color(0xFFcdedfe).withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      )),
    );
  }
}
