import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NotificationListResponse> getNotifications({required int page, required int limit}) async {
    return await remoteDataSource.getNotifications(page: page, limit: limit);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    return await remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() async {
    return await remoteDataSource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    return await remoteDataSource.deleteNotification(notificationId);
  }

  @override
  Future<void> updateFCMToken(UpdateFCMTokenRequest request) async {
    return await remoteDataSource.updateFCMToken(request);
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    return await remoteDataSource.getNotificationSettings();
  }

  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    return await remoteDataSource.updateNotificationSettings(settings);
  }
}
