import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/controllerstudent/StudentHomeController.dart';
import '../../../Controller/controllerstudent/UploadFilesController.dart';
import '../../Widgets/customAppBar.dart';
import '../../Widgets/customUploadFile.dart';
import '../../Widgets/customBottonNavegtor.dart';

class StudentreceiveFile extends StatelessWidget {
  const StudentreceiveFile({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentFilesController filesController =
    Get.put(StudentFilesController());

    final StudentHomeController homeController =
    Get.put(StudentHomeController());

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// ================= AppBar =================
      appBar: CustomAppBar(
        title: "file".tr,
      ),

      /// ================= Body =================
      body: Obx(() {
        if (filesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (filesController.files.isEmpty) {
          return Center(
            child: Text(
              "no_files".tr,
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: filesController.files.length,
          itemBuilder: (context, index) {
            final file = filesController.files[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomUploadFile(
                /// 🟢 العنوان
                title: file['title']?.toString() ?? "",

                /// 🟢 الوصف
                description: file['description']?.toString() ?? "",

                /// 🟢 نفس طريقة العرض (المادة + نوع الملف)
                doctor:
                "المادة: ${file['subject_name'] ?? ''} • ${file['file_type'] ?? ''}",

                /// 🟢 زر التحميل (شغال)
                onDownload: () => filesController.onDownload(
                  file['file_path'],
                ),
              ),
            );
          },
        );
      }),

      /// ================= Bottom Navigation =================
      bottomNavigationBar: Obx(
            () => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CustomBottonNavegtor(
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
      ),
    );
  }
}
