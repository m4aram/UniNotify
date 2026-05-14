import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uninotify_project/Framework/Class/crud.dart';
import 'package:get/get.dart';
import 'package:uninotify_project/liinkapi.dart';

class FcmService {
  static Future<void> sendTokenToServer() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("user_id");

    if (userId == null) {
      print("❌ user_id not found, skip sending token");
      return;
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      print("❌ FCM token is null");
      return;
    }

    final body = {
      "user_id": userId.toString(),
      "token": token,
      "platform": Platform.isAndroid ? "android" : "ios",
    };

    print("🔗 SaveToken URL => ${Applink.saveToken}");
    print("📦 Body => $body");

    final crud = Get.find<Crud>();
    final response = await crud.postData(Applink.saveToken, body);

    response.fold(
      (l) => print("❌ Failed to send token (StatusRequest) => $l"),
      (r) => print("✅ Token saved successfully => $r"),
    
    );
  }
}
