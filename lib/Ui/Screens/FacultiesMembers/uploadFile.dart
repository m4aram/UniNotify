// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../Controller/FacultiesMembersController/FacultiesMembersHome.dart';
import '../../../Controller/FacultiesMembersController/UploadFileController.dart';

import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBotton.dart';
import '../../Widgets/customBottonNavegtor.dart';
import '../../Widgets/customTextFiled.dart';

class FacultiesMembersUploadFileScreen extends StatefulWidget {
  const FacultiesMembersUploadFileScreen({super.key});

  @override
  State<FacultiesMembersUploadFileScreen> createState() =>
      _FacultiesMembersUploadFileScreenState();
}

class _FacultiesMembersUploadFileScreenState
    extends State<FacultiesMembersUploadFileScreen> {
  late final FacultiesMembersController navController;
  late final UploadFileController uploadController;

  @override
  void initState() {
    super.initState();
    navController = Get.find<FacultiesMembersController>();
    uploadController = Get.put(UploadFileController());
    navController.currentIndex.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "upload_file".tr),

      body: Stack(
        children: [
          /// ===== Page Content =====
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ===== Subject Dropdown =====
                Obx(() {
                  if (uploadController.isLoadingSubjects.value) {
                    return const CircularProgressIndicator();
                  }

                  if (uploadController.subjects.isEmpty) {
                    return const Text("لا توجد مواد مرتبطة بك");
                  }

                  return DropdownButtonFormField<int>(
                    value: uploadController.selectedSubjectId.value == 0
                        ? null
                        : uploadController.selectedSubjectId.value,
                    decoration: InputDecoration(
                      hintText: "subject".tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    items: uploadController.subjects.map((s) {
                      return DropdownMenuItem<int>(
                        value: int.parse(s['subject_id'].toString()),
                        child: Text(s['name'].toString()),
                      );
                    }).toList(),
                    onChanged: (v) {
                      uploadController.selectedSubjectId.value = v ?? 0;
                    },
                  );
                }),

                const SizedBox(height: 20),

                /// ===== Teaching Type =====
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: uploadController.selectedTeachingType.value.isEmpty
                        ? null
                        : uploadController.selectedTeachingType.value,
                    decoration: InputDecoration(
                      hintText: "teaching_type".tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    items: uploadController.teachingTypes.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (v) {
                      uploadController.selectedTeachingType.value = v ?? "";
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// ===== Choose File =====
                Obx(
                  () => CustomButton(
                    title: "choose_file".tr,
                    width: 180,
                    onTap: uploadController.isLoading.value
                        ? () {}
                        : () {
                            uploadController.pickFile();
                          },
                  ),
                ),

                const SizedBox(height: 20),

                /// ===== Title =====
                CustomTextField(
                  controller: uploadController.titleController,
                  labelText: "write_name".tr,
                ),

                const SizedBox(height: 12),

                /// ===== Description =====
                CustomTextField(
                  controller: uploadController.descriptionController,
                  labelText: "write_description".tr,
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                /// ===== Upload Button =====
                Obx(
                  () => CustomButton(
                    title: "upload".tr,
                    width: 180,
                    onTap: uploadController.isLoading.value
                        ? () {}
                        : () {
                            uploadController.uploadFile(); // بدون async/await
                          },
                  ),
                ),
              ],
            ),
          ),

          /// ===== Loading Overlay (نفس حق الفيدباك) =====
          Obx(() {
            if (!uploadController.isLoading.value) {
              return const SizedBox.shrink();
            }

            return Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.25),
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

      /// ===== Bottom Navigation =====
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
}
