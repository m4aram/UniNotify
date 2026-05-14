import 'package:flutter/material.dart';

class CustomTextFormLogo extends StatelessWidget {
  final String labeltext;
  final IconData iconData;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onTapIcon;

  const CustomTextFormLogo({
    super.key,
    required this.labeltext,
    required this.iconData,
    required this.controller,
    this.obscureText = false,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labeltext,
        prefixIcon: Icon(iconData),
        suffixIcon: onTapIcon != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onTapIcon,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
