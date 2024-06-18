import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';

class AgentApi {
   Future getPendingRequests() async {
    final auth = AuthenticationApi();
    var token = await auth.getToken();
    print('SKJDBSLJFBSDFBSDJKF');
    final String bearerToken = 'Bearer $token';

    final response = await http.get(
      Uri.parse(Constants.baseUrl + '/requests/pending'),
      headers: {
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['requests'];
    } else if (response.statusCode == 404){
      return;
    } else {
      throw Exception('Failed to fetch history');
    }
  }
}