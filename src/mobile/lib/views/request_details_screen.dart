import 'package:asky/constants.dart';
import 'package:asky/widgets/read_feedback.dart';
import 'package:asky/widgets/request_details_box.dart';
import 'package:asky/widgets/status_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:asky/widgets/top_bar.dart';
import 'package:asky/widgets/bottom_bar.dart'; // Make sure this is the correct import path
import 'package:asky/stores/request_store.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/widgets/home_nurse_body.dart';
import 'package:asky/views/history_page.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String requestId;

  RequestDetailsScreen({Key? key, required this.requestId}) : super(key: key);

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  int _selectedIndex = 0;  // Assuming the details screen is at index 0, adjust as necessary


  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    HomeNurseBody(),
    HistoryPage(),
    Text('USER', style: optionStyle),
  ];


  @override
  Widget build(BuildContext context) {
    RequestMedicineApi apiService = RequestMedicineApi(); // Create an instance of your API service

    return Scaffold(
      appBar: TopBar(backRoute: '/nurse',),
      body: Observer(builder: (_) {
        return FutureBuilder<dynamic>(
          future: apiService.getRequestById(int.parse(widget.requestId)), // Fetching details using the requestId
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // Decode the data if needed and display it
            var requestData = snapshot.data; // Assuming this is the result decoded as needed
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Solicitação #${widget.requestId}", // Displaying the request ID
                    style: GoogleFonts.notoSans(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                   SizedBox(height: 20),
                  StatusProgressBar(
                    currentStep: 1,
                    totalSteps: 4,
                    labels: ['Solicitado', 'Aceito', 'Em preparo', 'Entregue'],
                    activeColor: Constants.askyBlue,
                    inactiveColor: Colors.grey,
                  ),
                  SizedBox(height: 40),
                  DetailsBox(
                    details: {
                      'Item': requestData['medicine']['name'],
                      'Pyxis': requestData['dispenser']['code'] + ' | Andar ' + requestData['dispenser']['floor'].toString(),
                      'Enfermeiro': requestData['requested_by']['name'],
                      'Data': requestData['created_at'],
                    },
                  ),
                   SizedBox(height: 40),
                  ReadFeedbackWidget(),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(  // Adjust with actual implementation details
        selectedIndex: _selectedIndex,
        onTabChange: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          // Add navigation or interaction logic as needed
        },
      ),
    );
  }
}
