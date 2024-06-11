import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';
import 'request_api.dart';

class RequestMaterialApi implements RequestApi {
  final auth = AuthenticationApi();


  @override
  Future<List<dynamic>> getHistory() async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    print('INSIDE MATERIAL API');
    final response = await http.post(
      Uri.parse(Constants.baseUrl + '/requests/material/'),
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

  @override
  Future<Map> getPyxisByPyxisId(int pyxisId) async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.get(
      Uri.parse(Constants.baseUrl + '/pyxis/dispensers/$pyxisId'),
      headers: {
        'Content-Type': "application/json",
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch materials');
    }
  }

  @override
  Future<dynamic> sendRequest(int pyxisId, int materialId) async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.post(
      Uri.parse(Constants.baseUrl + '/requests/material/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: json.encode({
        'dispenser_id': pyxisId,
        'material_id': materialId,
      }),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to send request');
    }
  }

  @override
  Future<dynamic> getRequestById(int requestId) async {
    print('INSIDE GET REQUEST BY ID');
    var token = await auth.getToken();
    final String bearer = 'Bearer $token';
    final response = await http.get(
      Uri.parse(Constants.baseUrl + '/requests/material/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearer,
      },
    );

    if (response.statusCode == 200) {
      print('INSIDE GET REQUEST BY ID 200');
      var data = jsonDecode(response.body);
      print(data);
      return data ?? {};
    } else {
      throw Exception('Failed to fetch request');
    }
  }

  @override
  Future<dynamic> getLastRequest() async {
    var token = await auth.getToken();
    final String bearer = 'Bearer $token';
    final response = await http.get(
      Uri.parse(Constants.baseUrl + '/requests/material/last'),
      headers: {
        'Authorization': bearer,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data ?? {};
    } else {
      throw Exception('Failed to fetch last request');
    }
  }
}
