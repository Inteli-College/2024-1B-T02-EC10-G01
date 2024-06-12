import 'package:asky/api/requests_assistance_api.dart';
import 'package:asky/constants.dart';
import 'package:asky/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asky/stores/pyxis_store.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:asky/widgets/dropdown.dart';
import 'package:asky/widgets/toggle.dart';
import 'package:asky/widgets/styled_button.dart';
import 'package:asky/widgets/assistanceDropdown.dart'; // Import the new assistanceDropdown widget

class AssistanceScreen extends StatefulWidget {
  @override
  _AssistanceScreenState createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  bool isLoading = false; // Add this line to manage loading state
  TextEditingController textEditingController = TextEditingController();
  dynamic selectedAssistance = 'stuckDoor';
  RequestsAssistance assistanceApi = RequestsAssistance();

  void _handleDropdownChange(dynamic newValue) {
    setState(() {
      selectedAssistance = newValue; // Update local state with new selection
    });
    print(selectedAssistance);
  }

  @override
  Widget build(BuildContext context) {
    final pyxisStore = context
        .watch<PyxisStore>(); // Continue to watch the store for other changes

    return Scaffold(
      appBar: TopBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Solicitar assistência",
                style: GoogleFonts.notoSans(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Selecione o problema",
                style: GoogleFonts.notoSans(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: AssistanceDropdown(
                    onChanged: _handleDropdownChange,
                    selectedAssistanceType: selectedAssistance),
              ),
              SizedBox(height: 40),
              Text(
                "Descrição do problema",
                style: GoogleFonts.notoSans(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(26, 54, 93, 0.2),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'O que está acontecendo?',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Added padding inside the text field
                    border: InputBorder
                        .none, // No border needed here as Container handles the visual presentation
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none, // Use BorderSide.none here
                    ),
                    
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
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
                    var response = await assistanceApi.sendRequest(
                      pyxisStore.currentPyxisData['id'],
                      selectedAssistance,
                      details: textEditingController.text,
                    );
                    setState(() {
                      isLoading =
                          false; // Set loading to false when the request completes
                    });
                    if (response != Null) {
                      Navigator.of(context).pushNamed(
                        '/nurse_request',
                        arguments: {
                          'requestId': response['id'].toString(),
                          'type': 'assistance'
                        },
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
      ),
    );
  }
}
