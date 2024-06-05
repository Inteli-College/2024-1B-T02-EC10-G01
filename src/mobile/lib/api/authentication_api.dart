import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthenticationApi {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  Future<void> singIn(String _email, String _password) async {
    const _secureStorage = FlutterSecureStorage();

    final Map<String, dynamic> body = {"email": _email, "password": _password};
    final response = await http.post(
        Uri.parse('https://0077-177-69-182-113.ngrok-free.app/auth/login'),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      print(data);

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
}
