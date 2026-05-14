import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uninotify_project/Controller/FacultiesMembersController/FacultiesMembersHome.dart';

import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBottonNavegtor.dart';
import '../../Widgets/customCardHome.dart';
import '../../Widgets/customDrawer.dart';

class FacultiesMembersHome extends StatelessWidget {
  const FacultiesMembersHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FacultiesMembersController>();
    final theme = Theme.of(context);

    return Scaffold(
      // ✅ بدل AppColors.background
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const CustomDrawer(),

      appBar: CustomAppBar(
        title: "home".tr,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 120),
            CustomCardHome(
              title: "send_notifications".tr,
              onTap: controller.goToSendNotifications,
            ),
            const SizedBox(height: 20),
            CustomCardHome(
              title: "receive_notifications".tr,
              onTap: controller.goToNotifications,
            ),
            const SizedBox(height: 20),
            CustomCardHome(
              title: "upload_file".tr,
              onTap: controller.goToFiles,
            ),
            const SizedBox(height: 20),
            CustomCardHome(
              title: "feedback".tr,
              onTap: controller.goToFeedback,
            ),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => CustomBottonNavegtor(
          currentIndex: controller.currentIndex.value,
          onTap: controller.onBottomNavTap,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: "home".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.file_copy_rounded),
              label: "file".tr,
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
