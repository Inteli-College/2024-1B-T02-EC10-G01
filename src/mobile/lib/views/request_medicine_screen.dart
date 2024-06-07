import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/widgets/top_bar.dart';
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
  bool toggleValue = false;
  TextEditingController textEditingController = TextEditingController();
  String inputFieldButtonText = "Número de lote";
  dynamic selectedMedicine = ''; // Local state to hold selected medicine
  RequestMedicineApi requestMedicineApi = RequestMedicineApi();

  void _handleToggle(bool newValue) {
    setState(() {
      toggleValue = newValue;
    });
  }

  void _handleDropdownChange(dynamic newValue) {
    setState(() {
      selectedMedicine = newValue; // Update local state with new selection
    });
  }

  @override
  Widget build(BuildContext context) {
    final pyxisStore = context.watch<PyxisStore>(); // Continue to watch the store for other changes

    return Scaffold(
      appBar: TopBar(),
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
              child: RequestDropdown(
                items: pyxisStore.currentPyxisData['medicines'].toList(),
                onChanged: _handleDropdownChange,
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
              visible: toggleValue,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomInputField(
                      controller: textEditingController,
                      buttonText: inputFieldButtonText,
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Center(
              child: StyledButton(
                text: "Confirmar",
                onPressed: () async {
                  final batchNumber = toggleValue ? textEditingController.text : '';
                  selectedMedicine = int.parse(selectedMedicine);
                  await requestMedicineApi.sendRequest(pyxisStore.currentPyxisData['id'], selectedMedicine, toggleValue); 
                  print('Confirm Button Pressed with Medicine: $selectedMedicine');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}