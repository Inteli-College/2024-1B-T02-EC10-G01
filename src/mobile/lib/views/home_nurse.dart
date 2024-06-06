import 'dart:ui';

import 'package:asky/api/authentication_api.dart';
import 'package:asky/api/request_last_solicitation.dart';
import 'package:asky/views/assistance_screen.dart';
import 'package:asky/views/history_page.dart';
import 'package:asky/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeNurse extends StatefulWidget {
  HomeNurse({Key? key}) : super(key: key);

  @override
  State<HomeNurse> createState() => _HomeNurseState();
}

class _HomeNurseState extends State<HomeNurse> {
  int _selectedIndex = 0;

  final lastSolicitation = LastSolicitationApi();

  final auth = AuthenticationApi();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    Text('Home', style: optionStyle),
    HistoryPage(),
    Text('USER', style: optionStyle),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int? notificationIndex =
        ModalRoute.of(context)?.settings.arguments as int?;
    if (notificationIndex != null) {
      setState(() {
        _selectedIndex = notificationIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(
        imagePath: "assets/logo.png",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
              },
              child: Icon(
                Icons.add,
                size: 100,
                color: Color(0xFF1A365D),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(50),
                backgroundColor: Colors.white,
                // Cor de fundo
              ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Última solicitação:',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF1A365D),
                  ),
                ),
              ),
            ),
            FutureBuilder(
                future: lastSolicitation.getLastSolicitation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      print(data);
                      return Container(
                        color: Color(0xFF1A365D),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Medicamento: ${data}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Status: ${data}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                            ]),
                      );
                    } else {
                      return Text('Nenhuma solicitação encontrada');
                    }
                  } else {
                    return Text('Nenhuma solicitação encontrada');
                  }
                }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(icon: Icons.home_filled, text: 'Home'),
                GButton(icon: Icons.list, text: 'Histórico'),
                GButton(icon: Icons.person, text: 'Usuário'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
