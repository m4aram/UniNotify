import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../liinkapi.dart';

class UnfinishedLecturesRemote {
  Future<Map<String, dynamic>> getReport(Map<String, dynamic> data) async {
    final uri = Uri.parse(Applink.unfinishedLecturesReport);

    final response = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: data.map((k, v) => MapEntry(k, v.toString())),
    );

    // 🔍 تشخيص
    print("REPORT HTTP STATUS => ${response.statusCode}");
    print("REPORT HTTP BODY => ${response.body}");

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
