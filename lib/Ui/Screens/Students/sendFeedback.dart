import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../Controller/controllerstudent/FeedbackController.dart';
import '../../../Controller/controllerstudent/StudentHomeController.dart';
import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBotton.dart';
import '../../Widgets/customTextFiled.dart';
import '../../Widgets/customBottonNavegtor.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late final FeedbackController controller;
  late final StudentHomeController homeController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FeedbackController());
    homeController = Get.find<StudentHomeController>();
    homeController.currentIndex.value = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: CustomAppBar(
        title: "feedback".tr,
      ),

      body: Stack(
        children: [
          /// ===== Page Content =====
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// ===== Feedback type =====
                Obx(
                      () => DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: controller.selectedFeedbackType.value.isEmpty
                        ? null
                        : controller.selectedFeedbackType.value,
                    decoration: InputDecoration(
                      hintText: "select_feedback_type".tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: controller.feedbackTypes
                        .map(
                          (e) => DropdownMenuItem<String>(
                        value: e["id"],
                        child: Text(e["valAr"] ?? ""),
                      ),
                    )
                        .toList(),
                    onChanged: (v) =>
                    controller.selectedFeedbackType.value = v ?? "",
                  ),
                ),

                const SizedBox(height: 16),

                /// ===== Program - Level (بدون Group) =====
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Obx(
                            () => DropdownButtonFormField<int>(
                          value: controller.selectedProgramId.value == 0
                              ? null
                              : controller.selectedProgramId.value,
                          decoration:  InputDecoration(
                            hintText: "select_program".tr,
                            border: OutlineInputBorder(),
                          ),
                          items: controller.programs
                              .map<DropdownMenuItem<int>>((p) {
                            return DropdownMenuItem<int>(
                              value: p['program_id'],
                              child: Text(p['name']),
                            );
                          }).toList(),
                          onChanged: (v) {
                            controller.selectedProgramId.value = v ?? 0;
                            controller.selectedLevelId.value = 0;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Obx(
                            () => DropdownButtonFormField<int>(
                          value: controller.selectedLevelId.value == 0
                              ? null
                              : controller.selectedLevelId.value,
                          decoration:  InputDecoration(
                            hintText: "select_level".tr,
                            border: OutlineInputBorder(),
                          ),
                          items: controller.filteredLevels
                              .map<DropdownMenuItem<int>>((l) {
                            return DropdownMenuItem<int>(
                              value: l['level_id'],
                              child: Text(l['name']),
                            );
                          }).toList(),
                          onChanged: (v) =>
                          controller.selectedLevelId.value = v ?? 0,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// ===== Name =====
                CustomTextField(
                  controller: controller.nameController,
                  labelText: "write_name".tr,
                ),

                const SizedBox(height: 18),

                /// ===== Feedback =====
                CustomTextField(
                  controller: controller.feedbackController,
                  labelText: "write_feedback".tr,
                  maxLines: 6,
                ),

                const SizedBox(height: 30),

                /// ===== Submit =====
                Obx(
                      () => CustomButton(
                    title: "submit".tr,
                    width: 150,
                    borderRadius: 14,
                    onTap: controller.isLoading.value
                        ? () {}
                        : () {
                      controller.submitFeedback(); // بدون await
                    },
                  ),
                ),



              ],
            ),
          ),

          /// ===== Loading Overlay =====
          Obx(() {
            if (!controller.isLoading.value) return const SizedBox.shrink();

            return Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                  child: Center(
                    child: Lottie.asset(
                      "assets/lottie/loading.json",
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),

      bottomNavigationBar: Obx(
            () => CustomBottonNavegtor(
          currentIndex: homeController.currentIndex.value,
          onTap: homeController.onBottomNavTap,
         items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: "home".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.file_copy_rounded),
              label: "files".tr,
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
