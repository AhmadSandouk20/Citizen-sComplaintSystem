import '../../../../core/config/app_config.dart';
import '../../../../core/shared/paginated_result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDataSource _remote;

  @override
  Future<PaginatedResult<NotificationEntity>> getNotifications({
    int page = 1,
    int perPage = AppConfig.defaultPageSize,
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
    // Asks for a single unread row and reads `total` off the paginator —
    // cheaper than pulling a full page just to count.
    final result = await _remote.fetchNotifications(
      page: 1,
      perPage: 1,
      isRead: false,
    );
    return result.total;
  }

  @override
  Future<void> markAsRead(int id) => _remote.markAsRead(id);

  @override
  Future<int> markAllAsRead(Iterable<int> ids) async {
    // TODO(moha): replace with a single bulk endpoint once the backend
    // exposes one — N requests here will trip `throttle:api_limit` on a
    // long list. Failures are counted, not swallowed.
    var failed = 0;
    for (final id in ids) {
      try {
        await _remote.markAsRead(id);
      } catch (_) {
        failed++;
      }
    }
    return failed;
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
  Future<void> deleteFcmToken(String token) => _remote.deleteFcmToken(token);
}
