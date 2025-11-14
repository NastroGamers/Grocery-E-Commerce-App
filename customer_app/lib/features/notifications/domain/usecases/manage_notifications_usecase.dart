import '../repositories/notification_repository.dart';
import '../../data/models/notification_model.dart';

class ManageNotificationsUseCase {
  final NotificationRepository repository;

  ManageNotificationsUseCase(this.repository);

  Future<NotificationListResponse> getNotifications({required int page, required int limit}) async {
    if (page < 1) throw Exception('Invalid page number');
    if (limit < 1 || limit > 50) throw Exception('Limit must be between 1 and 50');
    return await repository.getNotifications(page: page, limit: limit);
  }

  Future<void> markAsRead(String notificationId) async {
    if (notificationId.isEmpty) throw Exception('Notification ID is required');
    return await repository.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    return await repository.markAllAsRead();
  }

  Future<void> deleteNotification(String notificationId) async {
    if (notificationId.isEmpty) throw Exception('Notification ID is required');
    return await repository.deleteNotification(notificationId);
  }

  Future<void> updateFCMToken({
    required String fcmToken,
    required String deviceId,
    required String platform,
  }) async {
    if (fcmToken.isEmpty) throw Exception('FCM token is required');
    if (deviceId.isEmpty) throw Exception('Device ID is required');
    if (platform != 'android' && platform != 'ios') throw Exception('Invalid platform');

    final request = UpdateFCMTokenRequest(
      fcmToken: fcmToken,
      deviceId: deviceId,
      platform: platform,
    );
    return await repository.updateFCMToken(request);
  }

  Future<NotificationSettings> getNotificationSettings() async {
    return await repository.getNotificationSettings();
  }

  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    return await repository.updateNotificationSettings(settings);
  }
}
