import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../Controller/Administrator/adminFeedbackController.dart';
import '../../../Controller/Administrator/adminController.dart';
import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBottonNavegtor.dart';

class AdminFeedbackScreen extends StatelessWidget {
  const AdminFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// 🔹 Controllers
    final navController = Get.find<AdminController>();
    // ignore: unused_local_variable
    final feedbackController = Get.put(AdminFeedbackControllerImp());

    /// 🔹 ثبت التاب على Feedback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.currentIndex.value = 3;
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: "feedback".tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: GetBuilder<AdminFeedbackControllerImp>(
          builder: (c) {
            /// ✅ Loading first
            if (c.isLoading) {
              return Center(
                child: Lottie.asset(
                  "assets/lottie/loading.json",
                  width: 160,
                  height: 160,
                ),
              );
            }

            /// ✅ No Data
            if (c.feedbackList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/loading.json",
                      width: 220,
                      height: 220,
                    ),
                    const SizedBox(height: 10),

                  ],
                ),
              );
            }

            /// ✅ Data
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Header
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "sender".tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "message".tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "date".tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: theme.dividerColor),

                /// 🔹 Feedback List
                Expanded(
                  child: ListView.builder(
                    itemCount: c.feedbackList.length,
                    itemBuilder: (context, index) {
                      final item = c.feedbackList[index];
                      final isExpanded = c.isExpanded(index);

                      // ✅ حماية من null + تحويل لـ String
                      final name = (item["name"] ?? "").toString();
                      final desc = (item["description"] ?? "").toString();
                      final createdAt = (item["created_at"] ?? "").toString();
                      final levelName = item["level_name"]?.toString();
                      final programName = item["program_name"]?.toString();

                      return Column(
                        children: [
                          InkWell(
                            onTap: () => c.toggleExpanded(index),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// 🔹 Sender (Name + Level + Program)
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isExpanded ? name : c.shorten(name, 12),
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          levelName ?? "-",
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          programName ?? "-",
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// 🔹 Message
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      isExpanded ? desc : c.shorten(desc, 18),
                                      style: theme.textTheme.bodyMedium,
                                      maxLines: isExpanded ? null : 1,
                                      overflow: isExpanded
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                    ),
                                  ),

                                  /// 🔹 Date
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      createdAt,
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// 🔹 Actions when expanded
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: theme.colorScheme.error,
                                    onPressed: () => c.deleteFeedback(index),
                                    tooltip: "delete".tr,
                                  ),
                                ],
                              ),
                            ),

                          Divider(color: theme.dividerColor),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),

      /// 🔹 Bottom Navigation
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
