import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/theme/colors.dart';
import 'package:final_flutter/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: isUnread
          ? AppColors.primaryContainer.withValues(alpha: 0.45)
          : null,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isUnread
              ? AppColors.primary
              : AppColors.surfaceVariant,
          child: Icon(
            isUnread ? Icons.notifications_active : Icons.notifications_none,
            color: isUnread ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Text(
              _formatTime(notification.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (notification.referenceCode != null &&
                notification.referenceCode!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  notification.referenceCode!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
        trailing: isUnread
            ? const Icon(Icons.circle, size: 10, color: AppColors.primary)
            : null,
        isThreeLine: true,
      ),
    );
  }

  String _formatTime(DateTime value) {
    final local = value.toLocal();
    final diff = DateTime.now().difference(local);
    if (diff.inMinutes < 1) return LocaleKeys.justNow.tr();
    if (diff.inHours < 1) {
      return LocaleKeys.minutesAgo.tr(args: ['${diff.inMinutes}']);
    }
    if (diff.inDays < 1) {
      return LocaleKeys.hoursAgo.tr(args: ['${diff.inHours}']);
    }
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }
}
