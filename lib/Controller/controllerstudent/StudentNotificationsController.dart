import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uninotify_project/Data/DataSource/remote/notifications/student_notifications_data.dart';
import 'package:uninotify_project/Data/DataSource/remote/notifications/mark_notification_read.dart';

import 'package:uninotify_project/Framework/Class/statusrequest.dart';
import 'package:uninotify_project/Framework/Class/crud.dart';

class StudentNotificationsController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList notifications = [].obs;

  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;

  late StudentNotificationsData notificationsData;
  late MarkNotificationReadData markReadData;

  int? studentId;
  List allNotifications = [];

  @override
  void onInit() {
    super.onInit();
    notificationsData = StudentNotificationsData(Get.find<Crud>());
    markReadData = MarkNotificationReadData(Get.find<Crud>());
    _loadStudentAndFetch();
  }

  Future<void> _loadStudentAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    studentId = prefs.getInt("student_id");

    if (studentId == null) {
      statusRequest.value = StatusRequest.failure;
      return;
    }

    await getNotifications();
  }

  Future<void> getNotifications() async {
    statusRequest.value = StatusRequest.loading;

    final response = await notificationsData.getStudentNotifications(studentId!);

    response.fold(
      (failure) {
        statusRequest.value = failure;
      },
      (res) {
        final List raw = List.from(res['data'] ?? []);

        // ✅ تحويل التوقيت محلي + تجهيز حقول جاهزة للعرض
        allNotifications = raw.map((e) => _normalizeNotification(e)).toList();

        filterNotifications();
        statusRequest.value = StatusRequest.success;
      },
    );
  }

  /// ✅ يحول sent_at و (date/time) للوقت المحلي
  Map<String, dynamic> _normalizeNotification(dynamic e) {
    final Map<String, dynamic> n = Map<String, dynamic>.from(e);

    // sent_at
    final sentAtStr = (n['sent_at'] ?? '').toString();
    DateTime? sentAtLocal;
    if (sentAtStr.isNotEmpty) {
      try {
        sentAtLocal = DateTime.parse(sentAtStr).toLocal();
      } catch (_) {}
    }

    // موعد الحدث: عندك date + time (من event_day/event_time غالباً)
    final dateStr = (n['date'] ?? '').toString(); // yyyy-MM-dd
    final timeStr = (n['time'] ?? '').toString(); // HH:mm أو null

    DateTime? eventLocal;
    if (dateStr.isNotEmpty) {
      try {
        // لو الوقت فاضي، نخليه 00:00
        final safeTime = (timeStr.isEmpty) ? "00:00" : timeStr;
        eventLocal = DateTime.parse("${dateStr} $safeTime").toLocal();
      } catch (_) {}
    }

    // نخزن حقول جاهزة للعرض
    if (sentAtLocal != null) {
      n['sent_at_local'] = sentAtLocal.toIso8601String();
      n['sent_time_local'] =
          "${sentAtLocal.hour.toString().padLeft(2, '0')}:${sentAtLocal.minute.toString().padLeft(2, '0')}";
    } else {
      n['sent_at_local'] = sentAtStr;
      n['sent_time_local'] = null;
    }

    if (eventLocal != null) {
      n['date_local'] =
          "${eventLocal.year}-${eventLocal.month.toString().padLeft(2, '0')}-${eventLocal.day.toString().padLeft(2, '0')}";
      n['time_local'] =
          "${eventLocal.hour.toString().padLeft(2, '0')}:${eventLocal.minute.toString().padLeft(2, '0')}";
    } else {
      n['date_local'] = dateStr;
      n['time_local'] = timeStr;
    }

    return n;
  }

  Future<void> markAsRead(int notificationId) async {
    if (studentId == null) return;

    await markReadData.markRead(
      notificationId: notificationId,
      studentId: studentId!,
    );

    final index = notifications.indexWhere((e) => e['id'] == notificationId);
    if (index != -1) {
      notifications[index]['is_read'] = 1;
      notifications.refresh();
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
    filterNotifications();
  }

  void filterNotifications() {
    notifications.clear();

    if (selectedIndex.value == 0) {
      notifications.addAll(
        allNotifications.where((e) => e['subject'] == 'محاضرات'),
      );
    } else {
      notifications.addAll(
        allNotifications.where((e) => e['subject'] == 'أكاديمي'),
      );
    }
  }
}
