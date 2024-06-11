import 'package:flutter/material.dart';
import 'package:asky/constants.dart';

class RequestDropdown extends StatefulWidget {
  final List<dynamic> items;
  final dynamic initialSelectedItem;
  final ValueChanged<dynamic> onChanged;
  final String dropdownType; // Optional argument for dropdown type

  RequestDropdown({
    required this.items,
    this.initialSelectedItem,
    required this.onChanged,
    this.dropdownType = 'medicine', // Default value set to 'medicine'
  });

  @override
  _RequestDropdownState createState() => _RequestDropdownState();
}

class _RequestDropdownState extends State<RequestDropdown> {
  dynamic _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelectedItem;
  }

  @override
  Widget build(BuildContext context) {
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
        child: DropdownButton<dynamic>(
          isExpanded: true,
          value: _selectedItem,
          hint: Text(
            'Selecione o medicamento',
            style: TextStyle(color: Constants.askyBlue),
          ),
          icon: Icon(Icons.arrow_drop_down, color: Constants.askyBlue),
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedItem = newValue;
            });
            widget.onChanged(newValue);
          },
          items: widget.items.map<DropdownMenuItem<dynamic>>((dynamic value) {
            return DropdownMenuItem<dynamic>(
              value: value['id'].toString(),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                child: Text(
                  widget.dropdownType == 'medicine'
                      ? '${value['name']} ${value['dosage']}'
                      : value['name'].toString(),
                  style: TextStyle(color: Constants.askyBlue),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
