import 'package:asky/constants.dart';
import 'package:asky/widgets/history_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asky/api/history_api.dart';

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
}

class AgentRequests extends StatefulWidget {
  @override
  _AgentRequestsState createState() => _AgentRequestsState();
}

class _AgentRequestsState extends State<AgentRequests> {
  dynamic requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  void fetchRequests() async {
    var fetchedRequests = await HistoryApi.getHistory();
    List<dynamic> allRequests = [];
    fetchedRequests.forEach((key, value) {
      allRequests.addAll(value);
    });
    setState(() {
      requests = allRequests;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Todas as solicitações",
            style: GoogleFonts.notoSans(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 40),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    var request = requests[index];

                    var title = '';
                    var translatedAssistanceType = '';
                    if (request['assistance_type'] != null) {
                      translatedAssistanceType =
                          Constants.assistanceTypes[request['assistance_type']] ??
                              'Tipo desconhecido';
                    }
                    if (request['request_type'] == 'medicine') {
                      title = request['medicine']['name'];
                    } else if (request['request_type'] == 'material') {
                      title = request['material']['name'];
                    } else if (request['request_type'] == 'assistance') {
                      title = translatedAssistanceType;
                    }

                    var emergency = '';
                    if (request['emergency'] == true) {
                      emergency = 'EMERGÊNCIA';
                    } else {
                      emergency = 'NORMAL';
                    }

                    var location = request['dispenser']['code'] +
                        ' | Andar ' +
                        request['dispenser']['floor'].toString();
                    dynamic status = '';
                    if (request['request_type'] == 'assistance') {
                      status = AssistanceStatus.getStatusDescription(request['status']);
                    } else {
                      status = getDescription(request['status']);
                    }
                    dynamic color = '';
                    if (request['request_type'] == 'assistance') {
                      color = Constants.askyBlue;
                    } else {
                      color = getColorFromStatus(request['status']);
                    }
                    return HistoryCard(
                        date: request['created_at'],
                        title: title,
                        subtitle: location,
                        tag: emergency,
                        status: status,
                        statusColor: color,
                        id: request['id'].toString(),
                        requestType: request['request_type']);
                  },
                ),
        ],
      ),
    );
  }
}
