import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminFeedbackRemote {
  /// ================= Get Feedback =================
  static Future<List<dynamic>> getFeedback() async {
    try {
      final url = Uri.parse(
        "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/feedback/get.php",
      );

      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
        },
      );

      print("ADMIN FEEDBACK RAW RESPONSE => ${response.body}");

      final data = json.decode(response.body);

      if (data is Map && data['status'] == 'success') {
        return data['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("ADMIN FEEDBACK ERROR => $e");
      return [];
    }
  }

  /// ================= Delete Feedback =================
  static Future<bool> deleteFeedback(String feedbackId) async {
    try {
      final url = Uri.parse(
        "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/feedback/delete.php",
      );

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "feedback_id": feedbackId,
        },
      );

      print("DELETE FEEDBACK RAW RESPONSE => ${response.body}");

      final data = json.decode(response.body);

      return data is Map && data['status'] == 'success';
    } catch (e) {
      print("DELETE FEEDBACK ERROR => $e");
      return false;
    }
  }
}
