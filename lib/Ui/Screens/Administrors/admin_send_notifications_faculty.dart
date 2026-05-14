import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../Controller/Administrator/adminController.dart';
import '../../../Controller/Administrator/AdminSendToDoctorsController.dart';

import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBotton.dart';
import '../../Widgets/customBottonNavegtor.dart';
import '../../Widgets/customTextFiled.dart';
import '../../Widgets/customGestureDetector.dart';

class AdminSendNotificationsFaculty extends StatefulWidget {
  const AdminSendNotificationsFaculty({super.key});

  @override
  State<AdminSendNotificationsFaculty> createState() =>
      _AdminSendNotificationsFacultyState();
}

class _AdminSendNotificationsFacultyState
    extends State<AdminSendNotificationsFaculty> {
  int selectedIndex = 0;
  late final AdminController navController;
  late final AdminSendToDoctorsController controller;

  @override
  void initState() {
    super.initState();

    /// ✅ حماية من تكرار الإنشاء
    controller = Get.isRegistered<AdminSendToDoctorsController>()
        ? Get.find<AdminSendToDoctorsController>()
        : Get.put(AdminSendToDoctorsController());

    navController = Get.find<AdminController>();
    controller.drawerIndex.value = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.currentIndex.value = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// ================= Drawer =================
      drawer: Drawer(
        backgroundColor: theme.colorScheme.primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active_rounded,
                        color: theme.colorScheme.onPrimary),
                    const SizedBox(width: 8),
                    Text(
                      "notifications".tr,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                /// Faculty
                Obx(
                  () => RadioListTile<int>(
                    value: 0,
                    groupValue: controller.drawerIndex.value,
                    activeColor: theme.colorScheme.onPrimary,
                    title: Text(
                      "faculty_home".tr,
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                    onChanged: (v) {
                      controller.drawerIndex.value = 0;
                      Get.back();
                    },
                  ),
                ),

                /// Students
                Obx(
                  () => RadioListTile<int>(
                    value: 1,
                    groupValue: controller.drawerIndex.value,
                    activeColor: theme.colorScheme.onPrimary,
                    title: Text(
                      "student_home".tr,
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                    onChanged: (v) {
                      controller.drawerIndex.value = 1;
                      Get.back();
                      Get.offNamed('/StudentSendNotificationsScreen');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      /// ================= AppBar =================
      appBar: CustomAppBar(
        title: "notifications".tr,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      /// ================= Body =================
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 250));
              controller.resetForm(); // ✅ يمسح البيانات
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  /// Toggle (ثابت)
                  CustomToggleBar(
                    items: ["faculty_home".tr],
                    selectedIndex: selectedIndex,
                    width: 290,
                    height: 42,
                    borderRadius: 14,
                    fontSize: 14,
                    onChanged: (i) => setState(() => selectedIndex = i),
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 نوع الإشعار
                  GetBuilder<AdminSendToDoctorsController>(
                    builder: (_) => DropdownButtonFormField<int>(
                      value: controller.subtypeId,
                      decoration: InputDecoration(
                        hintText: "select_notification_type".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items: controller.academicNotificationTypes
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e["subtype_id"],
                              child: Text(e["name"]),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        controller.subtypeId = v;
                        controller.update();
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 الوصف
                  CustomTextField(
                    labelText: "describe_notification".tr,
                    controller: controller.descriptionController,
                    maxLines: 5,
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Time + Day
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => GestureDetector(
                            onTap: () => controller.pickDate(context),
                            child: AbsorbPointer(
                              child: CustomTextField(
                                labelText:
                                    controller.eventDay.value == "select_date"
                                        ? "date".tr
                                        : controller.eventDay.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(
                          () => GestureDetector(
                            onTap: () => controller.pickTime(context),
                            child: AbsorbPointer(
                              child: CustomTextField(
                                labelText: controller.eventTime.value == "time"
                                    ? "time".tr
                                    : controller.eventTime.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// 🔹 Send Button (يتعطل وقت التحميل)
                  GetBuilder<AdminSendToDoctorsController>(
                    builder: (_) => IgnorePointer(
                      ignoring: controller.isLoading,
                      child: CustomButton(
                        title: controller.isLoading
                            ? "جاري الإرسال..."
                            : "send".tr,
                        width: 180,
                        borderRadius: 14,
                        onTap: controller.sendNotification,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= Loading Overlay =================
          GetBuilder<AdminSendToDoctorsController>(
            builder: (_) {
              if (!controller.isLoading) return const SizedBox.shrink();

              return Container(
                color: Colors.black.withOpacity(0.35),
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 160,
                    height: 160,
                    repeat: true,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      /// ================= Bottom Navigation =================
      bottomNavigationBar: Obx(
        () => CustomBottonNavegtor(
          currentIndex: navController.currentIndex.value,
          onTap: navController.onBottomNavTap,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded), label: "home".tr),
            BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_rounded), label: "report".tr),
            BottomNavigationBarItem(
                icon: const Icon(Icons.notifications_active_rounded),
                label: "notifications".tr),
            BottomNavigationBarItem(
                icon: const Icon(Icons.chat_rounded), label: "feedback".tr),
          ],
        ),
      ),
    );
  }
}
