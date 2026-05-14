import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackRemote {

  static Future<Map<String, dynamic>> sendFeedback({
    required String name,
    required String type,
    required String description,
    String? programId,
    String? levelId,
    String? subjectGroupId,
  }) async {

    final url = Uri.parse(
        "https://online-store.infinityfree.me/university_backend/feedback/send.php"
    );

    final response = await http.post(url, body: {
      "name": name,
      "type": type,
      "description": description,
      "program_id": programId ?? "",
      "level_id": levelId ?? "",
      "subject_group_id": subjectGroupId ?? "",
    });

    return json.decode(response.body);
  }
}
