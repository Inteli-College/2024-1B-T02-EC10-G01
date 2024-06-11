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
    print('inside sign in');
    const _secureStorage = FlutterSecureStorage();

    var _mobile_token = await _secureStorage.read(
        key: "mobile_token", aOptions: _getAndroidOptions());

    final Map<String, dynamic> body = {
      "email": _email,
      "password": _password,
      "mobile_token": _mobile_token
    };
    print(Constants.baseUrl + '/auth/login');
    final response = await http.post(
        Uri.parse(Constants.baseUrl + '/auth/login'),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      await _secureStorage.write(
          key: "session", value: response.body, aOptions: _getAndroidOptions());
    } else {
      print(response.body);
      throw Exception('Failed to auth');
    }
  }

  void signOut() async {
    try {
      const _secureStorage = FlutterSecureStorage();
      await _secureStorage.delete(
          key: "session", aOptions: _getAndroidOptions());
    } catch (e) {
      print("impossible to do sign out");
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
    print("Checking token");
    var session = await secureStorage.read(key: "session", aOptions: _getAndroidOptions());
    print(session);
    if (session != null) {
      var sessionData = jsonDecode(session);
      var expiresAt = DateTime.parse(sessionData['expires_at']);
      print(expiresAt);
      print(DateTime.now().toUtc());
      print(expiresAt.isAfter(DateTime.now().toUtc()));
      if (expiresAt.isAfter(DateTime.now().toUtc())) {

        return true;
      } else {  
        return false;

      }
    } else {
      return false;
    }
  }
}