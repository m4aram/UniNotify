import 'package:flutter/material.dart';

class Customlist extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String> onChanged; // ✅ هذا المهم
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final TextStyle? labelStyle;

  // ✅ إضافات اختيارية (ما تأثر على بقية الواجهات إذا ما استخدمتها)
  final bool isExpanded; // عشان يمنع overflow
  final int maxLines; // عدد السطور للنص
  final TextOverflow overflow; // ellipsis
  final bool useSelectedBuilder; // يقص النص داخل الحقل بعد الاختيار
  final int menuMaxLines;
  final TextOverflow menuOverflow;
  final String Function(String item)? itemBuilder;

  const Customlist({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.contentPadding,
    this.borderRadius = 10,
    this.labelStyle,

    // ✅ Defaults آمنة (تقدر تغيرها في أي شاشة)
    this.isExpanded = true,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.useSelectedBuilder = true,
    this.menuMaxLines = 2,
    this.menuOverflow = TextOverflow.ellipsis,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: isExpanded, // ✅ يمنع overflow

      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        contentPadding:
        contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),

      value: value,

      // ✅ نص عناصر القائمة (Dropdown Menu)
      items: items.map((item) {
        final display = itemBuilder != null ? itemBuilder!(item) : item;

        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            display,
            maxLines: menuMaxLines,
            overflow: menuOverflow,
          ),
        );
      }).toList(),

      // ✅ نص العنصر المختار داخل الحقل (Selected)
      selectedItemBuilder: useSelectedBuilder
          ? (context) => items.map((item) {
        final display = itemBuilder != null ? itemBuilder!(item) : item;
        return Text(
          display,
          maxLines: maxLines,
          overflow: overflow,
        );
      }).toList()
          : null,

      onChanged: (v) {
        if (v != null) {
          onChanged(v); // ✅ هنا الاستدعاء
        }
      },
    );
  }
}
