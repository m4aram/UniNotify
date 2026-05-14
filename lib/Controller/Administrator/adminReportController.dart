import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

import '../../Framework/Class/statusrequest.dart';
import '../../Data/DataSource/remote/reports/sent_notifications_remote.dart';
import '../../Data/Model/SentNotificationModel.dart';
import '../../Data/Model/unfinished_lecture_model.dart';
import '../../Reports/cancelled_lectures_report.dart';
import '../../Reports/sent_notifications_report.dart';
import '../../Data/DataSource/remote/reports/unfinished_lectures_remote.dart';
import '../AppController.dart';
import '../../Framework/Service/report_pdf_service.dart';

enum SentTarget { students, doctors }

class AdminReportController extends GetxController {
  final AppController appController = Get.find<AppController>();

  bool _isGenerating = false;

  StatusRequest statusRequest = StatusRequest.none;

  void _setStatus(StatusRequest s) {
    statusRequest = s;
    update();
  }

  void resetReportState() {
    _isGenerating = false;
    statusRequest = StatusRequest.none;
    update();
  }

  Future<void> resetForm() async {
    reportType = "Weekly";

    programName = null;
    programId = null;

    levelName = null;
    levelId = null;

    groupLabel = null;
    groupId = null;

    dateFrom = null;
    dateTo = null;

    unfinishedLectures = false;
    aboutFeedback = false;
    sentNotifications = false;

    sentTarget = SentTarget.students;

    _isGenerating = false;
    statusRequest = StatusRequest.none;

    update();
  }

  // ===== Report Type =====
  String reportType = "Weekly";
  List<String> reportTypes = ["Weekly", "Monthly"];

  // ===== Program =====
  String? programName;
  int? programId;

  List<String> get programNames =>
      appController.programs.map((e) => e['name'].toString()).toList();

  void changeProgramByName(String v) {
    programName = v;
    programId =
    appController.programs.firstWhere((e) => e['name'] == v)['program_id'];

    levelName = null;
    levelId = null;
    groupLabel = null;
    groupId = null;

    resetReportState();
  }

  // ===== Level =====
  String? levelName;
  int? levelId;

  List<Map<String, dynamic>> get filteredLevels {
    if (programId == null) return [];

    final Set<int> levelIds = appController.subjects
        .where((s) => int.parse(s['program_id'].toString()) == programId)
        .map<int>((s) => int.parse(s['level_id'].toString()))
        .toSet();

    return appController.levels.where((l) {
      final name = (l['name'] ?? '').toString().trim();
      final idFromName = _levelIdFromArabicName(name);
      return idFromName != null && levelIds.contains(idFromName);
    }).cast<Map<String, dynamic>>().toList();
  }

  int? _levelIdFromArabicName(String name) {
    switch (name) {
      case 'الأول':
        return 1;
      case 'الثاني':
        return 2;
      case 'الثالث':
        return 3;
      case 'الرابع':
        return 4;
      default:
        return null;
    }
  }

  List<String> get levelNames =>
      filteredLevels.map((e) => e['name'].toString()).toList();

  void changeLevelByName(String v) {
    levelName = v;
    levelId = filteredLevels.firstWhere((e) => e['name'] == v)['level_id'];

    groupLabel = null;
    groupId = null;

    resetReportState();
  }

  // ===== Group =====
  int? groupId;
  String? groupLabel;

  List<Map<String, dynamic>> get filteredGroupOptions {
    if (programId == null || levelId == null) return [];

    final subjectIds = appController.subjects
        .where((s) => s['program_id'] == programId && s['level_id'] == levelId)
        .map((s) => s['subject_id'])
        .toSet();

    final groups = appController.subjectGroups
        .where((g) => subjectIds.contains(g['subject_id']))
        .toList();

    return groups.map((g) {
      final subjectName = appController.subjects
          .firstWhere((s) => s['subject_id'] == g['subject_id'])['name']
          .toString();

      return {
        "id": g["subject_group_id"],
        "label": "$subjectName - ${g["name"]}",
      };
    }).toList();
  }

  List<String> get groupLabels =>
      filteredGroupOptions.map((e) => e["label"].toString()).toList();

  void changeGroupByLabel(String label) {
    final found = filteredGroupOptions.firstWhere((e) => e["label"] == label);
    groupLabel = label;
    groupId = found["id"];

    resetReportState();
  }

  // ===== Date =====
  DateTime? dateFrom;
  DateTime? dateTo;

  String get dateRangeLabel {
    if (dateFrom == null || dateTo == null) {
      return reportType == "Weekly" ? "Select-week" : "Select-month";
    }
    return "${DateFormat('yyyy-MM-dd').format(dateFrom!)} → "
        "${DateFormat('yyyy-MM-dd').format(dateTo!)}";
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked == null) return;

