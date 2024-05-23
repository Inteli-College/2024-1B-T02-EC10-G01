import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryApi {
  final auth = AuthenticationApi();

  Future<List<dynamic>> getHistory() async {
    var token = await auth.getToken();

    final String bearerToken = 'Bearer $token';

    final response = await http.get(
      Uri.parse('http://192.168.101.235:8000/requests/medicine/'),
      headers: {
        'Content-Type': "application/json",
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception('Failed to fetch history');
    }
  }
}
