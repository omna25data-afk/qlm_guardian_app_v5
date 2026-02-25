import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
import '../../../data/models/admin_guardian_model.dart';
import '../../../data/models/admin_renewal_model.dart';
import '../../providers/admin_cards_provider.dart';

class CardHistoryScreen extends ConsumerStatefulWidget {
  final AdminGuardianModel guardian;

  const CardHistoryScreen({super.key, required this.guardian});

  @override
  ConsumerState<CardHistoryScreen> createState() => _CardHistoryScreenState();
}

class _CardHistoryScreenState extends ConsumerState<CardHistoryScreen> {
  bool _isLoading = true;
  String? _error;
  List<AdminRenewalModel> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final history = await ref
          .read(adminCardsProvider.notifier)
          .fetchCardHistory(widget.guardian.id);
      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'سجل تجديدات البطاقة',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: const TextStyle(fontFamily: 'Tajawal'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _error = null;
                      });
                      _fetchHistory();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          : _history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  const Text(
                    'لا يوجد سجل تجديدات سابق',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchHistory,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final renewal = _history[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'تجديد رقم: ${renewal.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                              _buildStatusBadge(
                                renewal.status,
                                _getStatusColor(renewal.statusColor),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'التاريخ:',
                            renewal.renewalDate,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.receipt_long,
                            'رقم السند:',
                            renewal.receiptNumber?.toString() ?? 'غير متوفر',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.attach_money,
                            'المبلغ:',
                            renewal.receiptAmount?.toString() ?? 'غير متوفر',
                          ),
                          if (renewal.notes != null &&
                              renewal.notes!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.notes,
                              'الملاحظات:',
                              renewal.notes!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'green':
      case 'success':
        return AppColors.success;
      case 'red':
      case 'error':
      case 'danger':
        return AppColors.error;
      case 'orange':
      case 'warning':
        return AppColors.warning;
      case 'blue':
      case 'info':
        return AppColors.info;
      default:
        return AppColors.textHint;
    }
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
