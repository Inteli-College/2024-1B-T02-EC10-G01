import 'package:flutter/material.dart';
import 'package:asky/constants.dart';

class AssistanceDropdown extends StatelessWidget {
  final String? selectedAssistanceType;
  final ValueChanged<String?> onChanged;

  const AssistanceDropdown({
    Key? key,
    required this.selectedAssistanceType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   List<DropdownMenuItem<String>> dropdownItems = Constants.assistanceTypes
      .map((key, value) => MapEntry(
          key,
          DropdownMenuItem(
            value: key,
            child: Text(value),
          )))
      .values
      .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color.fromRGBO(26, 54, 93, 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: Colors.white,
          value: selectedAssistanceType,
          hint: Text('Selecione um tipo de assistência',
            style: TextStyle(color: Constants.askyBlue),
          ),
          icon: Icon(Icons.arrow_drop_down, color: Constants.askyBlue),
          onChanged: onChanged,
          items: dropdownItems,
        ),
      ),
    );
  }
}
