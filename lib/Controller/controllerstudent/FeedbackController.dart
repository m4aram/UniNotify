import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/DataSource/remote/feedback/student_feedback_remote.dart';
import '../../Framework/Service/services.dart';
import '../AppController.dart';

class FeedbackController extends GetxController {
  final MyServices myServices = Get.find();
  final AppController appController = Get.find<AppController>();

  // ===== Feedback type =====
  RxString selectedFeedbackType = "".obs;

  final List<Map<String, String>> feedbackTypes = [
    {"id": "Complaint", "valAr": "مشكله ماده"},
    {"id": "Suggestion", "valAr": "شكوئ"},
    {"id": "Inquiry", "valAr": "استفسار"},
  ];

  // ===== IDs من DB =====
  RxInt selectedProgramId = 0.obs;
  RxInt selectedLevelId = 0.obs;

  // ===== Text Controllers =====
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  RxBool isLoading = false.obs;

  // ===== Lists from AppController =====
  List get programs => appController.programs;
  List get levels => appController.levels;

  List get filteredLevels => levels;

  Future<void> submitFeedback() async {
    if (feedbackController.text.trim().isEmpty ||
        selectedFeedbackType.value.isEmpty) {
      Get.snackbar("خطأ", "يرجى تعبئة الحقول المطلوبة");
      return;
    }

    final studentId = myServices.sharedPreferences.getString("academic_id");

    if (studentId == null || studentId.isEmpty) {
      Get.snackbar("خطأ", "لم يتم العثور على الرقم الأكاديمي");
      return;
    }

    isLoading.value = true;

    try {
      final response = await StudentFeedbackRemote.sendFeedback(
        senderId: studentId,
        name: nameController.text.trim().isEmpty
            ? "بدون اسم"
            : nameController.text.trim(),
        type: selectedFeedbackType.value,
        description: feedbackController.text.trim(),
        programId: selectedProgramId.value == 0
            ? null
            : selectedProgramId.value.toString(),
        levelId: selectedLevelId.value == 0
            ? null
            : selectedLevelId.value.toString(),
      );

      isLoading.value = false;

      if (response['status'] == 'success') {
        Get.snackbar("تم", "تم إرسال الملاحظة بنجاح");

        nameController.clear();
        feedbackController.clear();
        selectedFeedbackType.value = "";
        selectedProgramId.value = 0;
        selectedLevelId.value = 0;
      } else {
        Get.snackbar("خطأ", response['message'] ?? "فشل الإرسال");
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("STUDENT FEEDBACK ERROR => $e");
      Get.snackbar("خطأ", "خطأ في الاتصال بالسيرفر");
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    feedbackController.dispose();
    super.onClose();
  }
}
