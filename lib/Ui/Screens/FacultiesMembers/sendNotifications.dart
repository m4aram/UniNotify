import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../Controller/FacultiesMembersController/FacultiesMembersHome.dart';
import '../../../Controller/FacultiesMembersController/DoctorSendToStudentsController.dart';

import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBotton.dart';
import '../../Widgets/customBottonNavegtor.dart';
import '../../Widgets/customTextFiled.dart';
import '../../Widgets/customGestureDetector.dart';

class SendNotificationsScreen extends StatefulWidget {
  const SendNotificationsScreen({super.key});

  @override
  State<SendNotificationsScreen> createState() => _SendNotificationsScreenState();
}

class _SendNotificationsScreenState extends State<SendNotificationsScreen> {
  late final DoctorSendToStudentsController controller;
  late final FacultiesMembersController navController;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<DoctorSendToStudentsController>()
        ? Get.find<DoctorSendToStudentsController>()
        : Get.put(DoctorSendToStudentsController());

    navController = Get.find<FacultiesMembersController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.currentIndex.value = 2;

      // ✅ هذه شاشة "Send"
      controller.drawerIndex.value = 1;

      // ❌ لا داعي نستدعي loadFacultySubjects هنا لأن الكنترولر يناديها في onInit
      // controller.loadFacultySubjects();
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
                    Icon(Icons.notifications_active,
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

                /// Receive
                Obx(
                  () => RadioListTile<int>(
                    value: 0,
                    groupValue: controller.drawerIndex.value,
                    activeColor: theme.colorScheme.onPrimary,
                    title: Text(
                      "receive_notifications".tr,
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                    onChanged: (v) {
                      controller.drawerIndex.value = 0;
                      Get.back();
                      Get.offNamed('/FacultiesMembersReceiveNotifications');
                    },
                  ),
                ),

                /// Send
                Obx(
                  () => RadioListTile<int>(
                    value: 1,
                    groupValue: controller.drawerIndex.value,
                    activeColor: theme.colorScheme.onPrimary,
                    title: Text(
                      "send_notifications".tr,
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                    onChanged: (v) {
                      controller.drawerIndex.value = 1;
                      Get.back();
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

              controller.resetForm();
              // ✅ هنا فقط نعيد تحميل مواد الدكتور (عشان dropdown ما يصير فاضي)
              await controller.loadFacultySubjects();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GetBuilder<DoctorSendToStudentsController>(
                builder: (_) => Column(
                  children: [
                    /// ================= Gender =================
                    CustomToggleBar(
                      items: ["girls".tr, "boys".tr],
                      selectedIndex: controller.genderIndex.value,
                      onChanged: (i) {
                        controller.genderIndex.value = i;
                        controller.update();
                      },
                    ),

                    const SizedBox(height: 16),

                    /// ================= Program =================
                    _dropdownMap(
                      hint: "select_program".tr,
                      items: controller.programs,
                      labelKey: "name",
                      valueKey: "program_id",
                      value: controller.programId,
                      onChanged: (v) => controller.selectProgram(v),
                    ),

                    const SizedBox(height: 12),

                    /// ================= Subject | Level | Group =================
                    Row(
                      children: [
                        Expanded(
                          child: _dropdownMap(
                            hint: "subject".tr,
                            items: controller.filteredSubjects,
                            labelKey: "name",
                            valueKey: "subject_id",
                            value: controller.subjectId,
                            onChanged: (v) => controller.selectSubject(v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _dropdownMap(
                            hint: "select_level".tr,
                            items: controller.levels,
                            labelKey: "name",
                            valueKey: "level_id",
                            value: controller.levelId,
                            onChanged: (v) => controller.selectLevel(v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _dropdownMap(
                            hint: "select_group".tr,
                            items: controller.filteredGroups,
                            labelKey: "name",
                            valueKey: "subject_group_id",
                            value: controller.groupId,
                            onChanged: (v) => controller.selectGroup(v),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// ================= Student =================
                    _dropdownMap(
                      hint: "student_name".tr,
                      items: controller.filteredStudents,
                      labelKey: "login_number",
                      valueKey: "login_number",
                      value: controller.loginNumber,
                      onChanged: (v) => controller.selectStudent(v),
                    ),

                    const SizedBox(height: 12),

                    /// ================= Notification Type =================
                    _dropdownMap(
                      hint: "select_notification_type".tr,
                      items: controller.notificationTypes,
                      labelKey: "name",
                      valueKey: "subtype_id",
                      value: controller.subtypeId,
                      onChanged: (v) => controller.selectSubtype(v),
                    ),

                    const SizedBox(height: 12),

                    /// ================= Description =================
                    CustomTextField(
                      labelText: "describe_notification".tr,
                      controller: controller.descriptionController,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 12),

                    /// ================= Date + Time =================
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.pickDate(context),
                              child: IgnorePointer(
                                child: CustomTextField(
                                  labelText:
                                      controller.eventDay.value == "select_date"
                                          ? "date".tr
                                          : controller.eventDay.value,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.pickTime(context),
                              child: IgnorePointer(
                                child: CustomTextField(
                                  labelText: controller.eventTime.value == "time"
                                      ? "time".tr
                                      : controller.eventTime.value,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ================= Send =================
                    Obx(
                      () => IgnorePointer(
                        ignoring: controller.isSending.value,
                        child: CustomButton(
                          width: 180,
                          title: controller.isSending.value
                              ? "جاري الإرسال..."
                              : "send".tr,
                          onTap: () async {
                            FocusScope.of(context).unfocus(); // ✅ يخفي الكيبورد
                            await controller.sendNotification();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ================= Loading Overlay =================
          Obx(() {
            if (!controller.isSending.value) return const SizedBox.shrink();

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
          }),
        ],
      ),

      /// ================= Bottom Navigation =================
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

  /// ================= Dropdown =================
  Widget _dropdownMap({
    required String hint,
    required List items,
    required String labelKey,
    required String valueKey,
    required Function(dynamic) onChanged,
    dynamic value,
  }) {
    return DropdownButtonFormField(
      isExpanded: true,
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e[valueKey],
              child: Text(
                e.containsKey('login_number')
                    ? "${e['login_number']} - ${e['student_name']}"
                    : e[labelKey].toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
