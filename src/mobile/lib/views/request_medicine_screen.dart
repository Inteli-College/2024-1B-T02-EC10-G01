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
  bool isLoading = false; // Add this line to manage loading state
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
    final pyxisStore = context
        .watch<PyxisStore>(); // Continue to watch the store for other changes

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
                  setState(() {
                    isLoading =
                        true; // Set loading to true when the request starts
                  });
                  final batchNumber =
                      toggleValue ? textEditingController.text : '';
                  if (toggleValue && batchNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Número de lote é obrigatório!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }
                  try {
                    final selectedMedicineInt = int.parse(selectedMedicine);
                    var response = await requestMedicineApi.sendRequest(
                      pyxisStore.currentPyxisData['id'],
                      selectedMedicineInt,
                      emergency: toggleValue,
                    );
                    setState(() {
                      isLoading =
                          false; // Set loading to false when the request completes
                    });
                    if (response != null) {
                      print('INDO PARA REQUESTS');
                      print(response);
                      print(response['medicine_id']);
                      print(response['medicine_id'].toString());
                      var medicineId = response['medicine_id'];
                      if (medicineId != null) {
                        print('Medicine ID: $medicineId');
                        print('Medicine ID (String): ${medicineId.toString()}');

                        Navigator.of(context).pushNamed(
                          '/nurse_request',
                          arguments: {'requestId': medicineId.toString()},
                        );
                      } else {
                        print('Error: Medicine ID is null');
                        // Handle the case where medicine_id is null
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Something went wrong!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    print('ERROR: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid medicine selection!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(), // Show loading indicator when isLoading is true
          ],
        ),
      ),
    );
  }
}
