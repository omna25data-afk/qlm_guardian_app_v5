import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart'
    show adminRepositoryProvider;

/// نموذج سجل عملية واحدة
class ActivityLogItem {
  final int id;
  final String action;
  final String actionLabel;
  final String userName;
  final String? description;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final String? createdAt;
  final String? timeAgo;

  const ActivityLogItem({
    required this.id,
    required this.action,
    required this.actionLabel,
    required this.userName,
    this.description,
    this.oldValues,
    this.newValues,
    this.createdAt,
    this.timeAgo,
  });

  factory ActivityLogItem.fromJson(Map<String, dynamic> json) {
    return ActivityLogItem(
      id: json['id'] ?? 0,
      action: json['action'] ?? '',
      actionLabel: json['action_label'] ?? json['action'] ?? '',
      userName: json['user_name'] ?? 'النظام',
      description: json['description'],
      oldValues: json['old_values'] is Map
          ? Map<String, dynamic>.from(json['old_values'])
          : null,
      newValues: json['new_values'] is Map
          ? Map<String, dynamic>.from(json['new_values'])
          : null,
      createdAt: json['created_at'],
      timeAgo: json['time_ago'],
    );
  }
}

/// ويدجت سجل العمليات — Timeline لعرض تاريخ التعديلات على قيد
class ActivityLogWidget extends ConsumerStatefulWidget {
  final int entryId;

  const ActivityLogWidget({super.key, required this.entryId});

  @override
  ConsumerState<ActivityLogWidget> createState() => _ActivityLogWidgetState();
}

class _ActivityLogWidgetState extends ConsumerState<ActivityLogWidget> {
  List<ActivityLogItem> _logs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(adminRepositoryProvider);
      final rawLogs = await repository.getActivityLogRaw(widget.entryId);
      final items = rawLogs.map((e) => ActivityLogItem.fromJson(e)).toList();
      setState(() {
        _logs = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'تعذر تحميل سجل العمليات';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            TextButton(
              onPressed: _fetchLogs,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.history, color: Colors.grey, size: 40),
              SizedBox(height: 8),
              Text(
                'لا توجد عمليات مسجلة',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        return _buildLogTile(
          log,
          isFirst: index == 0,
          isLast: index == _logs.length - 1,
        );
      },
    );
  }

  Widget _buildLogTile(
    ActivityLogItem log, {
    required bool isFirst,
    required bool isLast,
  }) {
    final (icon, color) = _getActionStyle(log.action);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Container(width: 2, height: 12, color: Colors.grey.shade300),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 14, color: color),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade300),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Content
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            log.actionLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: color,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        Text(
                          log.timeAgo ?? log.createdAt ?? '',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (log.description != null)
                      Text(
                        log.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      'بواسطة: ${log.userName}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _getActionStyle(String action) {
    return switch (action) {
      'created' => (Icons.add_circle_outline, Colors.blue),
      'updated' => (Icons.edit_outlined, Colors.orange),
      'documented' => (Icons.check_circle, Colors.green),
      'rejected' => (Icons.cancel_outlined, Colors.red),
      'deleted' => (Icons.delete_outline, Colors.red.shade700),
      'status_changed' => (Icons.sync, Colors.purple),
      'requested_documentation' => (Icons.send, Colors.teal),
      _ => (Icons.info_outline, Colors.grey),
    };
  }
}
