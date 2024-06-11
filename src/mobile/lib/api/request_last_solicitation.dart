import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class LastSolicitationApi {
  final AuthenticationApi auth = AuthenticationApi();

  Future<List<dynamic>> getLastSolicitation(BuildContext context) async {
    if (!await auth.checkToken()) {
      Navigator.pushReplacementNamed(context, '/login');
      return []; // Return an empty list if the token is not valid
    }

    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';

    final response = await http.get(
      Uri.parse('https://1902-179-99-33-90.ngrok-free.app/requests/medicine/'),
      headers: {
        'Content-Type': "application/json",
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch last solicitation');
    }
  }
}
