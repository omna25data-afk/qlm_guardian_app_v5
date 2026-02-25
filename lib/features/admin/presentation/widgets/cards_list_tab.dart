import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_cards_provider.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/screens/guardians/add_edit_card_screen.dart';
import 'package:qlm_guardian_app_v5/features/admin/presentation/screens/guardians/card_history_screen.dart';
import 'guardians/guardian_list_card.dart';

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // List
          Expanded(
            child: state.isLoading && state.guardians.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.error != null && state.guardians.isEmpty
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
                : state.guardians.isEmpty
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
                            state.guardians.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.guardians.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final guardian = state.guardians[index];
                          return GuardianListCard(
                            guardian: guardian,
                            onRefresh: () {
                              ref
                                  .read(adminCardsProvider.notifier)
                                  .fetchCards(refresh: true);
                            },
                            customActions: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CardHistoryScreen(
                                            guardian: guardian,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.history),
                                    label: const Text('سجل التجديدات'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const AddEditCardScreen(),
                                          settings: RouteSettings(
                                            arguments: guardian,
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
                                    icon: const Icon(
                                      Icons.autorenew,
                                      color: Colors.white,
                                    ),
                                    label: const Text('تجديد البطاقة'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
