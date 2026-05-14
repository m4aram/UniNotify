import 'package:get/get.dart';
import '../../Data/DataSource/remote/feedback/admin_feedback_remote.dart';

class AdminFeedbackControllerImp extends GetxController {
  int expandedIndex = -1;
  List<dynamic> feedbackList = [];

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    loadFeedback();
  }

  /// ================= Load Feedback =================
  Future<void> loadFeedback() async {
    isLoading = true;
    update();

    try {
      feedbackList = await AdminFeedbackRemote.getFeedback();
    } catch (e) {
      feedbackList = [];
      Get.snackbar("خطأ", "فشل تحميل الملاحظات");
    }

    isLoading = false;
    update();
  }

  /// ================= UI Helpers =================
  void toggleExpanded(int index) {
    expandedIndex = expandedIndex == index ? -1 : index;
    update();
  }

  bool isExpanded(int index) => expandedIndex == index;

  String shorten(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return "${text.substring(0, maxLength)}...";
  }

  /// ================= Delete Feedback (REAL DELETE) =================
  Future<void> deleteFeedback(int index) async {
    if (index < 0 || index >= feedbackList.length) return;

    final String feedbackId = feedbackList[index]["feedback_id"].toString();

    final bool success = await AdminFeedbackRemote.deleteFeedback(feedbackId);

    if (success) {
      feedbackList.removeAt(index);
      expandedIndex = -1;
      update();

      Get.snackbar("تم", "تم حذف الملاحظة بنجاح");
    } else {
      Get.snackbar("خطأ", "فشل حذف الملاحظة من السيرفر");
    }
  }

  void replyToFeedback(int index) {}
  void likeFeedback(int index) {}
}
