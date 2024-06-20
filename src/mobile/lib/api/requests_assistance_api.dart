import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';

class RequestsAssistance {
  final auth = AuthenticationApi();

  Future<List<dynamic>> getHistory() async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.post(
      Uri.parse(Constants.baseUrl + '/requests/assistance/'),
      headers: {
        'Content-Type': "application/json",
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to fetch history');
    }
  }

  Future<dynamic> sendRequest(int pyxisId, String assistanceType,
      {String details = ''}) async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.post(
      Uri.parse(Constants.baseUrl + '/requests/assistance/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: json.encode({
        'dispenser_id': pyxisId,
        'assistance_type': assistanceType,
        'details': details,
      }),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to send request');
    }
  }

  Future<dynamic> getRequestById(int requestId) async {
    var token = await auth.getToken();
    final String bearer = 'Bearer $token';
    final response = await http.get(
      Uri.parse(Constants.baseUrl + '/requests/assistance/$requestId'),
      headers: {
        'Authorization': bearer,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data ?? {};
    } else {
      throw Exception('Failed to fetch request');
    }
  }

  Future<bool> updateRequestStatus(int requestId) async {
    var token = await auth.getToken();
    final String bearer = 'Bearer $token';
    final response = await http.post(
        Uri.parse(Constants.baseUrl + '/requests/assistance/accept_request'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearer,
        },
        body: json.encode({'request_id': requestId}));

    if (response.statusCode == 200) {
      // var data = jsonDecode(utf8.decode(response.bodyBytes));
      // return data ?? {};
      return true;
    } else {
      throw Exception('Failed to fetch last request');
    }
  }
}
  