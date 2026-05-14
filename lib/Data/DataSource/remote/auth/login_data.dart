import 'package:uninotify_project/liinkapi.dart';
import '../../../../Framework/Class/crud.dart';

class LoginData {
  Crud crud;
  LoginData(this.crud);

  postData(String loginNumber, String password) async {
    var response = await crud.postData(
      Applink.login,
      {
        "login_number": loginNumber,
        "password": password,
      },
    );
    return response;
  }
}
