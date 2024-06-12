import 'package:asky/api/request_api.dart';
import 'package:asky/api/request_material_api.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/api/requests_assistance_api.dart';
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

class AssistanceStatus {
  static const pending = "pending";
  static const accepted = "accepted";
  static const resolved = "resolved";
}

List<String> getAssistanceStatusLabels() {
  return [
    "Pending",    // corresponds to AssistanceStatus.pending
    "Accepted",   // corresponds to AssistanceStatus.accepted
    "Resolved"    // corresponds to AssistanceStatus.resolved
  ];
}

getIndexFromAssistanceStatus(status) {
  switch (status) {
    case AssistanceStatus.pending:
      return 0;
    case AssistanceStatus.accepted:
      return 1;
    case AssistanceStatus.resolved:
      return 2;
    default:
      return 0;
  }

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
    final api;
    switch (widget.type) {
      case 'material':
        api = RequestMaterialApi();
        break;
      case 'assistance':
        api = RequestsAssistance(); // Make sure to implement this API
        break;
      default:
        api = RequestMedicineApi();
    }

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
            print(requestData['emergency']);

            // Parse the original date
            DateTime createdAt = DateTime.parse(requestData['created_at']);

            // Subtract three hours
            DateTime createdAtMinus3Hours =
                createdAt.subtract(Duration(hours: 3));

            Map<dynamic, dynamic> detailsData = {};

            if (requestData['assistanceType'] != null) {
              // Retrieve the translated label from Constants.assistanceTypes using the key from requestData
              String translatedAssistanceType =
                  Constants.assistanceTypes[requestData['assistanceType']] ??
                      'Tipo desconhecido';

              // Set the translated assistance type in detailsData
              detailsData['Tipo de assistência'] = translatedAssistanceType;
            }

            if (requestData['item'] != null) {
              detailsData['Item'] = requestData['item']['name'];
            }

            detailsData['Pyxis'] = requestData['dispenser']['code'] +
                ' | Andar ' +
                requestData['dispenser']['floor'].toString();
            detailsData['Enfermeiro'] = requestData['requested_by']['name'];
            detailsData['Data'] = createdAtMinus3Hours.toString();
            if (requestData['emergency'] != null) {
              detailsData['Emergência'] = 'Sim';
            } 
            if (requestData['batch_number'] != null &&
                requestData['batch_number'] != '') {
              detailsData['Lote'] = requestData['batch_number'];
            }
            if (requestData['details'] != null &&
                requestData['details'] != '') {
              detailsData['Detalhes'] = requestData['details'];
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Solicitação de ${widget.type == 'material' ? 'material' : widget.type == 'medicine' ? 'medicamento' : 'assistência'}",
                    style: GoogleFonts.notoSans(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  StatusProgressBar(
                    currentStep: widget.type == 'assistance' ? getIndexFromAssistanceStatus(
                            requestData['status_changes'].last['status']) +
                        1 : getIndexFromStatus(
                            requestData['status_changes'].last['status']) +
                        1,
                    totalSteps: widget.type == 'assistance' ? getAssistanceStatusLabels().length : getStatusLabels().length,
                    labels: widget.type == 'assistance' ? getAssistanceStatusLabels() : getStatusLabels(),
                    activeColor: Constants.askyBlue,
                    inactiveColor: Colors.grey,
                  ),
                  SizedBox(height: 40),
                  DetailsBox(details: detailsData),
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
