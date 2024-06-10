import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:asky/constants.dart';

class AuthenticationApi {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

Future<String?> signIn(String email, String password) async {
  const _secureStorage = FlutterSecureStorage();
  var _mobile_token = await _secureStorage.read(
      key: "mobile_token", aOptions: _getAndroidOptions());

  final Map<String, dynamic> body = {
    "email": email,
    "password": password,
    "mobile_token": _mobile_token
  };

  final response = await http.post(
      Uri.parse(Constants.baseUrl + '/auth/login'),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode(body));

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body);
    await _secureStorage.write(
        key: "session", value: response.body, aOptions: _getAndroidOptions());
    return decodedResponse['role'];  // Return the role of the user
  } else {
    print(response.body);
    throw Exception('Failed to authenticate');
  }
}

  void signOut() async {
    try {
      const _secureStorage = FlutterSecureStorage();
      await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
    } catch (e) {
      print("Impossible to sign out: $e");
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

  // Método para recuperar o 'role' armazenado
  Future<String?> getUserRole() async {
    const _secureStorage = FlutterSecureStorage();

    return await _secureStorage.read(
        key: "userRole", aOptions: _getAndroidOptions());
  }
}