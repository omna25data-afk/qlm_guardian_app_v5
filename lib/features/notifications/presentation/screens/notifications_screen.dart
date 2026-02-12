import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/theme/app_colors.dart';
import '../../data/models/notification_model.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'تحديد الكل كمقروء',
            onPressed: () {
              ref.read(notificationsControllerProvider).markAllAsRead();
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'حدث خطأ أثناء تحميل الإشعارات',
                style: GoogleFonts.tajawal(),
              ),
              TextButton(
                onPressed: () => ref.refresh(notificationsListProvider),
                child: Text('إعادة المحاولة', style: GoogleFonts.tajawal()),
              ),
            ],
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد إشعارات جديدة',
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(notificationsListProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _NotificationCard(notification: notifications[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  final NotificationModel notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: notification.isRead ? 0.5 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: notification.isRead
          ? Colors.white
          : Colors.blue.shade50.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isRead
              ? Colors.transparent
              : Colors.blue.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            ref
                .read(notificationsControllerProvider)
                .markAsRead(notification.id);
          }
          // Handle tap action based on type if needed
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(notification.type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.tajawal(
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              fontSize: 16,
                              color: notification.isRead
                                  ? AppColors.textPrimary
                                  : Colors.black,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
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
                      notification.body,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(notification.createdAt),
                      style: GoogleFonts.tajawal(
                        fontSize: 12,
                        color: Colors.grey[400],
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
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'warning':
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case 'error':
        icon = Icons.error_outline;
        color = Colors.red;
        break;
      case 'info':
      default:
        icon = Icons.info_outline;
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
