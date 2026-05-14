import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/Administrator/adminController.dart';
import '../../../Framework/Constant/routes.dart';
import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBottonNavegtor.dart';
import '../../Widgets/customCardHome.dart';
import '../../Widgets/customDrawer.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// كنترول التنقل
    final navController = Get.find<AdminController>();

    /// تثبيت التاب على Home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.currentIndex.value = 0;
    });

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: CustomAppBar(
        title: "home".tr,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomCardHome(
                title: "send_notifications".tr,
                onTap: () =>
                    Get.offAllNamed(AppRoute.AdminSendNotificationsFaculty),
              ),
              const SizedBox(height: 35),

              CustomCardHome(
                title: "receive_feedback".tr,
                onTap: () => Get.offAllNamed(AppRoute.AdminFeedback),
              ),
              const SizedBox(height: 35),

              CustomCardHome(
                title: "report".tr,
                onTap: () => Get.offAllNamed(AppRoute.AdminReport),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Obx(
        () => CustomBottonNavegtor(
          currentIndex: navController.currentIndex.value,
          onTap: navController.onBottomNavTap,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: "home".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_rounded),
              label: "report".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_active_rounded),
              label: "notifications".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_rounded),
              label: "feedback".tr,
            ),
          ],
        ),
      ),
    );
  }
}
