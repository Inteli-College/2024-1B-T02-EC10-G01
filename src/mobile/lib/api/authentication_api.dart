import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:asky/constants.dart';

class AuthenticationApi {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<String> signIn(String _email, String _password) async {
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
      var data = jsonDecode(response.body);

      // Store the entire response body
      await _secureStorage.write(
          key: "session", value: response.body, aOptions: _getAndroidOptions());

      // Return the role for further processing
      return data[
          'role']; // Adjust this if the key 'role' is nested or different
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  void signOut() async {
    try {
      const _secureStorage = FlutterSecureStorage();
      await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
    } catch (e) {
      print("Sign out error: $e");
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
      var session = await secureStorage.read(
          key: "session", aOptions: _getAndroidOptions());

      if (session != null) {
        var sessionData = jsonDecode(session);
        var expiresAt = DateTime.parse(sessionData['expires_at'])
            .subtract(Duration(hours: 3));
        var now = DateTime.now();

        return expiresAt.isAfter(now);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
