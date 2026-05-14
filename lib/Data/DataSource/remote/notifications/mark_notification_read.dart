import 'package:uninotify_project/Framework/Class/crud.dart';
import 'package:uninotify_project/liinkapi.dart';

class MarkNotificationReadData {
  Crud crud;
  MarkNotificationReadData(this.crud);

  markRead({
    required int notificationId,
    required int studentId,
  }) async {
    return await crud.postData(
      Applink.markNotificationAsRead,
      {
        "notification_id": notificationId.toString(),
        "student_id": studentId.toString(),
      },
    );
  }
}
