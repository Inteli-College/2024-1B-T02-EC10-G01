import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';

class RequestMaterialApi {
  final auth = AuthenticationApi();

  Future<List<dynamic>> getHistory() async {
    var token = await auth.getToken();

    final String bearerToken = 'Bearer $token';

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

Future<dynamic> sendRequest(int pyxisId, int material_id) async {
   var token = await auth.getToken();
  print('request data: ' + pyxisId.toString() + ' ' + material_id.toString());
  final String bearerToken = 'Bearer $token';
  print(json.encode({
        'dispenser_id': pyxisId,
        'material_id': material_id,
      }),);
  try {
    final url = Uri.parse(Constants.baseUrl + '/requests/material/'); // Change to your API's URL
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: json.encode({
        'dispenser_id': pyxisId,
        'material_id': material_id,
      }),
    );
    if (response.statusCode == 200) {

      print("Data sent successfully!");
      var data = jsonDecode(response.body);
      return data;
    } else {
      print("Failed to send data. Status code: ${response.statusCode}");
      return Null;
    }
  } catch (e) {
    print("An error occurred: $e");
    return Null;
  }
}

Future<dynamic> getRequestById(int requestId) async {
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
    var data = jsonDecode(response.body);
    print(data);

    return data ?? {};
  } else {
    print('Failed to fetch request. Status code: ${response.statusCode}');
  }

}



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
    print(data);

    return data ?? {};
  } else {
    print('Failed to fetch request. Status code: ${response.statusCode}');
  }

  }
  }