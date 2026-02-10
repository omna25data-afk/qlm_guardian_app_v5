import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_guardian_model.dart';
import 'admin_dashboard_provider.dart';

final adminGuardiansProvider =
    StateNotifierProvider.autoDispose<
      AdminGuardiansNotifier,
      AsyncValue<List<AdminGuardianModel>>
    >((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminGuardiansNotifier(repository);
    });

class AdminGuardiansNotifier
    extends StateNotifier<AsyncValue<List<AdminGuardianModel>>> {
  final dynamic
  _repository; // Typed as dynamic to avoid circular import issues if any, but ideally AdminRepository
  Timer? _debounceTimer;

  AdminGuardiansNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchGuardians();
  }

  Future<void> fetchGuardians({String? query}) async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getGuardians(query: query);
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchGuardians(query: query);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
