import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uninotify_project/Data/DataSource/remote/notifications/doctor_notifications_data.dart';
import 'package:uninotify_project/Framework/Class/statusrequest.dart';
import 'package:uninotify_project/Framework/Class/crud.dart';

class ReceiveNotificationsController extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;

  late DoctorNotificationsData notificationsData;

  RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs;

  int? doctorUserId;

  RxInt drawerIndex = 0.obs;
  // 0 = Receive Notifications
  // 1 = Send Notifications

  @override
  void onInit() {
    super.onInit();
    notificationsData = DoctorNotificationsData(Get.find<Crud>());
    _loadDoctorAndFetch();
  }

  Future<void> _loadDoctorAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    doctorUserId = prefs.getInt("user_id");

    if (doctorUserId == null) {
      statusRequest.value = StatusRequest.failure;
      return;
    }

    await getNotifications();
  }

  Future<void> getNotifications() async {
    statusRequest.value = StatusRequest.loading;

    final response =
        await notificationsData.getDoctorNotifications(doctorUserId!);

    response.fold(
      (failure) {
        statusRequest.value = failure;
      },
      (res) {
        notifications.clear();

        if (res['status'] == true && res['data'] != null) {
          final d = res['data'];
          final List data = (d is List) ? d : [];

          for (final raw in data) {
            notifications.add(_normalizeNotification(raw));
          }
        }

        statusRequest.value = StatusRequest.success;
      },
    );
  }

  /// ✅ تحويل مواعيد الإشعار إلى Local (بدون ما نخرب بيانات السيرفر)
  Map<String, dynamic> _normalizeNotification(dynamic raw) {
    final n = Map<String, dynamic>.from(raw ?? {});

    // نحاول نحافظ على نفس مفاتيح الطالب
    final String? eventDate = n["event_date"]?.toString();
    final String? eventTime =
        n["event_time"]?.toString(); // غالباً HH:mm أو HH:mm:ss
    final String? sentAtStr =
        n["sent_at"]?.toString() ?? n["created_at"]?.toString();

    // sent_at local
    DateTime? sentLocal;
    if (sentAtStr != null && sentAtStr.isNotEmpty) {
      try {
        sentLocal = DateTime.parse(sentAtStr).toLocal();
      } catch (_) {}
    }

    // event local (لو موجود event_date)
    DateTime? eventLocal;
    if (eventDate != null && eventDate.isNotEmpty) {
      try {
        final safeTime = (eventTime == null || eventTime.isEmpty)
            ? "00:00"
            : eventTime.substring(0, 5); // HH:mm
        eventLocal = DateTime.parse("$eventDate $safeTime").toLocal();
      } catch (_) {}
    }

    // قيم جاهزة للواجهة
    final dateLocal = eventLocal != null
        ? "${eventLocal.year}-${eventLocal.month.toString().padLeft(2, '0')}-${eventLocal.day.toString().padLeft(2, '0')}"
        : (eventDate ??
            (sentAtStr != null && sentAtStr.length >= 10
                ? sentAtStr.substring(0, 10)
                : ""));

    final timeLocal = eventLocal != null
        ? "${eventLocal.hour.toString().padLeft(2, '0')}:${eventLocal.minute.toString().padLeft(2, '0')}"
        : (eventTime != null && eventTime.isNotEmpty
            ? eventTime.substring(0, 5)
            : (sentLocal != null
                ? "${sentLocal.hour.toString().padLeft(2, '0')}:${sentLocal.minute.toString().padLeft(2, '0')}"
                : (n["sent_time"]?.toString() ?? "")));

    final sentTimeLocal = sentLocal != null
        ? "${sentLocal.hour.toString().padLeft(2, '0')}:${sentLocal.minute.toString().padLeft(2, '0')}"
        : (n["sent_time"]?.toString() ?? "");

    return {
      "title": n["title"],
      "description": n["description"] ?? "",
      "sender": n["sender"],

      // ✅ نفس مفاتيح الطالب (لكن محلي)
      "date_local": dateLocal,
      "time_local": timeLocal,

      // ✅ وقت الإرسال الحقيقي (محلي)
      "sent_at_local": sentLocal?.toIso8601String() ?? sentAtStr,
      "sent_time_local": sentTimeLocal,

      "subject": n["subject"],
    };
  }

  Future<void> refreshNotifications() async {
    await getNotifications();
  }
}
