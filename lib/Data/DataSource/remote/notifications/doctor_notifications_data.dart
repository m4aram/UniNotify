import 'package:uninotify_project/Framework/Class/crud.dart';
import 'package:uninotify_project/liinkapi.dart';

class DoctorNotificationsData {
  Crud crud;
  DoctorNotificationsData(this.crud);

  getDoctorNotifications(int doctorUserId) async {
    return await crud.postData(
      Applink.getDoctorNotifications,
      {
        "doctor_id": doctorUserId.toString(),
      },
    );
  }
}
