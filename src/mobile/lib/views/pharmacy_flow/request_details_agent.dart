import 'package:asky/api/request_api.dart';
import 'package:asky/api/request_material_api.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/api/requests_assistance_api.dart';
import 'package:asky/constants.dart';
import 'package:asky/views/profile_screen.dart';
import 'package:asky/views/request_details_box.dart';
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

class RequestDetailsAgent extends StatefulWidget {
  final String requestId;
  final String type;

  RequestDetailsAgent(
      {Key? key, required this.requestId, this.type = 'medicine'})
      : super(key: key);

  @override
  _RequestDetailsAgentState createState() => _RequestDetailsAgentState();
}

class _RequestDetailsAgentState extends State<RequestDetailsAgent> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      RequestDetailsBox(
        requestId: widget.requestId,
        type: widget.type,
      ),
      HistoryPage(),
      ProfileScreen(),
    ];
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: (int index) {
          setState(() {
            print('Index changed to $index');
            _selectedIndex = index;
          });
          // Add navigation or interaction logic as needed
        },
      ),
    );
  }
}
