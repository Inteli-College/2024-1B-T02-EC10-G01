import 'package:asky/constants.dart';
import 'package:flutter/material.dart';

class LastRequestCard extends StatelessWidget {
  final String medicineName;
  final int currentStep;
  final int totalSteps;

  const LastRequestCard({Key? key, required this.medicineName, required this.currentStep, required this.totalSteps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            SizedBox(height: 20),
            StepProgressIndicator(totalSteps: totalSteps, currentStep: currentStep),
          ],
        ),
      ),
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
            color: index < currentStep ? Color(0xFFcdedfe).withOpacity(0.9) : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      )),
    );
  }
}