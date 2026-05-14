import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../liinkapi.dart';

class SentNotificationsRemote {
  Future<Map<String, dynamic>> getReport(Map<String, dynamic> data) async {
    final uri = Uri.parse(Applink.sentNotificationsReport);

    final response = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: data.map((k, v) => MapEntry(k, v.toString())),
    );

    print("SENT REPORT HTTP STATUS => ${response.statusCode}");
    print("SENT REPORT HTTP BODY => ${response.body}");

    if (response.body.isEmpty) {
      throw Exception("Empty response from server");
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception("Invalid JSON structure");
    }

    return decoded;
  }
}
