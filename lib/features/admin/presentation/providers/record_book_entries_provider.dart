import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/features/registry/data/models/registry_entry_model.dart';
import '../../data/repositories/admin_repository.dart';
import '../../../../core/di/injection.dart';

// Provider that accepts a recordBookId family parameter
final recordBookEntriesProvider = StateNotifierProvider.autoDispose
    .family<
      RecordBookEntriesNotifier,
      AsyncValue<List<RegistryEntryModel>>,
      int
    >((ref, recordBookId) {
      return RecordBookEntriesNotifier(getIt<AdminRepository>(), recordBookId);
    });

class RecordBookEntriesNotifier
    extends StateNotifier<AsyncValue<List<RegistryEntryModel>>> {
  final AdminRepository _repository;
  final int recordBookId;

  // Filters
  String? searchQuery;
  String? status;

  RecordBookEntriesNotifier(this._repository, this.recordBookId)
    : super(const AsyncValue.loading()) {
    fetchEntries();
  }

  Future<void> fetchEntries() async {
    state = const AsyncValue.loading();
    try {
      final entries = await _repository.getRegistryEntries(
        recordBookId: recordBookId,
        searchQuery: searchQuery,
        status: status,
      );
      state = AsyncValue.data(entries);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateFilters({String? search, String? status}) {
    if (search != null) searchQuery = search;
    if (status != null) this.status = status;
    fetchEntries();
  }
}
