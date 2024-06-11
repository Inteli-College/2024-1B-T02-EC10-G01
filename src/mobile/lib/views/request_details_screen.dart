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

  RequestDetailsScreen({Key? key, required this.requestId, this.type = 'medicine'}) : super(key: key);

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}
class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    HomeNurseBody(),
    HistoryPage(),
    Text('USER', style: optionStyle),
  ];

  @override
  void initState() {
    super.initState();
    print('RequestDetailsScreen initialized with requestId: ${widget.requestId} and type: ${widget.type}');
  }

  @override
  Widget build(BuildContext context) {
    final RequestApi api = widget.type == 'material' ? RequestMaterialApi() : RequestMedicineApi();
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

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Solicitação #${widget.requestId}",
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
                      'Item': requestData['item']['name'],
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
