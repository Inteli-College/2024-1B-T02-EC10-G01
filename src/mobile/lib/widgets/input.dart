import 'package:flutter/material.dart';
import 'package:asky/constants.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String buttonText;  // New parameter to accept the button text

  CustomInputField({
    required this.controller,
    required this.buttonText,  // Require the button text during initialization
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromRGBO(26, 54, 93, 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,  // Removes default underline of input field
                hintText: widget.buttonText,
                hintStyle: TextStyle(
                  color: Constants.askyBlue,  // Hint text uses the same color as the toggle options
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}
