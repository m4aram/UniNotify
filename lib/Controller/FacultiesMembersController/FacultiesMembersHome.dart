import 'package:get/get.dart';
import '../../Framework/Constant/routes.dart';
class FacultiesMembersController extends GetxController {
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
        Get.offNamed(AppRoute.FacultiesMembersHome);
        break;
      case 1:
        Get.offNamed(AppRoute.FacultiesMembersUploadFileScreen);
        break;
      case 2:
        Get.offNamed(AppRoute.FacultiesMembersReceiveNotifications);
        break;
      case 3:
        Get.offNamed(AppRoute.FacultiesMembersFeedbackScreen);
        break;
    }
  }

  void goToSendNotifications() {
    Get.offNamed(AppRoute.SendNotificationsScreen);
  }

  void goToNotifications() {
    currentIndex.value = 2;
    Get.offNamed(AppRoute.FacultiesMembersReceiveNotifications);
  }

  void goToFiles() {
    currentIndex.value = 1;
    Get.offNamed(AppRoute.FacultiesMembersUploadFileScreen);
  }

  void goToFeedback() {
    currentIndex.value = 3;
    Get.offNamed(AppRoute.FacultiesMembersFeedbackScreen);
  }
}
