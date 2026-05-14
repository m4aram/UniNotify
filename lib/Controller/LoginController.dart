import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uninotify_project/Controller/AppController.dart';
import 'package:uninotify_project/Framework/Service/fcm_service.dart';
import '../../Data/dataSource/remote/auth/login_data.dart';
import '../../Framework/Class/statusrequest.dart';
import '../../Framework/Constant/routes.dart';

class LoginController extends GetxController {
  late TextEditingController academicNumber;
  late TextEditingController password;

  LoginData loginData = LoginData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;

  RxBool isShowPassword = true.obs;
  RxBool rememberMe = false.obs;

  // ================== ✅ Login Lock (3 attempts) ==================
  int failedAttempts = 0;
  DateTime? lockUntil;

  static const int maxAttempts = 3;
  static const Duration lockDuration = Duration(seconds: 30);

  bool get isLocked {
    if (lockUntil == null) return false;
    return DateTime.now().isBefore(lockUntil!);
  }

  int get remainingLockSeconds {
    if (lockUntil == null) return 0;
    return lockUntil!
        .difference(DateTime.now())
        .inSeconds
        .clamp(0, lockDuration.inSeconds);
  }
  // ================================================================

  @override
  void onInit() {
    academicNumber = TextEditingController();
    password = TextEditingController();
    _loadRememberMe();
    super.onInit();
  }

  /// تحميل حالة Remember Me
  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    rememberMe.value = prefs.getBool("rememberMe") ?? false;
  }

  void togglePassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  void toggleRemember(bool? value) async {
    rememberMe.value = value ?? false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("rememberMe", rememberMe.value);
  }

  /// 🔐 Login
  Future<void> login() async {
    // ✅ إذا مقفل مؤقتًا
    if (isLocked) {
      Get.snackbar(
        "محاولة مرفوضة",
        "تم إيقاف تسجيل الدخول مؤقتًا\nحاولي بعد $remainingLockSeconds ثانية",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (academicNumber.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى تعبئة جميع الحقول");
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    final response = await loginData.postData(
      academicNumber.text,
      password.text,
    );

    response.fold(
      (status) {
        statusRequest = status;
        update();
      },
      (data) async {
        // ✅ فشل تسجيل الدخول
        if (data['status'] != true) {
          failedAttempts++;

          if (failedAttempts >= maxAttempts) {
            lockUntil = DateTime.now().add(lockDuration);

            Get.snackbar(
              "تم الإيقاف",
              "تم إدخال بيانات خاطئة $maxAttempts مرات\nيرجى الانتظار ${lockDuration.inSeconds} ثانية",
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              "خطأ",
              "بيانات الدخول غير صحيحة\nمحاولة $failedAttempts/$maxAttempts",
              snackPosition: SnackPosition.BOTTOM,
            );
          }

          statusRequest = StatusRequest.failure;
          update();
          return;
        }

        // ✅ نجاح تسجيل الدخول: صفّر المحاولات
        failedAttempts = 0;
        lockUntil = null;

        statusRequest = StatusRequest.success;

        final prefs = await SharedPreferences.getInstance();
        final String role = data['data']['role'];

        /// ✅ Remember Me
        if (rememberMe.value) {
          await prefs.setBool("isLoggedIn", true);
        }

        /// 🔑 بيانات أساسية (مهمة لكل النظام)
        await prefs.setInt("user_id", data['data']['user_id']);
        await prefs.setString("role", role);
        await prefs.setString("name", data['data']['name'] ?? "");

        try {
          await FcmService.sendTokenToServer();
        } catch (e) {
          // ignore: avoid_print
          print("⚠️ sendTokenToServer error: $e");
        }

        /// ✅ الرقم الأكاديمي (طالب / دكتور)
        await prefs.setString(
          "academic_id",
          data['data']['login_number'].toString(),
        );

        /// 👩‍🎓 بيانات الطالب فقط
        if (role == "student") {
          await prefs.setInt("student_id", data['data']['student_id']);
          await prefs.setString("gender", data['data']['gender']);
          await prefs.setInt("program_id", data['data']['program_id']);
          await prefs.setInt("level_id", data['data']['level_id']);
        }

        /// ✅ تحميل بيانات الجلسة داخل AppController (مهم جداً)
        final app = Get.find<AppController>();
        await app.loadSession();

        /// 🔍 طباعة للتأكد (اختبار فقط)
        debugPrint("LOGIN SUCCESS");
        debugPrint("ROLE => ${prefs.getString("role")}");
        debugPrint("ACADEMIC_ID => ${prefs.getString("academic_id")}");
        debugPrint("NAME => ${prefs.getString("name")}");
        debugPrint("USER_ID => ${prefs.getInt("user_id")}");

        /// 🚀 التوجيه حسب الدور
        if (role == "student") {
          Get.offAllNamed(AppRoute.StudentHomeScreen);
        } else if (role == "doctor") {
          Get.offAllNamed(AppRoute.FacultiesMembersHome);
        } else if (role == "admin") {
          Get.offAllNamed(AppRoute.AdminHome);
        }

        update();
      },
    );
  }

  /// 🔓 Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(AppRoute.Login);
  }

  void showForgotPasswordMessage() {
    Get.snackbar(
      "نسيت كلمة المرور",
      "يرجى التواصل مع الإدارة",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void dispose() {
    academicNumber.dispose();
    password.dispose();
    super.dispose();
  }
}
