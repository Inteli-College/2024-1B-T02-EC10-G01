import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';
import 'request_api.dart';

class RequestMedicineApi implements RequestApi {
  final auth = AuthenticationApi();

  @override
  Future<List<dynamic>> getHistory() async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.post(
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
      throw Exception('Failed to fetch medicines');
    }
  }

  @override
  Future<dynamic> sendRequest(int pyxisId, int medicineId, {bool emergency = false}) async {
  
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.post(
      Uri.parse(Constants.baseUrl + '/requests/medicine/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: json.encode({
        'dispenser_id': pyxisId,
        'medicine_id': medicineId,
        'emergency': emergency,
      }),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to send request');
    }
  }

  @override
  Future<dynamic> getRequestById(int requestId) async {
    print('requestId: $requestId');
    var token = await auth.getToken();
    final String bearer = 'Bearer $token';
    final response = await http.get(
      Uri.parse(Constants.baseUrl + '/requests/medicine/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearer,
      },
    );

    if (response.statusCode == 200) {
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
      Uri.parse(Constants.baseUrl + '/requests/medicine/last'),
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
