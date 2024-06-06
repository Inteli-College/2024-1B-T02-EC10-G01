import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LastSolicitationApi {
  final auth = AuthenticationApi();

  Future<List<dynamic>> getLastSolicitation() async {
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
