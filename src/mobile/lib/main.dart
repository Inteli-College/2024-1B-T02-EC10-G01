import 'package:asky/api/authentication_api.dart';
import 'package:asky/api/firebase_api.dart';
import 'package:asky/views/history_page.dart';
import 'package:asky/views/home_screen.dart';
import 'package:asky/views/assistance_screen.dart';
import 'package:asky/views/login_screen.dart';
import 'package:asky/views/request_medicine_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:asky/views/qr_code.dart';
import 'package:provider/provider.dart';
import 'package:asky/stores/pyxis_store.dart'; // Import the store

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var session = snapshot.data;
          return MultiProvider(
            providers: [
              Provider<PyxisStore>(create: (_) => PyxisStore()),
            ],
            child: MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Asky',
              theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
              initialRoute: session != null ? "/qrcode" : "/qrcode",
              routes: {
                "/": (context) => HomeScreen(),
                "/assistance": (context) => AssistanceScreen(),
                "/history": (context) => HistoryPage(),
                "/login": (context) => LoginPage(),
                "/medicine": (context) => RequestMedicine(),
                "/qrcode": (context) => BarcodeScannerSimple(),
              },
            ),
          );
        }
        return Container(child: const CircularProgressIndicator());
      },
    );
  }
}
