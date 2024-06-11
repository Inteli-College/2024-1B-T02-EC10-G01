import 'package:asky/api/authentication_api.dart';
import 'package:asky/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LastSolicitationApi {
  final auth = AuthenticationApi();

  Future<List<dynamic>> getLastSolicitation() async {
    var token = await auth.getToken();

    final String bearerToken = 'Bearer $token';

    final response = await http.get(
      Uri.parse(Constants.baseUrl + '/requests/medicine/'),
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
