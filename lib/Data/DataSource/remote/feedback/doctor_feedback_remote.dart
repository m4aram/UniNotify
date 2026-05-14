import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorFeedbackRemote {
  static Future<Map<String, dynamic>> sendFeedback({
    required String senderId, // الرقم الأكاديمي
    required String name,
    required String type,
    required String description,
    String? programId,
    String? levelId,

  }) async {
    final uri = Uri.parse(
      "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/feedback/send.php",
    );

    final response = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        // ✅ هذا السطر كان ناقص
        "sender_type": "doctor",

        // ✅ الرقم الأكاديمي
        "sender_id": senderId,

        // باقي البيانات
        "name": name,
        "type": type,
        "description": description,
        "program_id": programId ?? "",
        "level_id": levelId ?? "",

      },
    );
    return json.decode(response.body);
  }
}
