import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StudentFilesController extends GetxController {
  RxList<Map<String, dynamic>> files = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  /// ================= جلب ملفات الطالب =================
  Future<void> getFiles() async {
    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();
    final int? studentId = prefs.getInt("student_id");

    if (studentId == null) {
      files.clear();
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
          "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/lectures/get_student.php",
        ),
        body: {
          "student_id": studentId.toString(),
        },
      );

      final decoded = json.decode(response.body);

      if (decoded is Map && decoded["status"] == true) {
        files.value = List<Map<String, dynamic>>.from(decoded["data"]);
      } else {
        files.clear();
      }
    } catch (e) {
      files.clear();
      Get.snackbar("خطأ", "فشل جلب الملفات");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= تحميل / فتح الملف =================
  Future<void> onDownload(String filePath) async {
    if (filePath.isEmpty) {
      Get.snackbar("خطأ", "مسار الملف غير صحيح");
      return;
    }

    final String fullUrl =
        "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/$filePath";

    final Uri uri = Uri.parse(Uri.encodeFull(fullUrl));

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar("خطأ", "لا يمكن فتح الملف");
    }
  }


  @override
  void onInit() {
    super.onInit();
    getFiles(); // ✅ تحميل الملفات عند فتح الشاشة
  }
}
