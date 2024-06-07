import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:asky/constants.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {
      checkToken();
    });
  }

  void checkToken() async {
    print("Checking token");
    var session = await secureStorage.read(
        key: "session", aOptions: _getAndroidOptions());
    print(session);
    if (session != null) {
      var sessionData = jsonDecode(session);
      var expiresAt = DateTime.parse(sessionData['expires_at']);
      print(expiresAt);
      print(DateTime.now().toUtc());
      if (sessionData['expires_at'] != null &&
          expiresAt.isAfter(DateTime.now().toUtc())) {
        // Token is valid
        if (sessionData['role'] == 'nurse') {
          Navigator.pushReplacementNamed(context, '/nurse');
        } else {
          // Token is expired or not set
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
          // Token is expired or not set
          Navigator.pushReplacementNamed(context, '/login');
        }
    } else {
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
