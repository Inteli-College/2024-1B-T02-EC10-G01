import 'package:asky/api/agent_api.dart';
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
  dynamic pendingRequests;
  bool _isLoading = true;
  late AgentApi api;

  @override
  void initState() {
    super.initState();
    api = AgentApi();
    fetchPendingRequests();
  }

  void fetchPendingRequests() async {
    var requests = await api.getPendingRequests();
    setState(() {
      pendingRequests = requests;
      print(pendingRequests);
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
              : (pendingRequests == null || pendingRequests.isEmpty
                  ? Center(child: Text("Nenhuma solicitação foi feita."))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: pendingRequests.length,
                      itemBuilder: (context, index) {
                        print(pendingRequests.length);
                        var request = pendingRequests[index];
                        var title = getRequestTitle(request);
                        var emergency = request['emergency'] == true ? 'EMERGÊNCIA' : 'NORMAL';
                        var location = '${request['dispenser']['code']} | Andar ${request['dispenser']['floor']}';
                        var status = getStatusDescription(request);
                        var color = getStatusColor(request);

                        return HistoryCard(
                          date: request['created_at'],
                          title: title,
                          subtitle: location,
                          tag: emergency,
                          status: status,
                          statusColor: color,
                          id: request['id'].toString(),
                          requestType: request['request_type'],
                        );
                      },
                    )),
        ],
      ),
    );
  }

  String getRequestTitle(dynamic request) {
    switch (request['request_type']) {
      case 'medicine':
        return request['item']['name'];
      case 'material':
        return request['item']['name'];
      case 'assistance':
        return Constants.assistanceTypes[request['assistance_type']] ?? 'Tipo desconhecido';
      default:
        return 'Título desconhecido';
    }
  }

  String getStatusDescription(dynamic request) {
    if (request['request_type'] == 'assistance') {
      return AssistanceStatus.getStatusDescription(request['status_changes'][0]['status']);
    }
    return getDescription(request['status_changes'][0]['status']);
  }

  Color getStatusColor(dynamic request) {
    if (request['request_type'] == 'assistance') {
      return Constants.askyBlue;
    }
    return getColorFromStatus(request['status_changes'][0]['status']);
  }
}
