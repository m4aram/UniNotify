import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uninotify_project/Framework/Constant/routes.dart';

import '../../Controller/theme_controller.dart';
import '../../Framework/Localization/chanagelocal.dart'; // ✅ إضافة فقط

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localController = Get.find<LocalController>(); // ✅ إضافة فقط
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.primary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 العنوان
              Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "settings".tr,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// 🔹 Theme (بدون أي تعديل)
              Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.brightness_6,
                    color: theme.colorScheme.onPrimary,
                  ),
                  title: Text(
                    "theme".tr,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  trailing: Switch(
                    value: themeController.isDark.value,
                    onChanged: (_) => themeController.toggleTheme(),
                    activeColor: theme.colorScheme.onPrimary,
                    inactiveThumbColor:
                        theme.colorScheme.onPrimary.withOpacity(0.7),
                  ),
                  onTap: themeController.toggleTheme,
                ),
              ),


              const SizedBox(height: 20),

              /// 🔹 Language
              Text(
                "language".tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  _langButton(
                    context: context,
                    text: "EN",
                    onTap: () {
                      localController.changeLang("en"); // ✅ صح
                    },
                  ),
                  const SizedBox(width: 8),
                  _langButton(
                    context: context,
                    text: "AR",
                    onTap: () {
                      localController.changeLang("ar"); // ✅ صح
                    },
                  ),
                ],
              ),

              const Spacer(),

              /// 🔹 Logout
              _drawerItem(
                context: context,
                icon: Icons.logout,
                title: "logout".tr,
                onTap: () {
                  Get.offAllNamed(AppRoute.Login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: theme.colorScheme.onPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _langButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
