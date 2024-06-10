import 'dart:ui';
import 'package:asky/widgets/bottom_bar.dart';
import 'package:asky/widgets/home_nurse_body.dart';
import 'package:asky/widgets/pharmacy_flow_widgets/pharmacy_bottom_bar.dart';
import 'package:asky/widgets/pharmacy_flow_widgets/pharmacy_home_page_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:asky/api/authentication_api.dart';
import 'package:asky/api/request_last_solicitation.dart';
import 'package:asky/views/assistance_screen.dart';
import 'package:asky/views/history_page.dart';
import 'package:asky/widgets/top_bar.dart';
import 'package:asky/widgets/bottom_bar.dart'; // Assuming this widget exists and is stored as a separate file

class PharmacyHomePage extends StatefulWidget {
  PharmacyHomePage({Key? key}) : super(key: key);

  @override
  State<PharmacyHomePage> createState() => _PharmacyHomePageState();
}

class _PharmacyHomePageState extends State<PharmacyHomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    PharmacyHomePageBody(),
    HistoryPage(),
    Text('USER', style: optionStyle),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int? notificationIndex = ModalRoute.of(context)?.settings.arguments as int?;
    if (notificationIndex != null) {
      setState(() {
        _selectedIndex = notificationIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(showBackButton: false),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Displaying the widget based on selected index
      ),
      bottomNavigationBar: PharmacyCustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: (int index) {
          print('Index: $index');
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

//agent@agent.com