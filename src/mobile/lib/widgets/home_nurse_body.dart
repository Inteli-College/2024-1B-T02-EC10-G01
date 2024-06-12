import 'package:asky/constants.dart';
import 'package:flutter/material.dart';
import 'package:asky/widgets/last_solicitation_card.dart';
import 'package:asky/api/last_request_api.dart';

class AssistanceStatus {
  static const pending = "pending";
  static const accepted = "accepted";
  static const resolved = "resolved";
}

List<String> getAssistanceStatusLabels() {
  return [
    "Pending", // corresponds to AssistanceStatus.pending
    "Accepted", // corresponds to AssistanceStatus.accepted
    "Resolved" // corresponds to AssistanceStatus.resolved
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

class HomeNurseBody extends StatefulWidget {
  const HomeNurseBody({Key? key}) : super(key: key);

  @override
  _HomeNurseBodyState createState() => _HomeNurseBodyState();
}

class _HomeNurseBodyState extends State<HomeNurseBody> {
  final LastRequestApi api = LastRequestApi();
  Future? _lastRequest;

  @override
  void initState() {
    super.initState();
    _lastRequest = api.getLastRequest();
    print('HomeNurseBody initialized');
  }

  Future<void> _refreshData() async {
    setState(() {
      _lastRequest = api.getLastRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/qrcode');
                  },
                  child: Icon(Icons.add, size: 100, color: Color(0xFF1A365D)),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(
                          side: BorderSide(
                        color: Color.fromRGBO(224, 224, 224, 0.25),
                        width: 1,
                      )),
                      padding: EdgeInsets.all(50),
                      backgroundColor: Colors.white,
                      elevation: 4),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    "Nova Solicitação",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFF1A365D),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder(
                    future: _lastRequest,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;
                          print('Last request data: $data');
                          print(data['assistanceType']);
                          String translatedAssistanceType = '';
                          if (data['assistanceType'] != null) {
                            // Retrieve the translated label from Constants.assistanceTypes using the key from requestData
                            translatedAssistanceType = Constants
                                    .assistanceTypes[data['assistanceType']] ??
                                'Tipo desconhecido';

                            // Set the translated assistance type in detailsData
                          }
                          return LastRequestCard(
                              item: data['request_type'] == 'assistance'
                                  ? translatedAssistanceType
                                  : data['item']['name'],
                              currentStep: data['request_type'] == 'assistance'
                                  ? getIndexFromAssistanceStatus(
                                          data['status_changes']
                                              .last['status']) +
                                      1
                                  : getIndexFromStatus(data['status_changes']
                                          .last['status']) +
                                      2,
                              totalSteps: data['request_type'] == 'assistance'
                                  ? getAssistanceStatusLabels().length
                                  : getStatusLabels().length,
                              requestType: data['request_type'],
                              pyxis: data['dispenser']['code'],
                              id: data['id'].toString());
                        } else {
                          return Text('Nenhuma solicitação encontrada');
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
