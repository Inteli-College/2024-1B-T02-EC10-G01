import 'package:asky/api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asky/constants.dart';

class MedicineFeedbackRequest {
  final auth = AuthenticationApi();

  Future<dynamic> createFeedback(int requestId, String feedback) async {
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
}

class MaterialFeedbackRequest {
  final auth = AuthenticationApi();

  Future<dynamic> createFeedback(int requestId, String feedback) async {
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
}

class AssistanceFeedbackRequest {
  final auth = AuthenticationApi();

  Future<dynamic> createFeedback(int requestId, String feedback) async {
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
