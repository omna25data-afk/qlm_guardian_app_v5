import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';

/// Provider for record book action results (open/close/create/procedures)
final recordBookActionProvider =
    StateNotifierProvider<RecordBookActionNotifier, RecordBookActionState>((
      ref,
    ) {
      final repository = ref.watch(adminRepositoryProvider);
      return RecordBookActionNotifier(repository);
    });

class RecordBookActionState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final List<Map<String, dynamic>> procedures;

  const RecordBookActionState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.procedures = const [],
  });

  RecordBookActionState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    List<Map<String, dynamic>>? procedures,
  }) {
    return RecordBookActionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      procedures: procedures ?? this.procedures,
    );
  }
}

class RecordBookActionNotifier extends StateNotifier<RecordBookActionState> {
  final dynamic _repository;

  RecordBookActionNotifier(this._repository)
    : super(const RecordBookActionState());

  Future<bool> openRecordBook(int id, {String? date}) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      await _repository.openRecordBook(id, date: date);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'تم فتح السجل بنجاح',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> closeRecordBook(int id, {String? date}) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      await _repository.closeRecordBook(id, date: date);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'تم إغلاق السجل بنجاح',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> createRecordBook(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      await _repository.createRecordBook(data);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'تم إنشاء السجل بنجاح',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> fetchProcedures(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final procedures = await _repository.getRecordBookProcedures(id);
      state = state.copyWith(isLoading: false, procedures: procedures);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}
