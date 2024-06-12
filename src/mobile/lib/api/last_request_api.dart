import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';
import 'request_api.dart';

class LastRequestApi {
  final auth = AuthenticationApi();

  @override
  Future<Map> getLastRequest() async {
    var token = await auth.getToken();
    print('inside getLastRequest');
    final String bearerToken = 'Bearer $token';
    final response = await http.get(
      Uri.parse(Constants.baseUrl + '/requests/last'),
      headers: {
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to fetch medicines');
    }
  }
}