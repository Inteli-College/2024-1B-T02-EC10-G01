import 'package:flutter/material.dart';
import 'package:asky/constants.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const StyledButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Constants.askyBlue,  // Default color, can be changed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(  // Wraps the button's container in a Center widget
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
