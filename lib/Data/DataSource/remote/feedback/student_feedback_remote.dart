import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentFeedbackRemote {
  static Future<Map<String, dynamic>> sendFeedback({
    required String senderId,
    required String name,
    required String type,
    required String description,
    String? programId,
    String? levelId,
  }) async {
    final uri = Uri.parse(
      "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/feedback/send.php",
    );

    final body = <String, String>{
      "sender_type": "student", // ✅ صح
      "sender_id": senderId,
      "name": name,
      "type": type,
      "description": description,
    };

    if (programId != null && programId.isNotEmpty) {
      body["program_id"] = programId;
    }
    if (levelId != null && levelId.isNotEmpty) {
      body["level_id"] = levelId;
    }

    final response = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: body,
    );

    print("STUDENT FEEDBACK SENT => sender_id=$senderId");
    print("FEEDBACK BODY => $body");
    print("FEEDBACK RAW RESPONSE => ${response.body}");

    return json.decode(response.body);
  }
}
