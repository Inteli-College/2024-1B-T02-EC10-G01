import 'package:flutter/material.dart';
import 'package:asky/constants.dart';

enum ButtonType { confirmation, optional }

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final ButtonType buttonType;

  const StyledButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Constants.askyBlue, // Default color, can be changed
    this.buttonType =
        ButtonType.confirmation, // Default button type is confirmation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOptional = buttonType == ButtonType.optional;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: isOptional ? Colors.white : color,
          borderRadius: BorderRadius.circular(10),
          border: isOptional
              ? Border.all(
                  color: Color.fromRGBO(26, 54, 93, 0.2),
                  width: 1,
                )
              : null,
          boxShadow: isOptional
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        width: isOptional ? double.infinity : null,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOptional ? Colors.white : color,
            foregroundColor: isOptional ? Constants.askyBlue : Colors.white,
            elevation: isOptional ? 0 : 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: isOptional? 25 : 15),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isOptional ? FontWeight.bold : FontWeight.normal,
              color: isOptional ? Constants.askyBlue : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
