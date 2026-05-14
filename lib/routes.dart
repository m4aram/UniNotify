import 'package:get/get.dart';

import 'Framework/Constant/routes.dart';
import 'Ui/Screens/Administrors/admin_feedback.dart';
import 'Ui/Screens/Administrors/admin_home.dart';
import 'Ui/Screens/Administrors/admin_report.dart';
import 'Ui/Screens/Administrors/admin_send_notifications_faculty.dart';
import 'Ui/Screens/Administrors/admin_send_notifications_students.dart';
import 'Ui/Screens/FacultiesMembers/home.dart';
import 'Ui/Screens/FacultiesMembers/sendNotifications.dart';
import 'Ui/Screens/FacultiesMembers/sendFeedback.dart';
import 'Ui/Screens/FacultiesMembers/receiveNotifications.dart';
import 'Ui/Screens/FacultiesMembers/uploadFile.dart';
import 'Ui/Screens/Students/home.dart';
import 'Ui/Screens/Students/receiveFile.dart';
import 'Ui/Screens/Students/receiveNotifications.dart';
import 'Ui/Screens/Students/sendFeedback.dart';
import 'Ui/Screens/login.dart';
import 'Ui/Screens/logo.dart';

List<GetPage<dynamic>> routes = [
  // ---------- Auth ----------
  GetPage(
      name: AppRoute.Login,
      page: () => Login()
  ),

  GetPage(
      name: AppRoute.LogoScreen,
      page: () => LogoScreen()
  ),

  // ---------- Students ----------
  GetPage(
      name: AppRoute.StudentHomeScreen,
      page: () => StudentHomeScreen()
  ),
  GetPage(
    name: AppRoute.StudentreceiveFile,
    page: () => const StudentreceiveFile(),
  ),
  GetPage(
    name: AppRoute.StudentReceiveNotifications,
    page: () => const StudentReceiveNotifications(),
  ),
  GetPage(
    name: AppRoute.FeedbackScreen,
    page: () => const FeedbackScreen(),
  ),
  GetPage(
    name: AppRoute.FacultiesMembersHome,
    page: () => const FacultiesMembersHome(),
  ),

  // ---------- Faculties ----------
  GetPage(
    name: AppRoute.SendNotificationsScreen,
    page: () => const SendNotificationsScreen(),
  ),
  GetPage(
    name: AppRoute.FacultiesMembersReceiveNotifications,
    page: () => const FacultiesMembersReceiveNotifications(),
  ),
  GetPage(
    name: AppRoute.FacultiesMembersFeedbackScreen,
    page: () => const FacultiesMembersFeedbackScreen(),
  ),
  GetPage(
    name: AppRoute.FacultiesMembersUploadFileScreen,
    page: () => const FacultiesMembersUploadFileScreen(),
  ),

  // ---------- Admin ----------
  GetPage(
    name: AppRoute.AdminHome,
    page: () => const AdminHome(),
  ),
  GetPage(
    name: AppRoute.AdminSendNotificationsFaculty,
    page: () => const AdminSendNotificationsFaculty(),
  ),
  GetPage(
    name: AppRoute.StudentSendNotificationsScreen,
    page: () => const StudentSendNotificationsScreen(),
  ),

  GetPage(
    name: AppRoute.AdminFeedback,
    page: () => const AdminFeedbackScreen(),
  ),
  GetPage(
    name: AppRoute.AdminReport,
    page: () => const AdminReportScreen(),
  ),

];
