import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asky/stores/pyxis_store.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:asky/widgets/dropdown.dart';
import 'package:asky/widgets/toggle.dart';
import 'package:asky/widgets/styled_button.dart';
import 'package:asky/widgets/input.dart'; // Ensure your custom input widget is imported correctly

class RequestMedicine extends StatefulWidget {
  @override
  _RequestMedicineState createState() => _RequestMedicineState();
}

class _RequestMedicineState extends State<RequestMedicine> {
  bool toggleValue = false; // Initial value for the toggle
  TextEditingController textEditingController =
      TextEditingController(); // Controller for the input field
  String inputFieldButtonText =
      "Número de lote"; // Initial button text for the input field

  void _handleToggle(bool newValue) {
    setState(() {
      toggleValue = newValue;
    });
    // Additional actions based on toggle can be implemented here
  }

  @override
  Widget build(BuildContext context) {
    final pyxisStore =
        context.watch<PyxisStore>(); // Watch the store for changes

    return Scaffold(
      appBar: AppBar(
        title: const Text('ASKY',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color(0xFF1A365D),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Solicitar um medicamento",
              style: GoogleFonts.notoSans(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Observer(
                builder: (_) {
                  return RequestDropdown(
                    items: pyxisStore.currentPyxisData['medicines'].toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: RequestToggle(
                initialValue: toggleValue,
                onToggle: _handleToggle,
              ),
            ),
            SizedBox(height: 40),
            Visibility(
              visible:
                  toggleValue, // Controls visibility based on the toggle state
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures the column only takes the space it needs
                  children: [
                    CustomInputField(
                      controller: textEditingController,
                      buttonText: inputFieldButtonText,
                    ),
                    SizedBox(
                        height:
                            40), // Spacing between the input field and the next widget
                  ],
                ),
              ),
            ),
            Center(
              child: StyledButton(
                text: "Confirmar",
                onPressed: () {
                  print('Confirm Button Pressed!');
                  // Add more actions here as needed
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
