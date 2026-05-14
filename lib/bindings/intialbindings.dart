import 'package:get/get.dart';

import '../Framework/Class/crud.dart';

class Intialbindings extends Bindings {
  @override
  void dependencies(){
    Get.put(Crud());
  }
}