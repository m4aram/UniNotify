import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/FacultiesMembersController/FacultiesMembersHome.dart';
import '../../../Controller/FacultiesMembersController/ReceiveNotificationsController.dart';

import '../../Widgets/customAppBar.dart';
import '../../Widgets/customBottonNavegtor.dart';
import '../../Widgets/customCardNotificton.dart';
import '../../Widgets/customGestureDetector.dart';
import '../../../Framework/Class/statusrequest.dart';

class FacultiesMembersReceiveNotifications extends StatefulWidget {
  const FacultiesMembersReceiveNotifications({super.key});

  @override
  State<FacultiesMembersReceiveNotifications> createState() =>
      _FacultiesMembersReceiveNotificationsState();
}

class _FacultiesMembersReceiveNotificationsState
    extends State<FacultiesMembersReceiveNotifications> {
  late final ReceiveNotificationsController controller;
  late final FacultiesMembersController navController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReceiveNotificationsController());
    navController = Get.find<FacultiesMembersController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.currentIndex.value = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                    },
                  ),
                ),
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
                      Get.offNamed('/SendNotificationsScreen');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: CustomAppBar(
        title: "notifications".tr,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomToggleBar(
              items: ["academic".tr],
              selectedIndex: 0,
              onChanged: (_) {},
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
                    "لا توجد إشعارات",
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshNotifications,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 12),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final n = controller.notifications[index];

                    final dateLocal = (n["date_local"] ?? "").toString();
                    final timeLocal = (n["time_local"] ?? "").toString();

                    final receivedTime = (n["sent_time_local"] ??
                            _formatSentTime(
                                (n["sent_at_local"] ?? "").toString()) ??
                            "")
                        .toString();

                    return CustomCardNotificton(
                      title: n["title"] ?? "",
                      description: n["description"] ?? "",
                      doctor: n["sender"] ?? "",
                      dateTime: "${_formatDay(dateLocal)}  🕒 $timeLocal",
                      receivedTime: receivedTime,
                    );
                  },
                ),
              );
            }),
          ),
        ],
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

  String _formatDay(String date) {
    date = date.trim();
    if (date.isEmpty) return "";

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
    if (sentAt.isEmpty) return null;
    try {
      final d = DateTime.parse(sentAt).toLocal();
      return "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return null;
    }
  }
}
