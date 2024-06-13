import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';

class FeedbackRequest {
  final auth = AuthenticationApi();

  Future<dynamic> createMedicineFeedback(int requestId, String feedback) async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.post(
      Uri.parse(Constants.baseUrl + '/requests/medicine/feedback'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: json.encode({
        'request_id': requestId,
        'feedback': feedback,
      }),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to send feedback');
    }
  }

  Future<dynamic> createMaterialFeedback(int requestId, String feedback) async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.post(
      Uri.parse(Constants.baseUrl + '/requests/material/feedback'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: json.encode({
        'request_id': requestId,
        'feedback': feedback,
      }),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to send feedback');
    }
  }

  Future<dynamic> createAssistanceFeedback(int requestId, String feedback) async {
    var token = await auth.getToken();
    final String bearerToken = 'Bearer $token';
    final response = await http.post(
      Uri.parse(Constants.baseUrl + '/requests/assistance/feedback'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: json.encode({
        'request_id': requestId,
        'feedback': feedback,
      }),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to send feedback');
    }
  }
}
