import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:uninotify_project/Controller/controllerstudent/StudentHomeController.dart';
import 'package:uninotify_project/Framework/Class/crud.dart';
import 'package:uninotify_project/Framework/Constant/appTheme.dart';
import 'package:uninotify_project/Framework/Localization/chanagelocal.dart';
import 'package:uninotify_project/Framework/Localization/translation.dart';
import 'package:uninotify_project/Framework/Service/services.dart';

import 'Controller/Administrator/adminController.dart';
import 'Controller/AppController.dart';
import 'Controller/theme_controller.dart';
import 'Controller/FacultiesMembersController/FacultiesMembersHome.dart';
import 'Framework/Constant/routes.dart';
import 'routes.dart';

// ✅ لازم عشان الإشعارات تشتغل في الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Firebase
  await Firebase.initializeApp();

  // ✅ استقبال الإشعارات في الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ طلب صلاحية الإشعارات
  await FirebaseMessaging.instance.requestPermission();

  // ✅ طباعة التوكن (مهم جدًا للاختبار)
  final token = await FirebaseMessaging.instance.getToken();
  print("✅ FCM TOKEN: $token");

  await initialServices(); // SharedPreferences + Language

  /// 🔐 فحص تسجيل الدخول
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool rememberMe = prefs.getBool("rememberMe") ?? false;
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  String? role = prefs.getString("role");

  /// 🧭 تحديد أول Route
  String initialRoute = AppRoute.LogoScreen;

  if (rememberMe && isLoggedIn && role != null) {
    if (role == "student") {
      initialRoute = AppRoute.StudentHomeScreen;
    } else if (role == "doctor") {
      initialRoute = AppRoute.FacultiesMembersHome;
    } else if (role == "admin") {
      initialRoute = AppRoute.AdminHome;
    }
  }

  Get.put(Crud());
  Get.put(AppController(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  Get.put(LocalController(), permanent: true);
  Get.put(FacultiesMembersController());
  Get.put(AdminController());
  Get.put(StudentHomeController());

  runApp(UniNotifyApp(initialRoute: initialRoute));
}

class UniNotifyApp extends StatelessWidget {
  final String initialRoute;

  const UniNotifyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localController = Get.find<LocalController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,

        // 🌐 اللغة
        locale: localController.language,
        translations: MyTranslation(),

        // 🎨 الثيم
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,

        // 🚀 Auto Login Route
        initialRoute: initialRoute,
        getPages: routes,
      ),
    );
  }
}
