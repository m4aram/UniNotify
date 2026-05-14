class Applink {
  static const String server =
      "https://dodgerblue-octopus-842943.hostingersite.com/university_backend";

  /// ================= Auth =================
  static const String test = "$server/test.php";
  static const String login = "$server/auth/login.php";

  /// ================= Notifications =================

  /// إرسال إشعار (Admin / Doctor)
  static const String sendNotification = "$server/notifications/send.php";

  /// استقبال إشعارات الدكاترة
  static const String getDoctorNotifications =
      "$server/notifications/get_doctor.php";

  /// استقبال إشعارات الطلاب
  static const String getStudentNotifications =
      "$server/notifications/get_student.php";

  /// أنواع الإشعارات
  static const String getNotificationSubtypes =
      "$server/notifications/get_subtypes.php";

  /// تعليم الإشعار كمقروء
  static const String markNotificationAsRead =
      "$server/notifications/mark_read.php";

  /// ================= Feedback =================

  /// جلب الملاحظات
  static const String getFeedback = "$server/feedback/get.php";

  /// إرسال ملاحظة
  static const String sendFeedback = "$server/feedback/send.php";

  /// ================= Lookup / Init =================
  static const String initLookup = "$server/lookup/init.php";

  /// ================= Subjects =================

  /// مواد الدكتور (Dropdown الرفع)
  static const String getFacultySubjects = "$server/subject/get_faculty.php";

  /// مواد الطالب
  static const String getStudentSubjects =
      "$server/subject/get_for_student.php";

  /// ================= Lectures / Files =================

  /// رفع ملف (دكتور)
  static const String uploadLecture = "$server/lectures/upload.php";

  /// جلب ملفات الطالب
  static const String getStudentLectures = "$server/lectures/get_student.php";

  /// جلب كل الملفات (Admin / اختياري)
  static const String getAllLectures = "$server/lectures/get.php";

  /// ================= Registration Panel =================
  /// صفحة التحكم بتسجيل المواد (Web)
  static const String registrationPanel = "$server/registration/panel.php";

  /// ================= Reports =================

  static const String unfinishedLecturesReport =
      "$server/reports/unfinished_lectures.php";

  static const String sentNotificationsReport =
      "$server/reports/sent_notifications_report.php";

  /// ================= Firebase =================

static const String saveToken = "$server/notifications/save_token.php";
}
