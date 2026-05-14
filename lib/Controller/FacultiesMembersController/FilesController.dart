import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Data/DataSource/remote/Lecture/lecture_remote.dart';
class FilesController extends GetxController {
  RxList files = [].obs;
  RxBool isLoading = false.obs;

  Future<void> getFiles(int subjectId) async {
    isLoading.value = true;

    files.value =
    await LectureRemote.getLecturesBySubject(subjectId);

    isLoading.value = false;
  }

  Future<void> onDownload(String fileUrl) async {
    final uri = Uri.parse(fileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("خطأ", "لا يمكن فتح الملف");
    }
  }

  void onBack() => Get.back();
}
//هذا الكنترول  حق الطالب حق استقبال الملفات 
