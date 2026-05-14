import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class CustomUploadFile extends StatelessWidget {
  final String title;
  final String description;
  final String doctor;
  final DateTime createdAt;

  final VoidCallback? onDownload;
  final VoidCallback? onCancel;

  CustomUploadFile({
    super.key,
    required this.title,
    required this.description,
    required this.doctor,
    DateTime? createdAt,
    this.onDownload,
    this.onCancel,
  }) : createdAt = createdAt ?? DateTime.now();

  String get formattedTime {
    return DateFormat('hh:mm a').format(createdAt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 العنوان + الوقت
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                formattedTime,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            description,
            style: theme.textTheme.bodyMedium,
          ),

          const SizedBox(height: 6),

          Text(
            doctor,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onDownload != null)
                InkWell(
                  onTap: onDownload,
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_download,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "download".tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 20),
              if (onCancel != null)
                InkWell(
                  onTap: onCancel,
                  child: Text(
                    "cancel".tr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
