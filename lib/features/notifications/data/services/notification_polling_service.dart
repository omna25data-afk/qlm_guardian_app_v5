import 'dart:async';
import 'package:flutter/foundation.dart';
import '../repositories/notification_repository.dart';

class NotificationPollingService {
  Timer? _timer;
  int _lastKnownCount = -1;
  final NotificationRepository _repository;
  Function(int newCount)? onNewNotifications;

  NotificationPollingService(this._repository);

  void start() {
    // Poll immediately, then every 30 seconds
    _poll();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _poll());
  }

  Future<void> _poll() async {
    try {
      final count = await _repository.getUnreadCount();
      if (count != _lastKnownCount) {
        _lastKnownCount = count;
        onNewNotifications?.call(count);
      }
    } catch (e) {
      debugPrint('Polling error: $e');
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
