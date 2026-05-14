// ignore_for_file: equal_keys_in_map

import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        // ====================== 🇺🇸 ENGLISH ======================
        'en': {
          // -------- App --------
          'app_name': 'UniNotify',
          'powered_by': 'Powered by',
          'ust': 'University of Science and Technology',

          // -------- Auth --------
          'login': 'Login',
          'academic_number': 'Academic Number',
          'password': 'Password',
          'remember_me': 'Remember me',
          'forgot_password': 'Forgot password?',
          'login_failed': 'Login Failed',
          'fill_all_fields': 'Please fill all fields',

          // -------- Common --------
          'home': 'Home',
          'file': 'File',
          'files': 'Files',
          'notifications': 'Notifications',
          'feedback': 'Feedback',
          'send': 'Send',
          'submit': 'Submit',
          'cancel': 'Cancel',
          'upload': 'Upload',
          'choose_file': 'Choose file',
          'download': 'Download',
          'date': 'Date',
          'time': 'Time',
          'day': 'Day',
          'name': 'Name',
          'description': 'Description',

          // -------- Drawer --------
          'settings': 'Settings',
          'theme': 'Theme',
          'language': 'Language',
          'logout': 'Log out',
          'filter': 'Filter',

          // -------- Student --------
          'student_home': 'Student Home',
          'receive_file': 'Receive File',
          'receive_notifications': 'Receive Notifications',
          'send_feedback': 'Send Feedback',
          'lecture': 'Lecture',
          'academic': 'Academic',

          // -------- Faculty --------
          'faculty_home': 'Faculty Home',
          'send_notifications': 'Send Notifications',
          'receive_notifications': 'receive Notifications',
          'upload_file': 'Upload File',
          'receive_feedback': 'Receive Feedback',

          // -------- Admin --------
          'admin_home': 'Admin Home',
          'report': 'Report',
          'generate_report': 'Generate Report',
          'send_notifications_faculty': 'Send Notifications (Faculty)',
          'send_notifications_students': 'Send Notifications (Students)',
          'receive_feedback_admin': 'Receive Feedback',

          // -------- Report --------
          'report_type': 'Report Type',
          'weekly': 'Weekly',
          'monthly': 'Monthly',
          'data_type': 'Data Type',
          'unfinished_lectures': 'Unfinished Lectures',
          'about_feedback': 'About Feedback',
          'sent_notifications': 'Sent Notifications',
          'report_display': 'Report Display',
          'as_pdf': 'As PDF',
          'as_excel': 'As Excel',

          // -------- NEW (Target) --------
          'target': 'Target',
          'students': 'Students',
          'doctors': 'Doctors',

          // -------- Notifications --------
          'select_notification_type': 'Select notification type',
          'describe_notification': 'Describe the notification',
          'select_program': 'program',
          'select_level': ' level',
          'select_group': ' group',
          'student_name': 'Student name',
          'collage': 'collage',

          // -------- Feedback --------
          'select_feedback_type': ' feedback type',
          'write_name': 'Write your name',
          'write_feedback': 'Write your feedback',
          'upload_image': 'Upload image',

          // -------- Files --------
          'select_course': 'Select course',
          'teaching_type': 'Teaching type',
          'file_type': 'File type',
          'lecture_file': 'Lecture',
          'assignment_file': 'Assignment',
          'exam_file': 'Exam',

          // -------- Messages --------
          'success': 'Success',
          'error': 'Error',
          'notification_sent': 'Notification sent successfully',
          'feedback_sent': 'Feedback sent successfully',
          'file_ready': 'File ready for upload',
          'select_at_least_one': 'Select at least one report type',

          'lecture_cancellation': 'Lecture cancellation:',
          'exam_data_change': 'Exam data change:',
          'payment_of_fees': 'Payment of fees:',
          'modify_lab': 'Modify the Lab:',

          // -------- Extra --------
          'subject': 'Subject',
          'girls': 'Girls',
          'boys': 'Boys',

          'sender': 'Sender',
          'message': 'Message',
          'delete': 'Delete',
          'reply': 'Reply',
          'like': 'Like',
        },

        // ====================== 🇸🇦 ARABIC ======================
        'ar': {
          // -------- App --------
          'app_name': 'يوني نوتفاي',
          'powered_by': 'مشغل بواسطة',
          'ust': 'جامعة العلوم والتكنولوجيا',

          // -------- Auth --------
          'login': 'تسجيل الدخول',
          'academic_number': 'الرقم الأكاديمي',
          'password': 'كلمة المرور',
          'remember_me': 'تذكرني',
          'forgot_password': 'نسيت كلمة المرور؟',
          'login_failed': 'فشل تسجيل الدخول',
          'fill_all_fields': 'الرجاء تعبئة جميع الحقول',

          // -------- Common --------
          'home': 'الرئيسية',
          'file': 'ملف',
          'files': 'الملفات',
          'notifications': 'الإشعارات',
          'feedback': 'الملاحظات',
          'send': 'إرسال',
          'submit': 'إرسال',
          'cancel': 'إلغاء',
          'upload': 'رفع',
          'choose_file': 'اختيار ملف',
          'download': 'تحميل',
          'date': 'التاريخ',
          'time': 'الوقت',
          'day': 'اليوم',
          'name': 'الاسم',
          'description': 'الوصف',

          // -------- Drawer --------
          'settings': 'الإعدادات',
          'theme': 'الوضع الليلي',
          'language': 'اللغة',
          'logout': 'تسجيل الخروج',
          'filter': 'فلترة',

          // -------- Student --------
          'student_home': ' الطالب',
          'receive_file': 'استقبال الملفات',
          'receive_notifications': 'استقبال الإشعارات',
          'send_feedback': 'إرسال ملاحظة',
          'lecture': 'محاضرة',
          'academic': 'أكاديمي',

          // -------- Faculty --------
          'faculty_home': ' عضو هيئة التدريس',
          'send_notifications': 'إرسال إشعارات',
          'receive_notifications': 'استقبال إشعارات',
          'upload_file': 'رفع ملف',
          'receive_feedback': 'استقبال الملاحظات',

          // -------- Admin --------
          'admin_home': 'واجهة الأدمن',
          'report': 'التقارير',
          'generate_report': 'إنشاء تقرير',
          'send_notifications_faculty': 'إرسال إشعارات (الدكاترة)',
          'send_notifications_students': 'إرسال إشعارات (الطلاب)',
          'receive_feedback_admin': 'استقبال الملاحظات',

          // -------- Report --------
          'report_type': 'نوع التقرير',
          'weekly': 'أسبوعي',
          'monthly': 'شهري',
          'data_type': 'نوع البيانات',
          'unfinished_lectures': 'محاضرات غير مكتملة',
          'about_feedback': 'عن الملاحظات',
          'sent_notifications': 'الإشعارات المرسلة',
          'report_display': 'عرض التقرير',
          'as_pdf': 'كملف PDF',
          'as_excel': 'كملف Excel',

          // -------- NEW (Target) --------
          'target': 'الجهة المستهدفة',
          'students': 'الطلاب',
          'doctors': 'الدكاترة',

          // -------- Notifications --------
          'select_notification_type': 'اختر نوع الإشعار',
          'describe_notification': 'وصف الإشعار',
          'select_program': ' التخصص',
          'select_level': ' المستوى',
          'select_group': ' المجموعة',
          'student_name': 'اسم الطالب',
          'collage': 'الكليه',

          // -------- Feedback --------
          'select_feedback_type': 'اختر نوع الملاحظة',
          'write_name': 'اكتب اسمك',
          'write_feedback': 'اكتب ملاحظتك',
          'upload_image': 'رفع صورة',

          // -------- Files --------
          'select_course': 'اختر المقرر',
          'teaching_type': 'نوع التدريس',
          'file_type': 'نوع الملف',
          'lecture_file': 'محاضرة',
          'assignment_file': 'واجب',
          'exam_file': 'اختبار',

          // -------- Messages --------
          'success': 'تم بنجاح',
          'error': 'خطأ',
          'notification_sent': 'تم إرسال الإشعار بنجاح',
          'feedback_sent': 'تم إرسال الملاحظة بنجاح',
          'file_ready': 'الملف جاهز للرفع',
          'select_at_least_one': 'اختر نوع تقرير واحد على الأقل',

          'lecture_cancellation': 'إلغاء محاضرة:',
          'exam_data_change': 'تعديل موعد الاختبار:',
          'payment_of_fees': 'سداد الرسوم:',
          'modify_lab': 'تعديل المعمل:',

          // -------- Extra --------
          'subject': 'المادة',
          'girls': 'طالبات',
          'boys': 'طلاب',

          'sender': 'المرسل',
          'message': 'الرسالة',
          'delete': 'حذف',
          'reply': 'رد',
          'like': 'إعجاب',
        },
      };
}
