import 'package:get/get.dart';
import '../../../Framework/Constant/routes.dart';

class StudentHomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = 0; // Home
  }

  void onBottomNavTap(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offNamed(AppRoute.StudentHomeScreen);
        break;
      case 1:
        Get.offNamed(AppRoute.StudentreceiveFile);
        break;
      case 2:
        Get.offNamed(AppRoute.StudentReceiveNotifications);
        break;
      case 3:
        Get.offNamed(AppRoute.FeedbackScreen);
        break;
    }
  }

  // نفس أسلوب الأول (دوال منفصلة)
  void goToNotifications() {
    currentIndex.value = 2;
    Get.offNamed(AppRoute.StudentReceiveNotifications);
  }

  void goToFiles() {
    currentIndex.value = 1;
    Get.offNamed(AppRoute.StudentreceiveFile);
  }

  void goToFeedback() {
    currentIndex.value = 3;
    Get.offNamed(AppRoute.FeedbackScreen);
  }
}
