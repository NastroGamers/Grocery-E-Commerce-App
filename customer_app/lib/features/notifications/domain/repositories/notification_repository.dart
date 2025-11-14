import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<NotificationListResponse> getNotifications({required int page, required int limit});
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> updateFCMToken(UpdateFCMTokenRequest request);
  Future<NotificationSettings> getNotificationSettings();
  Future<void> updateNotificationSettings(NotificationSettings settings);
}
