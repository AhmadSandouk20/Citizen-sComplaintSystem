import 'package:final_flutter/core/shared/paginated_result.dart';
import 'package:final_flutter/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<PaginatedResult<NotificationEntity>> getNotifications({
    int page = 1,
    int perPage = 15,
    bool? isRead,
  });

  Future<int> getUnreadCount();

  Future<NotificationEntity> markAsRead(int id);

  Future<void> saveFcmToken({
    required String token,
    String deviceType = 'android',
    String? deviceId,
  });

  Future<void> deleteFcmToken(String token);
}
