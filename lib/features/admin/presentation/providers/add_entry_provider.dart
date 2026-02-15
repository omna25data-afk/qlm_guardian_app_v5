import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_repository.dart';
import '../providers/admin_dashboard_provider.dart'
    show adminRepositoryProvider;

import '../../../records/data/models/record_book.dart';

/// State for the Add Entry form
class AddEntryState {
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;
  final List<Map<String, dynamic>> contractTypes;
  final List<Map<String, dynamic>> subtypes1;
  final List<Map<String, dynamic>> subtypes2;
  final List<Map<String, dynamic>> guardians;
  final List<Map<String, dynamic>> writers;
  final List<Map<String, dynamic>> otherWriters;
  final List<RecordBook> documentationRecordBooks;
  final Map<String, dynamic>? calculatedFees;

  const AddEntryState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.successMessage,
    this.contractTypes = const [],
    this.subtypes1 = const [],
    this.subtypes2 = const [],
    this.guardians = const [],
    this.writers = const [],
    this.otherWriters = const [],
    this.documentationRecordBooks = const [],
    this.calculatedFees,
  });

  AddEntryState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    String? successMessage,
    List<Map<String, dynamic>>? contractTypes,
    List<Map<String, dynamic>>? subtypes1,
    List<Map<String, dynamic>>? subtypes2,
    List<Map<String, dynamic>>? guardians,
    List<Map<String, dynamic>>? writers,
    List<Map<String, dynamic>>? otherWriters,
    List<RecordBook>? documentationRecordBooks,
    Map<String, dynamic>? calculatedFees,
  }) {
    return AddEntryState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      successMessage: successMessage,
      contractTypes: contractTypes ?? this.contractTypes,
      subtypes1: subtypes1 ?? this.subtypes1,
      subtypes2: subtypes2 ?? this.subtypes2,
      guardians: guardians ?? this.guardians,
      writers: writers ?? this.writers,
      otherWriters: otherWriters ?? this.otherWriters,
      documentationRecordBooks:
          documentationRecordBooks ?? this.documentationRecordBooks,
      calculatedFees: calculatedFees ?? this.calculatedFees,
    );
  }
}

class AddEntryNotifier extends StateNotifier<AddEntryState> {
  final AdminRepository _repo;

  AddEntryNotifier(this._repo) : super(const AddEntryState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await Future.wait([
        _repo.getContractTypes(),
        _repo.getActiveGuardians(),
        _repo.getWriters(),
        _repo.getOtherWriters(),
      ]);
      state = state.copyWith(
        isLoading: false,
        contractTypes: results[0] as List<Map<String, dynamic>>,
        guardians: (results[1] as List)
            .map(
              (g) => {'id': g.id, 'name': g.name, 'full_object': g},
            ) // Keep full object if needed
            .toList(),
        writers: results[2] as List<Map<String, dynamic>>,
        otherWriters: results[3] as List<Map<String, dynamic>>,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadSubtypes(int contractTypeId, {String? parentCode}) async {
    try {
      final subtypes = await _repo.getContractSubtypes(
        contractTypeId,
        parentCode: parentCode,
      );
      if (parentCode != null) {
        state = state.copyWith(subtypes2: subtypes);
      } else {
        state = state.copyWith(subtypes1: subtypes, subtypes2: []);
      }
    } catch (e) {
      // Silently handle
    }
  }

  void clearSubtypes() {
    state = state.copyWith(subtypes1: [], subtypes2: []);
  }

  void clearRecordBooks() {
    state = state.copyWith(documentationRecordBooks: []);
  }

  Future<void> loadDocumentationRecordBooks(int contractTypeId) async {
    // Only load if not already loaded or if changed?
    // Usually fetching is cheap enough.
    try {
      final books = await _repo.getRecordBooks(
        contractTypeId: contractTypeId,
        category: 'documentation_final', // Matches PHP 'documentation_final'
        status: 'open',
      );
      state = state.copyWith(documentationRecordBooks: books);
    } catch (e) {
      // Handle error or just empty
      state = state.copyWith(documentationRecordBooks: []);
    }
  }

  Future<bool> submitEntry(Map<String, dynamic> data) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await _repo.storeRegistryEntry(data);
      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'تم حفظ القيد بنجاح',
      );
      return true;
    } catch (e) {
      String errorMsg = 'حدث خطأ أثناء حفظ القيد';
      if (e.toString().contains('422')) {
        errorMsg = 'يرجى التحقق من البيانات المدخلة';
      } else if (e.toString().contains('403')) {
        errorMsg = 'لا تملك صلاحية لإضافة قيد';
      }
      state = state.copyWith(isSubmitting: false, error: errorMsg);
      return false;
    }
  }
}

final addEntryProvider =
    StateNotifierProvider.autoDispose<AddEntryNotifier, AddEntryState>((ref) {
      final repo = ref.watch(adminRepositoryProvider);
      return AddEntryNotifier(repo);
    });
