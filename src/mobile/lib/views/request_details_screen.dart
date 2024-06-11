import 'package:asky/api/request_api.dart';
import 'package:asky/api/request_material_api.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/constants.dart';
import 'package:asky/widgets/read_feedback.dart';
import 'package:asky/widgets/request_details_box.dart';
import 'package:asky/widgets/status_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:asky/widgets/top_bar.dart';
import 'package:asky/widgets/bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asky/views/history_page.dart';
import 'package:asky/widgets/home_nurse_body.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String requestId;
  final String type;

  RequestDetailsScreen(
      {Key? key, required this.requestId, this.type = 'medicine'})
      : super(key: key);

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    HomeNurseBody(),
    HistoryPage(),
    Text('USER', style: optionStyle),
  ];

  @override
  void initState() {
    super.initState();
    print(
        'RequestDetailsScreen initialized with requestId: ${widget.requestId} and type: ${widget.type}');
  }

  @override
  Widget build(BuildContext context) {
    final RequestApi api =
        widget.type == 'material' ? RequestMaterialApi() : RequestMedicineApi();
    print('Building RequestDetailsScreen with requestId: ${widget.requestId}');

    return Scaffold(
      appBar: TopBar(backRoute: '/nurse'),
      body: Observer(builder: (_) {
        return FutureBuilder<dynamic>(
          future: api.getRequestById(int.parse(widget.requestId)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            var requestData = snapshot.data;
            print('Request data: $requestData');

                        // Parse the original date
            DateTime createdAt = DateTime.parse(requestData['created_at']);

            // Subtract three hours
            DateTime createdAtMinus3Hours = createdAt.subtract(Duration(hours: 3));

            Map<String, String> detailsData = {
              'Item': requestData['item']['name'],
              'Pyxis': requestData['dispenser']['code'] +
                  ' | Andar ' +
                  requestData['dispenser']['floor'].toString(),
              'Enfermeiro': requestData['requested_by']['name'],
              'Data': createdAtMinus3Hours.toString(),
            };

            if (requestData['emergency'] != null) {
              detailsData['Emergência'] = 'Sim';
            } else {
              detailsData['Emergência'] = 'Não';
            }

            if (requestData['batch_number'] != null && requestData['batch_number'] != '') {
              detailsData['Lote'] = requestData['batch_number'];
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Solicitação de ${widget.type == 'material' ? 'material' : 'medicamento'}",
                    style: GoogleFonts.notoSans(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  StatusProgressBar(
                    currentStep: getIndexFromStatus(requestData['status_changes'].last['status']) + 1,
                    totalSteps: getStatusLabels().length,
                    labels: getStatusLabels(),
                    activeColor: Constants.askyBlue,
                    inactiveColor: Colors.grey,
                  ),
                  SizedBox(height: 40),
                  DetailsBox(
                    details: detailsData
                  ),
                  SizedBox(height: 40),
                  ReadFeedbackWidget(),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(
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
