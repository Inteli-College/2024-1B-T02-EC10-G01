import 'package:asky/api/request_material_api.dart';
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

class RequestMaterial extends StatefulWidget {
  @override
  _RequestMaterialState createState() => _RequestMaterialState();
}

class _RequestMaterialState extends State<RequestMaterial> {
  bool isLoading = false; // Add this line to manage loading state
  TextEditingController textEditingController = TextEditingController();
  dynamic selectedMaterial = ''; // Local state to hold selected material
  RequestMaterialApi requestMaterialApi = RequestMaterialApi();


  void _handleDropdownChange(dynamic newValue) {
    setState(() {
      selectedMaterial = newValue; // Update local state with new selection
    });
    print(selectedMaterial);
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
              "Solicitar um material",
              style: GoogleFonts.notoSans(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: RequestDropdown(
                items: pyxisStore.currentPyxisData['materials'].toList(),
                onChanged: _handleDropdownChange,
                dropdownType: 'material',
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: StyledButton(
                text: "Confirmar",
                onPressed: () async {
                  setState(() {
                    isLoading =
                        true; // Set loading to true when the request starts
                  });
                  selectedMaterial = int.parse(selectedMaterial);
                  var response = await requestMaterialApi.sendRequest(
                      pyxisStore.currentPyxisData['id'],
                      selectedMaterial,
                      );
                  setState(() {
                    isLoading =
                        false; // Set loading to false when the request completes
                  });
                  if (response != Null) {
                    print(response);
                    print(response['id']);
                    Navigator.of(context).pushNamed(
                      '/nurse_request',
                      arguments: {'requestId': response['id'].toString()},
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Something went wrong!'),
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