    if (reportType == "Weekly") {
      dateFrom = picked;
      dateTo = picked.add(const Duration(days: 6));
    } else {
      dateFrom = picked;
      dateTo = DateTime(picked.year, picked.month + 1, 0);
    }


    resetReportState();
  }

  void changeReportType(String v) {
    reportType = v;
    dateFrom = null;
    dateTo = null;
    resetReportState();
  }

  // ===== Data Types =====
  bool unfinishedLectures = false;
  bool aboutFeedback = false;
  bool sentNotifications = false;

  void toggleUnfinished(bool v) {
    unfinishedLectures = v;
    resetReportState();
  }

  void toggleFeedback(bool v) {
    aboutFeedback = v;
    resetReportState();
  }

  void toggleSentNotifications(bool v) {
    sentNotifications = v;
    resetReportState();
  }

  // ✅ Sent notifications target
  SentTarget sentTarget = SentTarget.students;

  void setSentTarget(SentTarget v) {
    sentTarget = v;

    // لما تختار doctors خلّ الفلاتر فاضية
    if (sentTarget == SentTarget.doctors) {
      programName = null;
      programId = null;
      levelName = null;
      levelId = null;
      groupLabel = null;
      groupId = null;
    }

    resetReportState();
  }

  // ===== Helpers =====
  String _printDateOnly(String printDatetime) {
    if (printDatetime.isEmpty) return "-";
    return (printDatetime.length >= 10)
        ? printDatetime.substring(0, 10)
        : printDatetime;
  }

  String _getGroupOnlyName() {
    if (groupId == null) return "-";
    for (final g in appController.subjectGroups) {
      if (g['subject_group_id'] == groupId) {
        return g['name']?.toString() ?? "-";
      }
    }
    return "-";
  }

  bool get _isSentDoctors =>
      sentNotifications && sentTarget == SentTarget.doctors;

  bool get _isSentStudents =>
      sentNotifications && sentTarget == SentTarget.students;

  // ===== Generate Report =====
  Future<void> generateReport() async {
    if (_isGenerating) return;
    _isGenerating = true;

    _setStatus(StatusRequest.loading);

    try {
      if (!unfinishedLectures && !aboutFeedback && !sentNotifications) {
        Get.snackbar("تنبيه", "اختر نوع تقرير واحد على الأقل");
        _setStatus(StatusRequest.none);
        return;
      }

      // ✅ Unfinished lectures يحتاج program + level دائماً
      if (unfinishedLectures) {
        if (programId == null || levelId == null) {
          Get.snackbar("تنبيه", "يرجى اختيار التخصص والمستوى");
          _setStatus(StatusRequest.none);
          return;
        }
      }

      if (dateFrom == null || dateTo == null) {
        Get.snackbar("تنبيه", "يرجى اختيار الفترة");
        _setStatus(StatusRequest.none);
        return;
      }

      final from = DateFormat('yyyy-MM-dd').format(dateFrom!);
      final to = DateFormat('yyyy-MM-dd').format(dateTo!);

      // ===== Unfinished Lectures =====
      if (unfinishedLectures) {
        await _generateUnfinishedLectures(from: from, to: to);
      }

      // ===== Sent Notifications =====
      if (sentNotifications) {
        await _generateSentNotifications(from: from, to: to);
      }

      _setStatus(StatusRequest.success);
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
      _setStatus(StatusRequest.serverFailure);
    } finally {
      _isGenerating = false;
      _setStatus(StatusRequest.none);
    }
  }

  // =========================
  // ✅ Unfinished Lectures (مفصول)
  // =========================
  Future<void> _generateUnfinishedLectures({
    required String from,
    required String to,
  }) async {
    final Map<String, dynamic> response =
    await UnfinishedLecturesRemote().getReport({
      "date_from": from,
      "date_to": to,
      "program_id": programId,
      "level_id": levelId,
      if (groupId != null) "group_id": groupId,
    });

    if (response['status'] != true) {
      Get.snackbar("خطأ", response['message']?.toString() ?? "فشل تحميل التقرير");
      _setStatus(StatusRequest.failure);
      return;
    }

    final dataObj = response['data'];
    if (dataObj is! Map) {
      Get.snackbar("خطأ", "شكل data غلط");
      _setStatus(StatusRequest.failure);
      return;
    }

    final dataMap = Map<String, dynamic>.from(dataObj);
    final String ref = dataMap['ref']?.toString() ?? "-";
    final String printDatetime = dataMap['print_datetime']?.toString() ?? "-";
    final String printDateOnly = _printDateOnly(printDatetime);

    final rowsObj = dataMap['rows'];
    final List rows = (rowsObj is List) ? rowsObj : [];

    if (rows.isEmpty) {
      Get.snackbar("تنبيه", "لا توجد بيانات في هذه الفترة");
      _setStatus(StatusRequest.none);
      return;
    }

    final lectures = rows.map((e) {
      return UnfinishedLecture.fromJson(Map<String, dynamic>.from(e as Map));
    }).toList();

    final String groupOnlyName = _getGroupOnlyName();

    await ReportPdfBase.generate(
      title: 'تقرير المحاضرات الملغاة',
      headerInfo: {
        "ref": ref,
        "print_datetime": printDateOnly,
        "print_date_ar": printDateOnly,
        "specialization": "التخصص: ${programName ?? "-"}",
        "level": "المستوى: ${levelName ?? "-"}",
        "group": "المجموعة: $groupOnlyName",
        "date_from": from,
        "date_to": to,
        "sig_right": "المختص",
        "sig_mid": "رئيس القسم",
        "sig_left": "عميد الكلية",
      },
      bodyBuilder: (font, bold) {
        return [
          ...CancelledLecturesPdfWidgets.buildTable(
            lectures: lectures,
            font: font,
            bold: bold,
            dateFrom: dateFrom!,
            dateTo: dateTo!,
          ),
        ];
      },
      onSave: (Uint8List bytes) async {
        await ReportPdfBase.saveAndOpenPdf(bytes, 'cancelled_lectures_$ref.pdf');
      },
    );
  }

  // =========================
  // ✅ Sent Notifications (مفصول)
  // =========================
  Future<void> _generateSentNotifications({
    required String from,
    required String to,
  }) async {
    final bool isDoctors = (sentTarget == SentTarget.doctors);

    final Map<String, dynamic> payload = {
      "date_from": from,
      "date_to": to,
      "target": isDoctors ? "doctors" : "students",
    };

    // ✅ فلترة الطلاب اختيارية
    if (!isDoctors) {
      if (programId != null) payload["program_id"] = programId;
      if (levelId != null) payload["level_id"] = levelId;
      if (groupId != null) payload["group_id"] = groupId;
    }

    final Map<String, dynamic> response =
    await SentNotificationsRemote().getReport(payload);

    if (response['status'] != true) {
      Get.snackbar("خطأ", response['message']?.toString() ?? "فشل تحميل التقرير");
      _setStatus(StatusRequest.failure);
      return;
    }

    final dataObj = response['data'];
    if (dataObj is! Map) {
      Get.snackbar("خطأ", "شكل data غلط");
      _setStatus(StatusRequest.failure);
      return;
    }

    final dataMap = Map<String, dynamic>.from(dataObj);
    final String ref = dataMap['ref']?.toString() ?? "-";
    final String printDatetime = dataMap['print_datetime']?.toString() ?? "-";
    final String printDateOnly = _printDateOnly(printDatetime);

    final rowsObj = dataMap['rows'];
    final List rows = (rowsObj is List) ? rowsObj : [];

    if (rows.isEmpty) {
      Get.snackbar("تنبيه", "لا توجد بيانات في هذه الفترة");
      _setStatus(StatusRequest.none);
      return;
    }

    final notifications = rows.map((e) {
      return SentNotification.fromJson(Map<String, dynamic>.from(e as Map));
    }).toList();

    final String groupOnlyName = _getGroupOnlyName();

    final String headerProgram =
    isDoctors ? "التخصص: -" : "التخصص: ${programName ?? "-"}";
    final String headerLevel =
    isDoctors ? "المستوى: -" : "المستوى: ${levelName ?? "-"}";
    final String headerGroup =
    isDoctors ? "المجموعة: -" : "المجموعة: $groupOnlyName";

    await ReportPdfBase.generate(
      title: isDoctors
          ? 'تقرير الإشعارات المرسلة للدكاترة'
          : 'تقرير الإشعارات المرسلة للطلاب',
      headerInfo: {
        "ref": ref,
        "print_datetime": printDateOnly,
        "print_date_ar": printDateOnly,
        "specialization": headerProgram,
        "level": headerLevel,
        "group": headerGroup,
        "date_from": from,
        "date_to": to,
        "sig_right": "المختص",
        "sig_mid": "رئيس القسم",
        "sig_left": "عميد الكلية",
      },
      bodyBuilder: (font, bold) {
        return [
          ...SentNotificationsPdfWidgets.buildTable(
            rows: notifications,
            font: font,
            bold: bold,
          ),
        ];
      },
      onSave: (Uint8List bytes) async {
        await ReportPdfBase.saveAndOpenPdf(bytes, 'sent_notifications_$ref.pdf');
      },
    );
  }
}
