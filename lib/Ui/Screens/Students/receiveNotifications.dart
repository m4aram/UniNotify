import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uninotify_project/Framework/Class/statusrequest.dart';

import '../../../Controller/controllerstudent/StudentHomeController.dart';
import '../../../Controller/controllerstudent/StudentNotificationsController.dart';

import '../../Widgets/customBottonNavegtor.dart';
import '../../Widgets/customCardNotificton.dart';
import '../../Widgets/customGestureDetector.dart';
import '../../Widgets/customAppBar.dart';

class StudentReceiveNotifications extends StatefulWidget {
  const StudentReceiveNotifications({super.key});

  @override
  State<StudentReceiveNotifications> createState() =>
      _StudentReceiveNotificationsState();
}

class _StudentReceiveNotificationsState
    extends State<StudentReceiveNotifications> {
  late final StudentNotificationsController controller;
  late final StudentHomeController homeController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StudentNotificationsController());
    homeController = Get.find<StudentHomeController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.currentIndex.value = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "notifications".tr,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(
              () => CustomToggleBar(
                items: ["lecture".tr, "academic".tr],
                selectedIndex: controller.selectedIndex.value,
                onChanged: controller.changeTab,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.statusRequest.value == StatusRequest.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.notifications.isEmpty) {
                return Center(
                  child: Text(
                    "no_notifications".tr,
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final n = controller.notifications[index];
                  final bool isUnread = (n['is_read'] ?? 0) == 0;

                  // ✅ اجمعي كل الاحتمالات + حوّليها لنص
                  final String dateLocal =
                      (n['date_local'] ?? n['date'] ?? n['event_day'] ?? '').toString();
                  final String timeLocal =
                      (n['time_local'] ?? n['time'] ?? n['event_time'] ?? '').toString();

                  // ✅ receivedTime دائماً نص، ولو فاضي يرجع ""
                  final String receivedTime =
                      (n['sent_time_local'] ??
                              _formatSentTime(
                                (n['sent_at_local'] ?? n['sent_at'] ?? n['sent_at_utc'] ?? '')
                                    .toString(),
                              ) ??
                              "")
                          .toString();

                  // ✅ لا تعرضي 🕒 لو الوقت فاضي
                  final String dayText = _formatDay(dateLocal);
                  final String dateTimeText =
                      timeLocal.trim().isEmpty ? dayText : "$dayText  🕒 $timeLocal";

                  return InkWell(
                    onTap: () {
                      if (isUnread) controller.markAsRead(n['id']);
                    },
                    child: Stack(
                      children: [
                        CustomCardNotificton(
                          title: (n["title"] ?? "").toString(),
                          description: (n["description"] ?? "").toString(),
                          doctor: (n["sender"] ?? "").toString(),
                          dateTime: dateTimeText,
                          receivedTime: receivedTime,
                        ),
                        if (isUnread)
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => CustomBottonNavegtor(
          currentIndex: homeController.currentIndex.value,
          onTap: homeController.onBottomNavTap,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: "home".tr),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_copy_rounded), label: "file".tr),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active_rounded),
                label: "notifications".tr),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_rounded), label: "feedback".tr),
          ],
        ),
      ),
    );
  }

  // ✅ نسخة آمنة: ما تطيّح التطبيق إذا التاريخ غلط
  String _formatDay(String date) {
    date = date.trim();
    if (date.isEmpty) return "";

    // قيم غلط شائعة من الباك-إند/MySQL
    if (date == "0000-00-00" || date == "0" || date == "-1-11-30") return "";

    final d = DateTime.tryParse(date);
    if (d == null) return "";

    const days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];

    return "${days[d.weekday % 7]} - "
        "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  String? _formatSentTime(String sentAt) {
    sentAt = sentAt.trim();
    if (sentAt.isEmpty) return null;

    try {
      final d = DateTime.parse(sentAt).toLocal();
      return "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return null;
    }
  }
}
