import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_dashboard_provider.dart';

class GuardianInspectionsState {
  final Map<int, List<Map<String, dynamic>>> inspectionsByGuardian;
  final bool isLoading;
  final String? error;

  const GuardianInspectionsState({
    this.inspectionsByGuardian = const {},
    this.isLoading = false,
    this.error,
  });

  GuardianInspectionsState copyWith({
    Map<int, List<Map<String, dynamic>>>? inspectionsByGuardian,
    bool? isLoading,
    String? error,
  }) {
    return GuardianInspectionsState(
      inspectionsByGuardian:
          inspectionsByGuardian ?? this.inspectionsByGuardian,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class GuardianInspectionsNotifier
    extends StateNotifier<GuardianInspectionsState> {
  final dynamic _repository;

  GuardianInspectionsNotifier(this._repository)
    : super(const GuardianInspectionsState());

  Future<void> fetchInspections(int guardianId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inspections = await _repository.getGuardianInspections(guardianId);
      final newMap = Map<int, List<Map<String, dynamic>>>.from(
        state.inspectionsByGuardian,
      );
      newMap[guardianId] = inspections;
      state = state.copyWith(inspectionsByGuardian: newMap, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final guardianInspectionsProvider =
    StateNotifierProvider<
      GuardianInspectionsNotifier,
      GuardianInspectionsState
    >((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return GuardianInspectionsNotifier(repository);
    });
