import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final int maxLines;

  /// 🔹 خاص بالصورة
  final IconData? bottomIcon;
  final String? bottomText;
  final VoidCallback? onBottomTap;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.maxLines = 1,
    this.bottomIcon,
    this.bottomText,
    this.onBottomTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool showBottom =
        bottomIcon != null && bottomText != null && onBottomTap != null;

    return Stack(
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            /// ⬅️ نترك مساحة تحت إذا فيه زر
            contentPadding: EdgeInsets.fromLTRB(
              12,
              14,
              12,
              showBottom ? 48 : 14,
            ),
          ),
        ),

        /// 🔵 Upload image داخل الحقل
        if (showBottom)
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: onBottomTap,
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  Icon(
                    bottomIcon,
                    size: 18,
                    color: const Color(0xFF6EA1EA),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    bottomText!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6EA1EA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
