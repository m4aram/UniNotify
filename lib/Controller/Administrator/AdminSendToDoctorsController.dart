import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Framework/Class/statusrequest.dart';
import '../../Framework/Constant/color.dart';
import '../../Framework/Class/crud.dart';
import '../../liinkapi.dart';
import '../AppController.dart';

class AdminSendToDoctorsController extends GetxController {
  final AppController app = Get.find<AppController>();

  RxInt drawerIndex = 0.obs;
  final String targetRole = 'doctor';

  StatusRequest statusRequest = StatusRequest.none;
  bool get isLoading => statusRequest == StatusRequest.loading;

  int? subtypeId;

  // عرض بالواجهة (محلي)
  RxString eventDay = "select_date".obs; // yyyy-MM-dd
  RxString eventTime = "time".obs; // HH:mm

  // اختيار فعلي (محلي)
  DateTime? _pickedDateLocal;
  TimeOfDay? _pickedTimeLocal;

  final TextEditingController descriptionController = TextEditingController();

  List get academicNotificationTypes =>
      app.notificationSubtypes.where((e) => e['category_id'] == 2).toList();

  String _two(int n) => n.toString().padLeft(2, '0');

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _refreshDisplayStrings() {
    if (_pickedDateLocal != null) {
      eventDay.value =
          "${_pickedDateLocal!.year}-${_two(_pickedDateLocal!.month)}-${_two(_pickedDateLocal!.day)}";
    } else {
      eventDay.value = "select_date";
    }

    if (_pickedTimeLocal != null) {
      eventTime.value =
          "${_two(_pickedTimeLocal!.hour)}:${_two(_pickedTimeLocal!.minute)}";
    } else {
      eventTime.value = "time";
    }
  }

  /// ✅ يبني موعد UTC إذا (تاريخ + وقت) موجودين
  /// يرجع null إذا ما اختاروا (يعني فوري)
  /// يرجع "invalid" إذا في اختيار ناقص أو ماضي
  Map<String, String>? buildUtcEventOrNull() {
    final hasDate = _pickedDateLocal != null;
    final hasTime = _pickedTimeLocal != null;

    // فوري
    if (!hasDate && !hasTime) return null;

    // ناقص (واحد بدون الثاني)
    if (hasDate != hasTime) return {"_invalid": "1"};

    final local = DateTime(
      _pickedDateLocal!.year,
      _pickedDateLocal!.month,
      _pickedDateLocal!.day,
      _pickedTimeLocal!.hour,
      _pickedTimeLocal!.minute,
    );

    if (local.isBefore(DateTime.now())) return {"_invalid": "1"};

    final utc = local.toUtc();
    return {
      "event_day": "${utc.year}-${_two(utc.month)}-${_two(utc.day)}",
      "event_time": "${_two(utc.hour)}:${_two(utc.minute)}:00",
    };
  }

  /// ================= Pick Date =================
  void pickDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDateLocal ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _pickedDateLocal = picked;

      // لو اليوم و الوقت المختار صار ماضي، صفري الوقت
      if (_pickedTimeLocal != null && _isSameDay(picked, now)) {
        final check = DateTime(
          now.year,
          now.month,
          now.day,
          _pickedTimeLocal!.hour,
          _pickedTimeLocal!.minute,
        );
        if (check.isBefore(now)) {
          _pickedTimeLocal = null;
        }
      }

      _refreshDisplayStrings();
    }
  }

  /// ================= Pick Time =================
  void pickTime(BuildContext context) async {
    // نخليها مثل ما هي: لازم تاريخ عشان نعرف هل الوقت ماضي لليوم
    if (_pickedDateLocal == null) {
      Get.snackbar("تنبيه", "اختاري التاريخ أولاً");
      return;
    }

    final now = DateTime.now();
    final isToday = _isSameDay(_pickedDateLocal!, now);

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      if (isToday) {
        final pickedLocal = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
        if (pickedLocal.isBefore(now)) {
          Get.snackbar("خطأ", "اختاري وقت قادم (ليس في الماضي)");
          return;
        }
      }

      _pickedTimeLocal = time;
      _refreshDisplayStrings();
    }
  }

  /// ================= Send =================
  Future<void> sendNotification() async {
    if (isLoading) return;

    if (subtypeId == null || descriptionController.text.trim().isEmpty) {
      Get.snackbar("خطأ", "الرجاء تعبئة جميع البيانات");
      return;
    }

    final senderId = app.userId;
    if (senderId == null) {
      Get.snackbar("خطأ", "انتهت الجلسة، سجّل دخول مرة ثانية");
      return;
    }

    final utcEvent = buildUtcEventOrNull();
    if (utcEvent != null && utcEvent.containsKey("_invalid")) {
      Get.snackbar("خطأ", "اختاري التاريخ والوقت معًا وبوقت غير ماضي، أو اتركيهما للإشعار الفوري");
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    try {
      final crud = Get.find<Crud>();

      final Map<String, dynamic> body = {
        "sender_user_id": senderId.toString(),
        "target_role": targetRole,
        "subtype_id": subtypeId.toString(),
        "description": descriptionController.text.trim(),
      };

      // ✅ لو فوري: لا نرسل event_day / event_time
      if (utcEvent != null) {
        body.addAll(utcEvent);
      }

      final response = await crud.postData(Applink.sendNotification, body);

      response.fold(
        (_) {
          statusRequest = StatusRequest.failure;
          Get.snackbar("خطأ", "فشل الاتصال بالسيرفر");
        },
        (data) {
          if (data['status'] == true) {
            statusRequest = StatusRequest.success;
            Get.snackbar("نجاح", data['message'] ?? "تم الإرسال");
            resetForm();
          } else {
            statusRequest = StatusRequest.failure;
            Get.snackbar("خطأ", data['message'] ?? "فشل الإرسال");
          }
        },
      );
    } finally {
      update();
    }
  }

  void resetForm() {
    subtypeId = null;
    _pickedDateLocal = null;
    _pickedTimeLocal = null;
    _refreshDisplayStrings();
    descriptionController.clear();
    statusRequest = StatusRequest.none;
    update();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
