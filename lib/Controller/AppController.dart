import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/dataSource/remote/init_data.dart';
import '../Framework/Class/crud.dart';

enum UserRole { student, faculty, admin }

class AppController extends GetxController {
  /// ================= Role =================
  final Rx<UserRole?> role = Rx<UserRole?>(null);

  /// ================= Session Data =================
  int? userId;
  String? name;
  String? academicId;

  /// ================= Lookup Data =================
  List colleges = []; // ✅ NEW (الكليات)
  List programs = [];
  List levels = [];
  List subjects = [];
  List subjectGroups = [];
  List students = [];
  List notificationSubtypes = [];
  List notificationCategories = [];

  /// ================= Relations =================
  /// student_id -> [subject_id]
  Map<int, List<int>> studentSubjects = {};

  /// student_id -> [subject_group_id]
  Map<int, List<int>> studentGroups = {};

  void setRole(UserRole newRole) {
    role.value = newRole;
    update();
  }

  bool get isStudent => role.value == UserRole.student;
  bool get isFaculty => role.value == UserRole.faculty;
  bool get isAdmin => role.value == UserRole.admin;

  /// ================= Lookup Init =================
  late InitData initData;

  @override
  void onInit() {
    super.onInit();
    initData = InitData(Get.find<Crud>());
    loadSession(); // تحميل بيانات الجلسة
    loadLookup(); // تحميل بيانات النظام
  }

  /// ================= Load Session =================
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt("user_id");
    name = prefs.getString("name");
    academicId = prefs.getString("academic_id");

    final roleStr = prefs.getString("role");
    if (roleStr == "student") role.value = UserRole.student;
    if (roleStr == "doctor") role.value = UserRole.faculty;
    if (roleStr == "admin") role.value = UserRole.admin;

    update();
  }

  /// ================= Load Lookup =================
  Future<void> loadLookup() async {
    var response = await initData.load();

    response.fold(
      (l) {
        print("❌ Failed to load lookup data");
      },
      (r) {
        print("✅ Lookup data loaded successfully");

        // ✅ NEW
        colleges = r['data']['colleges'] ?? [];

        programs = r['data']['programs'] ?? [];
        levels = r['data']['levels'] ?? [];
        subjects = r['data']['subjects'] ?? [];
        subjectGroups = r['data']['subject_groups'] ?? [];
        students = r['data']['students'] ?? [];
        notificationSubtypes = r['data']['notification_subtypes'] ?? [];
        notificationCategories = r['data']['notification_categories'] ?? [];

        /// ===== student_subjects =====
        studentSubjects.clear();
        for (var row in r['data']['student_subjects'] ?? []) {
          final int studentId = row['student_id'];
          final int subjectId = row['subject_id'];

          studentSubjects.putIfAbsent(studentId, () => []);
          studentSubjects[studentId]!.add(subjectId);
        }

        /// ===== student_groups =====
        studentGroups.clear();
        for (var row in r['data']['student_groups'] ?? []) {
          final int studentId = row['student_id'];
          final int groupId = row['subject_group_id'];

          studentGroups.putIfAbsent(studentId, () => []);
          studentGroups[studentId]!.add(groupId);
        }

        print("Colleges: ${colleges.length}");
        print("Programs: ${programs.length}");
        print("Students: ${students.length}");

        update();
      },
    );
  }
}
