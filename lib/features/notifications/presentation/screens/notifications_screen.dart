import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/theme/app_colors.dart';
import '../../data/models/app_notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإشعارات',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          if (state.unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'تحديد الكل كمقروء',
              onPressed: () {
                ref.read(notificationProvider.notifier).markAllAsRead();
              },
            ),
        ],
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.read(notificationProvider.notifier).refresh(),
        child: _buildBody(state, ref),
      ),
    );
  }

  Widget _buildBody(NotificationState state, WidgetRef ref) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'حدث خطأ أثناء تحميل الإشعارات',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            if (state.error != null)
              Text(
                state.error!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Tajawal',
                ),
              ),
            TextButton(
              onPressed: () =>
                  ref.read(notificationProvider.notifier).refresh(),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا توجد إشعارات جديدة',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        return Dismissible(
          key: Key(notification.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'حذف الإشعار',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                    content: const Text(
                      'هل تريد حذف هذا الإشعار؟',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          'حذف',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;
          },
          onDismissed: (_) {
            ref
                .read(notificationProvider.notifier)
                .deleteNotification(notification.id);
          },
          child: _NotificationCard(notification: notification),
        );
      },
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  final AppNotificationModel notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRead = notification.readAt != null;
    final title = notification.data['title'] ?? 'إشعار جديد';
    final body =
        notification.data['body'] ?? notification.data['message'] ?? '';
    final type =
        notification.data['action_type'] ?? notification.data['type'] ?? 'info';

    return Card(
      elevation: isRead ? 0.5 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: isRead ? Colors.white : Colors.blue.shade50.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRead
              ? Colors.transparent
              : Colors.blue.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (!isRead) {
            ref.read(notificationProvider.notifier).markAsRead(notification.id);
          }
          // Handle tap action based on link if provided
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              fontSize: 16,
                              color: isRead
                                  ? AppColors.textPrimary
                                  : Colors.black,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'success':
      case 'entry_approved':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'warning':
      case 'entry_status_changed':
        icon = Icons.sync;
        color = Colors.orange;
        break;
      case 'error':
      case 'entry_rejected':
        icon = Icons.error_outline;
        color = Colors.red;
        break;
      case 'entry_created':
        icon = Icons.post_add;
        color = Colors.blue;
        break;
      case 'info':
      default:
        icon = Icons.notifications_active;
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _formatTime(DateTime time) {
    if (DateTime.now().difference(time).inDays < 1) {
      return intl.DateFormat('hh:mm a').format(time);
    }
    return intl.DateFormat('yyyy-MM-dd').format(time);
  }
}
