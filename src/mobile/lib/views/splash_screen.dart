import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:asky/api/authentication_api.dart';
import 'package:asky/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Secure storage options for Android
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final AuthenticationApi auth = AuthenticationApi();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Start a timer to delay the navigation
  void startTimer() {
    Timer(Duration(seconds: 1), () {
      _checkAndNavigate();
    });
  }

  // Check the token and navigate accordingly
  Future<void> _checkAndNavigate() async {
    try {
      bool isValid = await auth.checkToken();
      print('Token is valid: $isValid');
      if (!mounted) return;  // Ensure the widget is still mounted before using context
      if (isValid) {
        if(await auth.getUser() == 'agent') {
        Navigator.pushReplacementNamed(context, '/nurse');

        } else {
          Navigator.pushReplacementNamed(context, '/pharmacy_home');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      // Handle any errors that occur during token check
      print('Error checking token: $e');
      // Optionally, navigate to an error page or show a message
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.gradientTop, Constants.gradientBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset("assets/logo.png", width: 300),
        ),
      ),
    );
  }
}
