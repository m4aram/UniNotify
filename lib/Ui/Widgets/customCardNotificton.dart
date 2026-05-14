import 'package:flutter/material.dart';

class CustomCardNotificton extends StatelessWidget {
  final String title;
  final String description; // ✅ جديد
  final String doctor;
  final String dateTime;
  final String receivedTime;

  const CustomCardNotificton({
    super.key,
    required this.title,
    required this.description,
    required this.doctor,
    required this.dateTime,
    required this.receivedTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title + Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Text(
                receivedTime,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 Description (⭐ المهم)
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 6),

          /// 🔹 Sender
          Text(
            doctor,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          /// 🔹 Date & Time
          Text(
            dateTime,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
