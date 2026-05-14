import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Service/services.dart';

class LocalController extends GetxController {
  Locale? language;
  MyServices myService = Get.find();

  void changeLang(String langCode) {
    // 💾 حفظ اللغة
    myService.sharedPreferences.setString("lang", langCode);

    language = Locale(langCode);
    Get.updateLocale(language!);
    update();
  }

  @override
  void onInit() {
    String? sharedPrefLang =
    myService.sharedPreferences.getString("lang");

    if (sharedPrefLang != null) {
      language = Locale(sharedPrefLang);
    } else {
      language = Locale(Get.deviceLocale?.languageCode ?? "en");
    }

    Get.updateLocale(language!);
    super.onInit();
  }
}
