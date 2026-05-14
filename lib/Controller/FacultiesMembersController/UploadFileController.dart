import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UploadFileController extends GetxController {
  RxBool isLoading = false.obs;

  /// ================= Subjects =================
  RxList<Map<String, dynamic>> subjects = <Map<String, dynamic>>[].obs;
  RxBool isLoadingSubjects = false.obs;
  RxInt selectedSubjectId = 0.obs;

  /// ================= Teaching Types =================
  final List<String> teachingTypes = ["نظري", "عملي"];
  RxString selectedTeachingType = "".obs;

  /// ================= File =================
  Rx<File?> selectedFile = Rx<File?>(null);
  RxString selectedFileName = "".obs;

  /// ================= Text fields =================
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  /// ================= File type =================
  RxString selectedFileType = "محاضرة".obs;

  void changeFileType(String type) {
    selectedFileType.value = type;
  }

  /// ================= Get Subjects (FOR DOCTOR ONLY) =================
  Future<void> getSubjects(int userId) async {
    isLoadingSubjects.value = true;

    final url = Uri.parse(
      "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/subject/get_faculty.php?user_id=$userId",
    );

    try {
      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['status'] == true) {
        subjects.value = List<Map<String, dynamic>>.from(decoded['data']);
      } else {
        subjects.clear();
      }
    } catch (_) {
      subjects.clear();
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  /// ================= Pick File =================
  Future<void> pickFile() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Documents',
      extensions: ['pdf', 'doc', 'docx'],
    );

    final XFile? file =
    await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      selectedFile.value = File(file.path);
      selectedFileName.value = file.name;
    }
  }

  /// ================= Upload =================
  Future<void> uploadFile() async {
    if (selectedSubjectId.value == 0 ||
        selectedTeachingType.value.isEmpty ||
        selectedFile.value == null ||
        titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      Get.snackbar("خطأ", "يرجى تعبئة جميع الحقول");
      return;
    }

    isLoading.value = true; // ✅ تشغيل التحميل

    final uri = Uri.parse(
      "https://dodgerblue-octopus-842943.hostingersite.com/university_backend/lectures/upload.php",
    );

    try {
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          selectedFile.value!.path,
        ),
      );

      request.fields.addAll({
        'subject_id': selectedSubjectId.value.toString(),
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'file_type': selectedFileType.value,
        'teaching_type': selectedTeachingType.value,
        'uploaded_by': '6', 
      });

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final decoded = json.decode(body);

      if (response.statusCode == 200 && decoded['status'] == true) {
        Get.snackbar("نجاح", "تم رفع الملف بنجاح");

        selectedFile.value = null;
        selectedFileName.value = "";
        selectedSubjectId.value = 0;
        selectedTeachingType.value = "";
        titleController.clear();
        descriptionController.clear();
        selectedFileType.value = "محاضرة";
      } else {
        Get.snackbar("خطأ", decoded['message'] ?? "فشل الرفع");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر");
    } finally {
      isLoading.value = false; // ✅ إيقاف التحميل مهما صار
    }
  }


  @override
  void onInit() {
    super.onInit();
    _initDoctorSubjects();
  }

  Future<void> _initDoctorSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt("user_id");

    if (userId == null) {
      subjects.clear();
      return;
    }

    getSubjects(userId); // ✅ هنا كل دكتور بياخذ مواده
  }



  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
