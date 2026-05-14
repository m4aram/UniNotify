import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uninotify_project/Framework/Class/handlingDataView.dart';

import '../../Controller/LoginController.dart';
import '../Widgets/customLogo.dart';
import '../Widgets/customTextFormLogo.dart';
import '../Widgets/customCheckBox.dart';
import '../Widgets/customBotton.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GetBuilder<LoginController>(
        init: LoginController(), // ✅ الصحيح
        builder: (controller) {
          return Handlingdatarequest(
            statusRequest: controller.statusRequest,
            widget: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),

                  SizedBox(
                    height: 220,
                    child: const Center(child: CustomLogo()),
                  ),

                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        CustomTextFormLogo(
                          labeltext: "academic_number".tr,
                          iconData: Icons.person_outline,
                          controller: controller.academicNumber,
                        ),

                        const SizedBox(height: 20),

                        Obx(
                              () => CustomTextFormLogo(
                            labeltext: "password".tr,
                            iconData: Icons.lock_outline,
                            controller: controller.password,
                            obscureText: controller.isShowPassword.value,
                            onTapIcon: controller.togglePassword,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Obx(
                                  () => CustomCheckBox(
                                value: controller.rememberMe.value,
                                title: "remember_me".tr,
                                onChanged: controller.toggleRemember,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed:
                              controller.showForgotPasswordMessage,
                              child: Text("forgot_password".tr),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        CustomButton(
                          title: "login".tr,
                          height: 50,
                          borderRadius: 25,
                          onTap: controller.login,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
