import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
import '../../providers/admin_guardians_provider.dart';
import '../../widgets/guardians/guardian_list_card.dart';
import '../add_edit_guardian_screen.dart';

class GuardiansListTab extends ConsumerStatefulWidget {
  const GuardiansListTab({super.key});

  @override
  ConsumerState<GuardiansListTab> createState() => _GuardiansListTabState();
}

class _GuardiansListTabState extends ConsumerState<GuardiansListTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminGuardiansProvider.notifier).fetchGuardians();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminGuardiansProvider);

    if (state.isLoading && state.guardians.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.guardians.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('حدث خطأ: ${state.error}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(adminGuardiansProvider.notifier)
                    .fetchGuardians(refresh: true);
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state.guardians.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: const Center(child: Text('لا توجد بيانات للأمناء')),
        floatingActionButton: _buildAddFab(context),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(adminGuardiansProvider.notifier)
              .fetchGuardians(refresh: true);
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          itemCount: state.guardians.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.guardians.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final guardian = state.guardians[index];
            return GuardianListCard(guardian: guardian);
          },
        ),
      ),
      floatingActionButton: _buildAddFab(context),
    );
  }

  Widget _buildAddFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddEditGuardianScreen(),
          ),
        );
      },
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
