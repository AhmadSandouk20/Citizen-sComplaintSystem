import '../../../../core/shared/paginated_result.dart';
import '../entities/notification_entity.dart';

/// Contract for `/api/notifications/*`.
abstract class NotificationsRepository {
  Future<PaginatedResult<NotificationEntity>> getNotifications({
    int page,
    int perPage,
    bool? isRead,
  });

  /// Unread badge count.
  Future<int> getUnreadCount();

  Future<void> markAsRead(int id);

  /// Marks every unread notification as read.
  ///
  /// Returns the number that could not be marked, so the UI can tell the user
  /// something was left behind instead of failing silently.
  Future<int> markAllAsRead(Iterable<int> ids);

  Future<void> saveFcmToken({
    required String token,
    String deviceType,
    String? deviceId,
  });

  Future<void> deleteFcmToken(String token);
}
