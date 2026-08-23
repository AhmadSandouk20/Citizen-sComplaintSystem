import 'package:final_flutter/core/shared/paginated_result.dart';
import 'package:final_flutter/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:final_flutter/features/notifications/domain/entities/notification_entity.dart';
import 'package:final_flutter/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDataSource _remote;

  @override
  Future<PaginatedResult<NotificationEntity>> getNotifications({
    int page = 1,
    int perPage = 15,
    bool? isRead,
  }) {
    return _remote.fetchNotifications(
      page: page,
      perPage: perPage,
      isRead: isRead,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    final result = await _remote.fetchNotifications(
      page: 1,
      perPage: 1,
      isRead: false,
    );
    return result.total;
  }

  @override
  Future<NotificationEntity> markAsRead(int id) {
    return _remote.markAsRead(id);
  }

  @override
  Future<void> saveFcmToken({
    required String token,
    String deviceType = 'android',
    String? deviceId,
  }) {
    return _remote.saveFcmToken(
      token: token,
      deviceType: deviceType,
      deviceId: deviceId,
    );
  }

  @override
  Future<void> deleteFcmToken(String token) {
    return _remote.deleteFcmToken(token);
  }
}
