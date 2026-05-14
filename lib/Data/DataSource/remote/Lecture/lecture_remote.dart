import 'dart:convert';
import 'package:http/http.dart' as http;

class LectureRemote {

  /// ================== DOCTOR ==================
  static Future<List<Map<String, dynamic>>> getLecturesBySubject(
      int subjectId) async {
    final Uri url = Uri.parse(
      "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/lectures/get.php?subject_id=$subjectId",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) return [];

      final decoded = json.decode(response.body);
      if (decoded is Map && decoded["data"] is List) {
        return List<Map<String, dynamic>>.from(decoded["data"]);
      }
      return [];
    } catch (e) {
      print("DOCTOR LECTURES ERROR: $e");
      return [];
    }
  }

  /// ================== STUDENT ==================
  static Future<List<Map<String, dynamic>>> getStudentLectures(
      int studentId) async {
    final Uri url = Uri.parse(
      "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/lectures/get_student.php",
    );

    try {
      final response = await http.post(
        url,
        body: {"student_id": studentId.toString()},
      );

      if (response.statusCode != 200) return [];

      final decoded = json.decode(response.body);
      if (decoded is Map &&
          decoded["status"] == true &&
          decoded["data"] is List) {
        return List<Map<String, dynamic>>.from(decoded["data"]);
      }
      return [];
    } catch (e) {
      print("STUDENT LECTURES ERROR: $e");
      return [];
    }
  }
}
