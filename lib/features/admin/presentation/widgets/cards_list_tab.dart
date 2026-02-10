import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_cards_provider.dart';
import '../../data/models/admin_renewal_model.dart';

class CardsListTab extends ConsumerStatefulWidget {
  const CardsListTab({super.key});

  @override
  ConsumerState<CardsListTab> createState() => _CardsListTabState();
}

class _CardsListTabState extends ConsumerState<CardsListTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminCardsProvider.notifier).fetchCards(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminCardsProvider);

    return Column(
      children: [
        // List
        Expanded(
          child: state.isLoading && state.cards.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.error != null && state.cards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(state.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(adminCardsProvider.notifier)
                            .fetchCards(refresh: true),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : state.cards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.credit_card_outlined,
                        size: 60,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد بطاقات',
                        style: GoogleFonts.tajawal(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!state.isLoading &&
                        state.hasMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      ref.read(adminCardsProvider.notifier).fetchCards();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () => ref
                        .read(adminCardsProvider.notifier)
                        .fetchCards(refresh: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: state.cards.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.cards.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final card = state.cards[index];
                        return _buildCardItem(context, card);
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCardItem(BuildContext context, AdminRenewalModel card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    card.guardianName,
                    style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(
                  card.status,
                  _getStatusColor(card.statusColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.credit_card, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'رقم البطاقة: ${card.id}',
                  style: GoogleFonts.tajawal(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'التاريخ: ${card.renewalDate}',
                  style: GoogleFonts.tajawal(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            if (card.type.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    card.type,
                    style: GoogleFonts.tajawal(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
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
        style: GoogleFonts.tajawal(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
