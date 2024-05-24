import 'package:asky/api/authentication_api.dart';
import 'package:asky/api/firebase_api.dart';
import 'package:asky/views/history_page.dart';
import 'package:asky/views/home_screen.dart';
import 'package:asky/views/assistance_screen.dart';
import 'package:asky/views/login_screen.dart';
import 'package:asky/views/request_medicine_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final auth = AuthenticationApi();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: auth.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var session = snapshot.data;
            return MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Asky',
              theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
              initialRoute: session != null ? "/" : "/login",
              routes: {
                "/": (context) => HomeScreen(),
                "/assistance": (context) => AssistanceScreen(),
                "/history": (context) => HistoryPage(),
                "/login": (context) => LoginPage(),
                "/medicine": (context) => RequestMedicine()
              },
            );
          }
          return Container(child: const CircularProgressIndicator());
        });
  }
}
