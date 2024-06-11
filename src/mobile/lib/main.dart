import 'package:asky/api/authentication_api.dart';
import 'package:asky/api/firebase_api.dart';
import 'package:asky/views/choose_request.dart';
import 'package:asky/views/history_page.dart';
import 'package:asky/views/assistance_screen.dart';
import 'package:asky/views/login_screen.dart';
import 'package:asky/views/pharmacy_flow/in_progress.dart';
import 'package:asky/views/pharmacy_flow/pharmacy_home_page.dart';
import 'package:asky/views/pharmacy_flow/to_accept.dart';
import 'package:asky/views/request_medicine_screen.dart';
import 'package:asky/views/request_material_screen.dart';
import 'package:asky/views/home_nurse.dart';
import 'package:asky/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:asky/views/qr_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:asky/stores/pyxis_store.dart'; // Import the store
import 'package:asky/constants.dart';
import 'package:asky/views/request_details_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Map<int, Color> askyBlueSwatch = {
  50: Constants.askyBlue.withOpacity(.1),
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

final MaterialColor customAskyBlue =
    MaterialColor(Constants.askyBlue.value, askyBlueSwatch);

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
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              title: 'Asky',
              theme: ThemeData(
                primarySwatch: customAskyBlue,
                useMaterial3: true,
                scaffoldBackgroundColor: Constants.offWhite,
                fontFamily: GoogleFonts.notoSans().fontFamily,
              ),
              home: LoginPage(),
              routes: {
                "/nurse": (context) => HomeNurse(),
                "/choose_request":(context) => ChooseRequestScreen(),
                "/assistance": (context) => AssistanceScreen(),
                "/history": (context) => HistoryPage(),
                "/login": (context) => LoginPage(),
                "/medicine": (context) => RequestMedicine(),
                "/material": (context) => RequestMaterial(),
                "/qrcode": (context) => BarcodeScannerSimple(),
                '/nurse_request': (context) {
                  final args =
                      ModalRoute.of(context)!.settings.arguments as Map;
                  return RequestDetailsScreen(
                    requestId: args['requestId'],
                    type: args['type'] ?? 'medicine',
                  );
                },
                "/pharmacy_home": (context) => PharmacyHomePage(),
                "/accept_solicitation": (context) => AcceptSolicitationPage(),
                "/view_solicitation": (context) => ViewSolicitationPage(),
              },
            ),
          );
        }
        return Container(child: const CircularProgressIndicator());
      },
    );
  }
}
