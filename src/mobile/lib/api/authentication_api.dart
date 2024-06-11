import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:asky/constants.dart';
import 'package:flutter/material.dart';

class AuthenticationApi {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  Future<void> signIn(String _email, String _password) async {
    const _secureStorage = FlutterSecureStorage();

    var _mobile_token = await _secureStorage.read(
        key: "mobile_token", aOptions: _getAndroidOptions());

    final Map<String, dynamic> body = {
      "email": _email,
      "password": _password,
      "mobile_token": _mobile_token
    };
    final response = await http.post(
        Uri.parse(Constants.baseUrl + '/auth/login'),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      await _secureStorage.write(
          key: "session", value: response.body, aOptions: _getAndroidOptions());
    } else {
      throw Exception('Failed to auth');
    }
  }

  void signOut() async {
    try {
      const _secureStorage = FlutterSecureStorage();
      await _secureStorage.delete(
          key: "session", aOptions: _getAndroidOptions());
    } catch (e) {
    }
  }

  Future<String?> getToken() async {
    const _secureStorage = FlutterSecureStorage();

    var readData = await _secureStorage.read(
        key: "session", aOptions: _getAndroidOptions());

    if (readData != null) {
      var session = jsonDecode(readData);
      return session["access_token"];
    }
    return null;
  }

 Future<bool> checkToken() async {
  const secureStorage = FlutterSecureStorage();

  try {
    var session = await secureStorage.read(key: "session", aOptions: _getAndroidOptions());

    if (session != null) {
      var sessionData = jsonDecode(session);
      var expiresAt = DateTime.parse(sessionData['expires_at']).subtract(Duration(hours: 3));
      var now = DateTime.now();
      
   

      bool isAfter = expiresAt.isAfter(now);

      return isAfter;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

}