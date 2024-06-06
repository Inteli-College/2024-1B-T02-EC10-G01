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
import 'package:asky/constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Map<int, Color> askyBlueSwatch = {
  50:  Constants.askyBlue.withOpacity(.1),
  100: Constants.askyBlue.withOpacity(.2),
  200: Constants.askyBlue.withOpacity(.3),
  300: Constants.askyBlue.withOpacity(.4),
  400: Constants.askyBlue.withOpacity(.5),
  500: Constants.askyBlue.withOpacity(.6),
  600: Constants.askyBlue.withOpacity(.7),
  700: Constants.askyBlue.withOpacity(.8),
  800: Constants.askyBlue.withOpacity(.9),
  900: Constants.askyBlue.withOpacity(1),
};

final MaterialColor customAskyBlue = MaterialColor(Constants.askyBlue.value, askyBlueSwatch);

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
              theme: ThemeData(primarySwatch: customAskyBlue, useMaterial3: true),
              initialRoute: "/login",
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
