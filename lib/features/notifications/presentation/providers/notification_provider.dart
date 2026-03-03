import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/app_notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/services/notification_polling_service.dart';

class NotificationState {
  final List<AppNotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<AppNotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;
  final NotificationPollingService _pollingService;
  final Ref _ref;
  bool _isPollingActive = false;

  NotificationNotifier(this._repository, this._pollingService, this._ref)
    : super(NotificationState()) {
    _init();
  }

  Future<void> _init() async {
    await refresh();
    _setupPolling();
    // الاستماع لتغيّر حالة المصادقة لإيقاف الـ Polling عند تسجيل الخروج
    _ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated && !_isPollingActive) {
        _setupPolling();
      } else if (!next.isAuthenticated && _isPollingActive) {
        _pollingService.stop();
        _isPollingActive = false;
        state = NotificationState(); // إعادة تعيين الحالة
      }
    });
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final notifications = await _repository.getNotifications();
      final unreadCount = await _repository.getUnreadCount();
      state = state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markAsRead(id);
      // Update local state optimizing update
      final updatedList = state.notifications.map((n) {
        if (n.id == id && n.readAt == null) {
          return n.copyWith(readAt: DateTime.now());
        }
        return n;
      }).toList();
      state = state.copyWith(
        notifications: updatedList,
        unreadCount: (state.unreadCount > 0) ? state.unreadCount - 1 : 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      final updatedList = state.notifications.map((n) {
        if (n.readAt == null) return n.copyWith(readAt: DateTime.now());
        return n;
      }).toList();
      state = state.copyWith(notifications: updatedList, unreadCount: 0);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// حذف إشعار محدد
  Future<void> deleteNotification(String id) async {
    try {
      await _repository.deleteNotification(id);
      final wasUnread = state.notifications.any(
        (n) => n.id == id && n.readAt == null,
      );
      final updatedList = state.notifications.where((n) => n.id != id).toList();
      state = state.copyWith(
        notifications: updatedList,
        unreadCount: wasUnread && state.unreadCount > 0
            ? state.unreadCount - 1
            : state.unreadCount,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void _setupPolling() {
    final authState = _ref.read(authProvider);
    if (authState.isAuthenticated && authState.user != null) {
      _pollingService.onNewNotifications = (count) {
        state = state.copyWith(unreadCount: count);
        refresh();
      };
      _pollingService.start();
      _isPollingActive = true;
    }
  }

  @override
  void dispose() {
    _pollingService.stop();
    _isPollingActive = false;
    super.dispose();
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiClient = getIt<ApiClient>();
  return NotificationRepository(apiClient);
});

final notificationPollingServiceProvider = Provider<NotificationPollingService>(
  (ref) {
    final repo = ref.watch(notificationRepositoryProvider);
    return NotificationPollingService(repo);
  },
);

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final repo = ref.watch(notificationRepositoryProvider);
      final polling = ref.watch(notificationPollingServiceProvider);
      return NotificationNotifier(repo, polling, ref);
    });
