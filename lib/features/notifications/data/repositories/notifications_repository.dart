import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection.dart';
import '../models/notification_model.dart';

// Provider for the repository
final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(getIt<ApiClient>());
});

class NotificationsRepository {
  // final ApiClient _apiClient;

  NotificationsRepository(ApiClient apiClient); // _apiClient not used yet

  Future<List<NotificationModel>> getNotifications({int page = 1}) async {
    // TODO: Connect to real API when available
    // final response = await _apiClient.get(ApiEndpoints.notifications, queryParameters: {'page': page});
    // return (response.data['data'] as List).map((e) => NotificationModel.fromJson(e)).toList();

    // Mock Data
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      NotificationModel(
        id: '1',
        title: 'تم تجديد الترخيص بنجاح',
        body: 'لقد تمت الموافقة على طلب تجديد الترخيص الخاص بك لعام 1446هـ.',
        type: 'success',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      NotificationModel(
        id: '2',
        title: 'تنبيه: اقتراب انتهاء البطاقة',
        body:
            'يرجى العلم بأن بطاقة المهنة ستنتهي خلال 15 يوماً. يرجى المبادرة بالتجديد.',
        type: 'warning',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '3',
        title: 'تحديث جديد للنظام',
        body:
            'تم إطلاق النسخة الخامسة من بوابة الأمين الشرعي مع تحسينات في الأداء والمزامنة.',
        type: 'info',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '4',
        title: 'مزامنة قيود',
        body: 'تمت مزامنة 5 قيود بنجاح مع الخادم المركزي.',
        type: 'info',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<void> markAsRead(String id) async {
    // await _apiClient.post('${ApiEndpoints.notifications}/$id/read');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> markAllAsRead() async {
    // await _apiClient.post('${ApiEndpoints.notifications}/read-all');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<int> getUnreadCount() async {
    // final response = await _apiClient.get('${ApiEndpoints.notifications}/unread-count');
    // return response.data['count'];
    return 1; // Mock
  }
}
