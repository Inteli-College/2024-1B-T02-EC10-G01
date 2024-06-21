import 'package:asky/api/request_api.dart';
import 'package:asky/api/request_material_api.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/api/requests_assistance_api.dart';
import 'package:asky/constants.dart';
import 'package:asky/views/home_nurse.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:asky/api/request_material_api.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/api/requests_assistance_api.dart';
import 'package:asky/widgets/pharmacy_flow_widgets/pharmacy_bottom_bar.dart';

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
  int _selectedIndex = 3;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  late final List<Widget> _widgetOptions;

  Future<String?> userGetRole() async {
    const _secureStorage = FlutterSecureStorage();
    var userRole = await _secureStorage.read(key: "role", aOptions: _getAndroidOptions());
    return userRole;
  }
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  void initState() {
    super.initState();
    
    _widgetOptions = <Widget>[
      HomeNurseBody(),
      HistoryPage(),
      ProfileScreen(),
      RequestDetailsBox(
        requestId: widget.requestId,
        type: widget.type,
      ),
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

    return FutureBuilder<String?>(
      future: userGetRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: TopBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userRole = snapshot.data;
        var backRoute = userRole == 'agent' ? '/pharmacy_home' : '/nurse';

        return Scaffold(
          appBar: TopBar(backRoute: backRoute,),
          body: SingleChildScrollView(
            child: Center(child:  RequestDetailsBox(
        requestId: widget.requestId,
        type: widget.type,
        userRole: userRole!,
      ),)
          ),
        
        );
      },
    );
  }
}
