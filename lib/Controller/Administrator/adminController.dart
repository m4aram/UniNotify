import 'package:get/get.dart';
import '../../Framework/Constant/routes.dart';

class AdminController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// 🔹 التنقل من BottomNavigationBar
  void onBottomNavTap(int index) {
    if (currentIndex.value == index) return;

    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offNamed(AppRoute.AdminHome);
        break;
      case 1:
        Get.offNamed(AppRoute.AdminReport);
        break;
      case 2:
        Get.offNamed(AppRoute.AdminSendNotificationsFaculty);
        break;
      case 3:
        Get.offNamed(AppRoute.AdminFeedback);
        break;
    }
  }

  /// 🔹 التنقل من كروت Home
  void goToSendNotifications() => onBottomNavTap(2);
  void goToReport() => onBottomNavTap(1);
  void goToFeedback() => onBottomNavTap(3);
}
