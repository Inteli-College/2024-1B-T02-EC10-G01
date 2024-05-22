import 'package:asky/api/firebase_api.dart';
import 'package:asky/views/history_page.dart';
import 'package:asky/views/home_screen.dart';
import 'package:asky/views/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asky',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // home: const MyHomePage(title: 'Asky'),
      initialRoute: "/login",
      routes: {
        "/": (context) => HomeScreen(),
        "/login": (context) => LoginPage(),
        "/history": (context) => HistoryPage()
      },
    );
  }
}
