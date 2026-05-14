import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/Administrator/adminController.dart';
import '../../../Controller/Administrator/adminReportController.dart';
import '../../../Framework/Class/handlingDataView.dart';
import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBotton.dart';
import '../../Widgets/customBottonNavegtor.dart';
import '../../Widgets/customCheckBox.dart';
import '../../Widgets/customList.dart';

class AdminReportScreen extends GetView<AdminReportController> {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(AdminReportController(), permanent: false);
    final navController = Get.find<AdminController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.currentIndex.value = 1;
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: "report".tr),
      body: GetBuilder<AdminReportController>(
        builder: (controller) {
          // ✅ لو اخترنا Sent Notifications + Doctors => نخفي فلاتر الطلاب
          final bool isDoctorsTarget = controller.sentNotifications &&
              controller.sentTarget == SentTarget.doctors;

          return Handlingdatarequest(
            statusRequest: controller.statusRequest,
            widget: RefreshIndicator(
              onRefresh: controller.resetForm,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Report type =====
                      Text(
                        "report_type".tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Customlist(
                        label: "",
                        value: controller.reportType,
                        items: controller.reportTypes,
                        onChanged: controller.changeReportType,
                      ),

                      const SizedBox(height: 20),

                      // ✅ نفس مكان Program القديم — بس نخليه Disabled لو Doctors
                      IgnorePointer(
                        ignoring: isDoctorsTarget,
                        child: Opacity(
                          opacity: isDoctorsTarget ? 0.45 : 1,
                          child: Customlist(
                            label: "select_program".tr,
                            value: controller.programName,
                            items: controller.programNames,
                            onChanged: controller.changeProgramByName,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ نفس Row القديم (Level / Group / Date) — بس نعطل Level/Group لو Doctors
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: IgnorePointer(
                              ignoring: isDoctorsTarget,
                              child: Opacity(
                                opacity: isDoctorsTarget ? 0.45 : 1,
                                child: Customlist(
                                  label: "select_level".tr,
                                  value: controller.levelName,
                                  items: controller.levelNames,
                                  onChanged: controller.changeLevelByName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 4,
                            child: IgnorePointer(
                              ignoring: isDoctorsTarget,
                              child: Opacity(
                                opacity: isDoctorsTarget ? 0.45 : 1,
                                child: Customlist(
                                  label: "select_group".tr,
                                  items: controller.groupLabels,
                                  value: controller.groupLabel,
                                  onChanged: controller.changeGroupByLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  menuMaxLines: 3,
                                  menuOverflow: TextOverflow.ellipsis,
                                  itemBuilder: (s) {
                                    if (s.contains('-')) {
                                      final parts = s.split('-');
                                      final subject = parts[0].trim();
                                      final group = parts[1].trim();
                                      return "$group\n$subject";
                                    }
                                    return s;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // ✅ Date يظل شغال دائمًا (حتى للدكاترة)
                          Expanded(
                            flex: 4,
                            child: InkWell(
                              onTap: () => controller.pickDate(context),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "date".tr,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                ),
                                child: Text(
                                  controller.dateRangeLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // ===== Data type =====
                      Text(
                        "data_type".tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      CustomCheckBox(
                        title: "unfinished_lectures".tr,
                        value: controller.unfinishedLectures,
                        onChanged: (v) => controller.toggleUnfinished(v ?? false),
                      ),

                      CustomCheckBox(
                        title: "sent_notifications".tr,
                        value: controller.sentNotifications,
                        onChanged: (v) =>
                            controller.toggleSentNotifications(v ?? false),
                      ),

                      // ✅ NEW: Target يجي تحت الـ checkboxes (بدون تخريب تصميمك)
                      if (controller.sentNotifications) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "target".tr,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<SentTarget>(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text("students".tr),
                                      value: SentTarget.students,
                                      groupValue: controller.sentTarget,
                                      onChanged: (v) {
                                        if (v != null) {
                                          controller.setSentTarget(v);
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<SentTarget>(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text("doctors".tr),
                                      value: SentTarget.doctors,
                                      groupValue: controller.sentTarget,
                                      onChanged: (v) {
                                        if (v != null) {
                                          controller.setSentTarget(v);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      // ===== Generate =====
                      Center(
                        child: CustomButton(
                          title: "generate_report".tr,
                          width: 180,
                          onTap: controller.generateReport,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

      // ===== Bottom Nav =====
      bottomNavigationBar: Obx(() {
        final navController = Get.find<AdminController>();
        return CustomBottonNavegtor(
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
        );
      }),
    );
  }
}
