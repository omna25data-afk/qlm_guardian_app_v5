import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_cards_provider.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/screens/guardians/add_edit_card_screen.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/screens/guardians/card_history_screen.dart';
import 'renewal_card.dart';

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

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: const Text(
          'هل أنت متأكد من حذف هذا التجديد؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(adminCardsProvider.notifier).deleteRenewal(id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminCardsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: state.isLoading && state.renewals.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.error != null && state.renewals.isEmpty
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
                : state.renewals.isEmpty
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
                          'لا توجد تجديدات بطاقات',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontFamily: 'Tajawal',
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
                        itemCount:
                            state.renewals.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.renewals.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final renewal = state.renewals[index];
                          return RenewalCard(
                            renewal: renewal,
                            onHistory: renewal.legitimateGuardianId != null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CardHistoryScreen(
                                          guardianId:
                                              renewal.legitimateGuardianId!,
                                          guardianName: renewal.guardianName,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            onRenew: renewal.legitimateGuardianId != null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AddEditCardScreen(),
                                        settings: RouteSettings(
                                          arguments: renewal,
                                        ),
                                      ),
                                    ).then((result) {
                                      if (result == true) {
                                        ref
                                            .read(adminCardsProvider.notifier)
                                            .fetchCards(refresh: true);
                                      }
                                    });
                                  }
                                : null,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddEditCardScreen(),
                                  settings: RouteSettings(
                                    arguments: {
                                      'editMode': true,
                                      'renewal': renewal,
                                    },
                                  ),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  ref
                                      .read(adminCardsProvider.notifier)
                                      .fetchCards(refresh: true);
                                }
                              });
                            },
                            onDelete: () => _confirmDelete(renewal.id),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditCardScreen()),
          ).then((result) {
            if (result == true) {
              ref.read(adminCardsProvider.notifier).fetchCards(refresh: true);
            }
          });
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
