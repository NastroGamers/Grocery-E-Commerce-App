import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationListResponse> getNotifications({required int page, required int limit});
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> updateFCMToken(UpdateFCMTokenRequest request);
  Future<NotificationSettings> getNotificationSettings();
  Future<void> updateNotificationSettings(NotificationSettings settings);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient dioClient;

  NotificationRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<NotificationListResponse> getNotifications({required int page, required int limit}) async {
    try {
      final response = await dioClient.get(
        AppConfig.notificationsEndpoint,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        return NotificationListResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load notifications');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load notifications: ${e.message}');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await dioClient.put('${AppConfig.notificationsEndpoint}/$notificationId/read');
    } on DioException catch (e) {
      throw Exception('Failed to mark notification as read: ${e.message}');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dioClient.put('${AppConfig.notificationsEndpoint}/read-all');
    } on DioException catch (e) {
      throw Exception('Failed to mark all as read: ${e.message}');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await dioClient.delete('${AppConfig.notificationsEndpoint}/$notificationId');
    } on DioException catch (e) {
      throw Exception('Failed to delete notification: ${e.message}');
    }
  }

  @override
  Future<void> updateFCMToken(UpdateFCMTokenRequest request) async {
    try {
      await dioClient.post(
        '${AppConfig.notificationsEndpoint}/fcm-token',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update FCM token: ${e.message}');
    }
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    try {
      final response = await dioClient.get('${AppConfig.notificationsEndpoint}/settings');

      if (response.statusCode == 200) {
        return NotificationSettings.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load settings');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load settings: ${e.message}');
    }
  }

  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    try {
      await dioClient.put(
        '${AppConfig.notificationsEndpoint}/settings',
        data: settings.toJson(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update settings: ${e.message}');
    }
  }
}
