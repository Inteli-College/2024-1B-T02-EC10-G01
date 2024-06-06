import 'package:flutter/material.dart';
import 'package:asky/constants.dart';

class RequestToggle extends StatefulWidget {
  final bool initialValue;  // true for "Emergência", false for "Normal"
  final Function(bool) onToggle;

  RequestToggle({required this.initialValue, required this.onToggle});

  @override
  _RequestToggleState createState() => _RequestToggleState();
}

class _RequestToggleState extends State<RequestToggle> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialValue;
  }

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
          _buildOption("Normal", false),
          _buildOption("Emergência", true),
        ],
      ),
    );
  }

  Widget _buildOption(String text, bool value) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _isSelected = value;
            widget.onToggle(value);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: _isSelected == value ? Constants.askyBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),  // Rounded corners for both options
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            text,
            style: TextStyle(
              color: _isSelected == value ? Colors.white : Constants.askyBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
