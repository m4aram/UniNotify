import 'package:uninotify_project/Framework/Class/crud.dart';
import 'package:uninotify_project/liinkapi.dart';

class StudentNotificationsData {
  Crud crud;
  StudentNotificationsData(this.crud);

  getStudentNotifications(int studentId) async {
    var response = await crud.postData(
      "${Applink.getStudentNotifications}?student_id=$studentId",
      {},
    );
    return response;
  }
}
