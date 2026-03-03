import 'package:qlm_guardian_app_v5/features/notifications/data/models/app_notification_model.dart';
import 'package:qlm_guardian_app_v5/core/network/api_client.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  Future<List<AppNotificationModel>> getNotifications({int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/notifications',
        queryParameters: {'page': page},
      );

      final data = response.data['data'] as List;
      return data.map((json) => AppNotificationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.dio.get(
        '/api/notifications/unread-count',
      );
      return response.data['count'] as int;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _apiClient.dio.patch('/api/notifications/$id/read');
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiClient.dio.patch('/api/notifications/read-all');
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _apiClient.dio.delete('/api/notifications/$id');
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }
}
