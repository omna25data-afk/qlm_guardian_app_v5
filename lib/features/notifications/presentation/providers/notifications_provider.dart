import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notifications_repository.dart';

// List provider
final notificationsListProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
      final repository = ref.watch(notificationsRepositoryProvider);
      return await repository.getNotifications();
    });

// Unread count provider
final unreadNotificationsCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  final repository = ref.watch(notificationsRepositoryProvider);
  return await repository.getUnreadCount();
});

// Helper class for mutations
class NotificationsController {
  final Ref _ref;
  final NotificationsRepository _repository;

  NotificationsController(this._ref, this._repository);

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    _ref.invalidate(notificationsListProvider);
    _ref.invalidate(unreadNotificationsCountProvider);
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    _ref.invalidate(notificationsListProvider);
    _ref.invalidate(unreadNotificationsCountProvider);
  }
}

final notificationsControllerProvider = Provider<NotificationsController>((
  ref,
) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return NotificationsController(ref, repository);
});
