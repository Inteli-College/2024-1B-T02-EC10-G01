import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';

class RequestMedicineApi {
  final auth = AuthenticationApi();

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

Future<void> sendRequest(int pyxisId, int medicine_id, bool emergency) async {
   var token = await auth.getToken();

  final String bearerToken = 'Bearer $token';
  try {
    final url = Uri.parse(Constants.baseUrl + '/requests/medicine/'); // Change to your API's URL
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: json.encode({
        'dispenser_id': pyxisId,
        'medicine_id': medicine_id,
        'emergency': emergency,
      }),
    );
    if (response.statusCode == 200) {
      print("Data sent successfully!");
    } else {
      print("Failed to send data. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("An error occurred: $e");
  }
}

Future<dynamic> getRequestById(int requestId) async {
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
    print('Failed to fetch request. Status code: ${response.statusCode}');
  }

}



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
    print(data);

    return data ?? {};
  } else {
    print('Failed to fetch request. Status code: ${response.statusCode}');
  }

  }
  }