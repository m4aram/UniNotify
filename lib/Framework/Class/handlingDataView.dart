import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:uninotify_project/Controller/LoginController.dart';
import 'package:uninotify_project/Framework/Class/statusrequest.dart';
import 'package:uninotify_project/Framework/Constant/imageAsset.dart';
import 'package:uninotify_project/Framework/Funcution/checkInternet.dart';

class Handlingdatarequest extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;

  const Handlingdatarequest({
    super.key,
    required this.statusRequest,
    required this.widget,
  });

  Future<void> _retryIfOnline() async {
    final hasInternet = await checkInternet();

    if (hasInternet) {
      final controller = Get.find<LoginController>();
      controller.statusRequest = StatusRequest.none;
      controller.update();
    } else {
      Get.snackbar(
        "No Internet",
        "Please check your connection",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (statusRequest == StatusRequest.loading) {
      return Center(
        child: Lottie.asset(
          AppImageAsset.loading,
          height: 200,
          width: 200,
        ),
      );
    }

    if (statusRequest == StatusRequest.offlineFailure) {
      return RefreshIndicator(
        onRefresh: _retryIfOnline,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.18),
            Center(
              child: Column(
                children: [
                  Lottie.asset(
                    AppImageAsset.offline,
                    height: 220,
                    width: 220,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Pull down to retry",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (statusRequest == StatusRequest.serverFailure) {
      return Center(
        child: Lottie.asset(
          AppImageAsset.server,
          height: 200,
          width: 200,
        ),
      );
    }

    return widget;
  }
}
