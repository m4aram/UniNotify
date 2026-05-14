import 'package:flutter/material.dart';

class CustomToggleBar extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;

  const CustomToggleBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double totalWidth =
        width ?? MediaQuery.of(context).size.width - 32;

    final double barHeight = height ?? 42;
    final double radius = borderRadius ?? 14;
    final double textSize = fontSize ?? 14;

    final double itemWidth = totalWidth / items.length;
    final bool single = items.length == 1;

    return Container(
      width: totalWidth,
      height: barHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Stack(
        children: [
          /// 🔹 المؤشر (يدعم RTL تلقائيًا)
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            start: single ? 0 : itemWidth * selectedIndex, // ✅ بدل left
            top: 0,
            bottom: 0,
            child: Container(
              width: single ? totalWidth : itemWidth,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),

          /// 🔹 النصوص (خليها مثل ما هي)
          Row(
            children: List.generate(items.length, (index) {
              final bool isSelected = selectedIndex == index;

              return SizedBox(
                width: itemWidth,
                child: InkWell(
                  onTap: () => onChanged(index), // ✅ بدون قلب
                  borderRadius: BorderRadius.circular(radius),
                  child: Center(
                    child: Text(
                      items[index],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: textSize,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
