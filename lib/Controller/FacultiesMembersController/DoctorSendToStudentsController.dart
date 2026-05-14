import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:uninotify_project/Framework/Class/crud.dart';
import 'package:uninotify_project/liinkapi.dart';
import '../AppController.dart';

enum SendMode { none, singleStudent, group }

class DoctorSendToStudentsController extends GetxController {
  final AppController app = Get.find<AppController>();

  /// ================= Drawer =================
  RxInt drawerIndex = 1.obs;

  /// ================= Gender =================
  RxInt genderIndex = 0.obs;
  RxBool isSending = false.obs;
  
  String? get gender {
    if (genderIndex.value == 0) return "female";
    if (genderIndex.value == 1) return "male";
    return null;
  }

  /// ================= Send Mode =================
  Rx<SendMode> sendMode = SendMode.none.obs;

  /// ================= Selected =================
  int? programId;
  int? levelId;
  int? subjectId;
  int? groupId;
  String? loginNumber;
  int? subtypeId;

  /// ================= Date / Time (عرض) =================
  RxString eventDay = "select_date".obs; // yyyy-MM-dd (محلي)
  RxString eventTime = "time".obs; // HH:mm (محلي)

  /// ✅ نخزن الاختيار الحقيقي محلي
  DateTime? _pickedDateLocal;
  TimeOfDay? _pickedTimeLocal;

  String _two(int n) => n.toString().padLeft(2, '0');

  /// ================= Text =================
  final TextEditingController descriptionController = TextEditingController();

  /// ================= Lookups =================
  List get programs => app.programs;
  List get levels => app.levels;
  List get groups => app.subjectGroups;
  List get students => app.students;

  List get notificationTypes =>
      app.notificationSubtypes.where((e) => e['category_id'] == 1).toList();

  /// ✅ IDs مواد الدكتور (من subject_faculty عبر API)
  List<int> facultySubjectIds = [];

  /// ✅ مواد الدكتور فقط
  List get subjects {
    if (facultySubjectIds.isEmpty) return [];
    return app.subjects
        .where((s) => facultySubjectIds.contains(s['subject_id']))
        .toList();
  }

  /// ✅ تحميل مواد الدكتور (GET)
  Future<void> loadFacultySubjects() async {
    final doctorUserId = app.userId;
    if (doctorUserId == null) return;

    try {
      final url =
          Uri.parse("${Applink.getFacultySubjects}?user_id=$doctorUserId");
      final res = await http.get(url);

      final json = jsonDecode(res.body);

      if (json['status'] == true) {
        final List data = List.from(json['data'] ?? []);

        facultySubjectIds = data
            .map((e) => int.tryParse(e['subject_id'].toString()) ?? 0)
            .where((id) => id != 0)
            .toList();

        // صفري اختيار مادة/قروب لأن القائمة تغيّرت
        subjectId = null;
        groupId = null;

        update();
      } else {
        Get.snackbar("خطأ", json['message'] ?? "فشل تحميل مواد الدكتور");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل مواد الدكتور");
    }
  }

  /// ================= Filters =================
  List get filteredSubjects {
    if (programId == null) return [];
    return subjects.where((s) => s['program_id'] == programId).toList();
  }

  List get filteredGroups {
    if (subjectId == null) return [];
    return groups.where((g) => g['subject_id'] == subjectId).toList();
  }

  List get filteredStudents {
    return students.where((s) {
      final int studentId = s['student_id'];

      final bool genderMatch = gender == null || s['gender'] == gender;
      final bool programMatch =
          programId == null || s['program_id'] == programId;
      final bool levelMatch = levelId == null || s['level_id'] == levelId;

      final bool subjectMatch = subjectId == null ||
          (app.studentSubjects[studentId]?.contains(subjectId) ?? false);

      final bool groupMatch = groupId == null ||
          (app.studentGroups[studentId]?.contains(groupId) ?? false);

      return genderMatch &&
          programMatch &&
          levelMatch &&
          subjectMatch &&
          groupMatch;
    }).toList();
  }

  /// ================= Selectors =================
  void selectProgram(int id) {
    programId = id;
    levelId = null;
    subjectId = null;
    groupId = null;
    loginNumber = null;
    sendMode.value = SendMode.group;
    update();
  }

  void selectLevel(int id) {
    levelId = id;
    loginNumber = null;
    sendMode.value = SendMode.group;
    update();
  }

  void selectSubject(int id) {
    subjectId = id;
    groupId = null;
    loginNumber = null;
    sendMode.value = SendMode.group;
    update();
  }

  void selectGroup(int id) {
    groupId = id;
    loginNumber = null;
    sendMode.value = SendMode.group;
    update();
  }

  void selectStudent(String login) {
    loginNumber = login;
    update();
  }

  void selectSubtype(int id) {
    subtypeId = id;
    update();
  }

  /// ================= Helpers =================
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

  /// ✅ فوري: يرجع null إذا ما اختار تاريخ/وقت
  /// ❌ اختيار ناقص أو ماضي: يرجع {"_invalid":"1"}
  /// ✅ مجدول: يرجع event_day/event_time بصيغة UTC
  Map<String, String>? buildUtcEventOrNull() {
    final hasDate = _pickedDateLocal != null;
    final hasTime = _pickedTimeLocal != null;

    // ✅ فوري
    if (!hasDate && !hasTime) return null;

    // ❌ ناقص
    if (hasDate != hasTime) return {"_invalid": "1"};

    final local = DateTime(
      _pickedDateLocal!.year,
      _pickedDateLocal!.month,
      _pickedDateLocal!.day,
      _pickedTimeLocal!.hour,
      _pickedTimeLocal!.minute,
    );

    // ❌ ماضي
    if (local.isBefore(DateTime.now())) return {"_invalid": "1"};

    final utc = local.toUtc();
    return {
      "event_day": "${utc.year}-${_two(utc.month)}-${_two(utc.day)}",
      "event_time": "${_two(utc.hour)}:${_two(utc.minute)}:00",
    };
  }

  /// ================= Pickers =================
  void pickDate(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _pickedDateLocal ?? now,
      firstDate: DateTime(now.year, now.month, now.day), // ✅ من اليوم فقط
      lastDate: DateTime(2030),
    );

    if (date != null) {
      _pickedDateLocal = date;

      // لو غيرت التاريخ لليوم والوقت صار ماضي، صفري الوقت
      if (_pickedTimeLocal != null && _isSameDay(date, now)) {
        final pickedLocal = DateTime(
          now.year,
          now.month,
          now.day,
          _pickedTimeLocal!.hour,
          _pickedTimeLocal!.minute,
        );
        if (pickedLocal.isBefore(now)) {
          _pickedTimeLocal = null;
        }
      }

      _refreshDisplayStrings();
    }
  }

