import 'package:asky/constants.dart';
import 'package:flutter/material.dart';
import 'package:asky/widgets/last_solicitation_card.dart';
import 'package:asky/api/request_material_api.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/api/requests_assistance_api.dart';
import 'package:asky/api/last_request_api.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asky/widgets/status_progress_bar.dart';
import 'package:asky/widgets/home_nurse_body.dart';
import 'package:asky/widgets/request_details_box.dart';
import 'package:asky/widgets/read_feedback.dart';

class AssistanceStatus {
  static const pending = "pending";
  static const accepted = "accepted";
  static const resolved = "resolved";

  static List<String> getAssistanceStatusLabels() {
    return [
      "Pendente", // corresponds to AssistanceStatus.pending
      "Aceito", // corresponds to AssistanceStatus.accepted
      "Resolvido" // corresponds to AssistanceStatus.resolved
    ];
  }

  static String getStatusDescription(String status) {
    int index = getIndexFromAssistanceStatus(status);
    return getAssistanceStatusLabels()[index];
  }

  static int getIndexFromAssistanceStatus(String status) {
    switch (status) {
      case AssistanceStatus.pending:
        return 0;
      case AssistanceStatus.accepted:
        return 1;
      case AssistanceStatus.resolved:
        return 2;
      default:
        return 0; // Default to "Pendente" if status is unknown
    }
  }

  static Color getColorFromStatus(String status) {
    switch (status) {
      case AssistanceStatus.pending:
        return Colors.orange;
      case AssistanceStatus.accepted:
        return Colors.blue;
      case AssistanceStatus.resolved:
        return Colors.green;
      default:
        return Colors.grey; // Default to grey if status is unknown
    }
  }
}

class RequestDetailsBox extends StatefulWidget {
  final String requestId;
  final String type;
  final String userRole;

  RequestDetailsBox({Key? key, required this.requestId, this.type = 'medicine', this.userRole = 'nurse'	})
      : super(key: key);

  @override
  _RequestDetailsBoxState createState() => _RequestDetailsBoxState();
}

class _RequestDetailsBoxState extends State<RequestDetailsBox> {
  final LastRequestApi api = LastRequestApi();
  Future? _lastRequest;

  @override
  void initState() {
    super.initState();
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

    return Observer(builder: (_) {
      return FutureBuilder<dynamic>(
        future: api.getRequestById(int.parse(widget.requestId)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          var requestData = snapshot.data;

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
          print('index');
          print(getIndexFromStatus(
                              requestData['status_changes'].last['status']) +
                          1);
          detailsData['Data'] = createdAtMinus3Hours.toString();
          if (requestData['emergency'] == true) {
            detailsData['Emergência'] = 'Sim';
          } else {
            detailsData['Emergência'] = 'Não';
          }
          if (requestData['batch_number'] != null &&
              requestData['batch_number'] != '') {
            detailsData['Lote'] = requestData['batch_number'];
          }
          if (requestData['details'] != null && requestData['details'] != '') {
            detailsData['Detalhes'] = requestData['details'];
          }
          dynamic status = '';
          if (requestData['request_type'] == 'assistance') {
            status =
                AssistanceStatus.getStatusDescription(requestData['status_changes'].last['status']);
          } else {
            status = getDescription(requestData['status_changes'].last['status']);
          }
          dynamic color = '';
          if (requestData['request_type'] == 'assistance') {
            color = AssistanceStatus.getColorFromStatus(requestData['status_changes'].last['status']);
          } else {
            color =
                getColorFromStatus( requestData['status_changes'].last['status']);
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
                  currentStep: widget.type == 'assistance'
                      ? getIndexFromAssistanceStatus(
                          requestData['status_changes'].last['status'])
                      : getIndexFromStatus(
                              requestData['status_changes'].last['status']),
                  totalSteps: widget.type == 'assistance'
                      ? getAssistanceStatusLabels().length
                      : getStatusLabels().length,
                  labels: widget.type == 'assistance'
                      ? getAssistanceStatusLabels()
                      : getStatusLabels(),
                  status: requestData['status_changes'].last['status'],
                  activeColor: color,
                  inactiveColor: Colors.grey,
                  requestId: requestData['id'],
                  type: widget.type,
                  statusName: status,
                  editable: widget.userRole == "agent",
                  dropdownOptions: widget.type == 'assistance'
                      ? Constants.AssistanceStatus
                      : Constants.statuses,
                
                ),
                  
                SizedBox(height: 40),
                DetailsBox(details: detailsData),
                SizedBox(height: 40),
                ReadFeedbackWidget(
                    feedbackReceived: requestData['feedback'],
                    typeUser: widget.userRole,
                    typeRequest: widget.type,
                    requestId: requestData['request_id'],
                    phoneNumber: requestData['assign_to']?['phone_number']),
                    
              ],
            ),
          );
        },
      );
    });

    // Add navigation or interaction logic as needed
  }
}