  void pickTime(BuildContext context) async {
    // نخليها مثل عندك: لازم تاريخ أولاً
    if (_pickedDateLocal == null) {
      Get.snackbar("تنبيه", "اختاري التاريخ أولاً");
      return;
    }

    final now = DateTime.now();
    final isToday = _isSameDay(_pickedDateLocal!, now);

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

  /// ================= Reset confirm =================
  void confirmReset() {
    Get.defaultDialog(
      title: "تأكيد",
      middleText: "هل تريد مسح جميع البيانات؟",
      textCancel: "إلغاء",
      textConfirm: "مسح",
      onConfirm: () {
        resetForm();
        Get.back();
      },
    );
  }

  /// ================= Send =================
  Future<void> sendNotification() async {
    if (isSending.value) return;

    if (subtypeId == null || descriptionController.text.trim().isEmpty) {
      Get.snackbar("خطأ", "الرجاء تعبئة البيانات");
      return;
    }

    final senderId = app.userId;
    if (senderId == null) {
      Get.snackbar("خطأ", "انتهت الجلسة، سجّل دخول مرة ثانية");
      return;
    }

    final utcEvent = buildUtcEventOrNull();
    if (utcEvent != null && utcEvent.containsKey("_invalid")) {
      Get.snackbar(
        "خطأ",
        "اختاري التاريخ والوقت معًا وبوقت غير ماضي، أو اتركيهما للإشعار الفوري",
      );
      return;
    }

    isSending.value = true;

    try {
      final crud = Get.find<Crud>();

      final Map<String, dynamic> body = {
        "sender_user_id": senderId.toString(),
        "target_role": "student",
        "subtype_id": subtypeId.toString(),
        "description": descriptionController.text.trim(),
        if (loginNumber != null) "login_number": loginNumber,
        if (gender != null) "gender": gender,
        if (programId != null) "program_id": programId.toString(),
        if (levelId != null) "level_id": levelId.toString(),
        if (subjectId != null) "subject_id": subjectId.toString(),
        if (groupId != null) "subject_group_id": groupId.toString(),
      };

      // ✅ لو مجدول فقط نرسل event_day/time
      if (utcEvent != null) {
        body.addAll(utcEvent);
      }

      final response = await crud.postData(Applink.sendNotification, body);

      response.fold(
        (_) => Get.snackbar("خطأ", "فشل الاتصال"),
        (r) {
          if (r['status'] == true) {
            final msg = r['message'] ?? "تم إرسال الإشعار";
            Get.snackbar("نجاح", msg);
            resetForm();
          } else {
            Get.snackbar("خطأ", r['message'] ?? "فشل الإرسال");
          }
        },
      );
    } finally {
      isSending.value = false;
    }
  }

  void resetForm() {
    programId = null;
    levelId = null;
    subjectId = null;
    groupId = null;
    loginNumber = null;
    subtypeId = null;

    genderIndex.value = 0;
    sendMode.value = SendMode.none;

    _pickedDateLocal = null;
    _pickedTimeLocal = null;
    _refreshDisplayStrings();

    descriptionController.clear();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadFacultySubjects();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
