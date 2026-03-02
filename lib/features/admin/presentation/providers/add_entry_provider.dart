import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

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
  final List<RecordBook> guardianRecordBooks;
  final Map<String, dynamic>? calculatedFees;

  // Dynamic Fields
  final List<Map<String, dynamic>> allFields;
  final List<Map<String, dynamic>> filteredFields;
  final bool isLoadingFields;
  final Map<String, dynamic> formData;

  // Connectivity & Draft
  final bool isOnline;
  final bool hasDraft;

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
    this.guardianRecordBooks = const [],
    this.calculatedFees,
    this.allFields = const [],
    this.filteredFields = const [],
    this.isLoadingFields = false,
    this.formData = const {},
    this.isOnline = true,
    this.hasDraft = false,
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
    List<RecordBook>? guardianRecordBooks,
    Map<String, dynamic>? calculatedFees,
    List<Map<String, dynamic>>? allFields,
    List<Map<String, dynamic>>? filteredFields,
    bool? isLoadingFields,
    Map<String, dynamic>? formData,
    bool? isOnline,
    bool? hasDraft,
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
      guardianRecordBooks: guardianRecordBooks ?? this.guardianRecordBooks,
      calculatedFees: calculatedFees ?? this.calculatedFees,
      allFields: allFields ?? this.allFields,
      filteredFields: filteredFields ?? this.filteredFields,
      isLoadingFields: isLoadingFields ?? this.isLoadingFields,
      formData: formData ?? this.formData,
      isOnline: isOnline ?? this.isOnline,
      hasDraft: hasDraft ?? this.hasDraft,
    );
  }
}

class AddEntryNotifier extends StateNotifier<AddEntryState> {
  final AdminRepository _repo;
  Box? _cacheBox;

  static const String _cacheBoxName = 'add_entry_cache';
  static const String _draftKey = 'entry_draft';

  AddEntryNotifier(this._repo) : super(const AddEntryState()) {
    _init();
  }

  Future<void> _init() async {
    _cacheBox = await Hive.openBox(_cacheBoxName);
    await _checkConnectivity();
    await _checkDraft();
    await _loadInitialData();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    final isOnline = result.any((r) => r != ConnectivityResult.none);
    state = state.copyWith(isOnline: isOnline);
  }

  Future<void> _checkDraft() async {
    final draft = _cacheBox?.get(_draftKey);
    if (draft != null) {
      state = state.copyWith(hasDraft: true);
    }
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);

    // Try cache first for instant display
    final cachedTypes = _cacheBox?.get('contract_types');
    if (cachedTypes != null) {
      try {
        final types = (cachedTypes as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        state = state.copyWith(contractTypes: types);
      } catch (_) {}
    }

    try {
      final results = await Future.wait([
        _repo.getContractTypes(),
        _repo.getActiveGuardians(),
        _repo.getWriters(),
        _repo.getOtherWriters(),
      ]);

      final contractTypes = results[0] as List<Map<String, dynamic>>;
      final guardians = (results[1] as List)
          .map((g) => {'id': g.id, 'name': g.name, 'full_object': g})
          .toList();

      // Cache for offline
      _cacheBox?.put('contract_types', contractTypes);
      _cacheBox?.put('guardians', guardians);

      state = state.copyWith(
        isLoading: false,
        isOnline: true,
        contractTypes: contractTypes,
        guardians: guardians,
        writers: results[2] as List<Map<String, dynamic>>,
        otherWriters: results[3] as List<Map<String, dynamic>>,
      );
    } catch (e) {
      // Offline fallback
      final cachedGuardians = _cacheBox?.get('guardians');
      state = state.copyWith(
        isLoading: false,
        isOnline: false,
        guardians: cachedGuardians != null
            ? (cachedGuardians as List)
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList()
            : [],
        error: state.contractTypes.isEmpty ? e.toString() : null,
      );
    }
  }

  Future<void> loadSubtypes(int contractTypeId, {String? parentCode}) async {
    try {
      final subtypes = await _repo.getContractSubtypes(
        contractTypeId,
        parentCode: parentCode,
      );

      // Cache subtypes
      final cacheKey = 'subtypes_${contractTypeId}_${parentCode ?? 'root'}';
      _cacheBox?.put(cacheKey, subtypes);

      if (parentCode != null) {
        state = state.copyWith(subtypes2: subtypes);
      } else {
        state = state.copyWith(subtypes1: subtypes, subtypes2: []);
      }
    } catch (e) {
      // Offline fallback
      final cacheKey = 'subtypes_${contractTypeId}_${parentCode ?? 'root'}';
      final cached = _cacheBox?.get(cacheKey);
      if (cached != null) {
        final list = (cached as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        if (parentCode != null) {
          state = state.copyWith(subtypes2: list);
        } else {
          state = state.copyWith(subtypes1: list, subtypes2: []);
        }
      }
    }
  }

  void clearSubtypes() {
    state = state.copyWith(subtypes1: [], subtypes2: []);
  }

  void clearRecordBooks() {
    state = state.copyWith(
      documentationRecordBooks: [],
      guardianRecordBooks: [],
    );
  }

  Future<void> loadDocumentationRecordBooks(int contractTypeId) async {
    try {
      final books = await _repo.getRecordBooks(
        contractTypeId: contractTypeId,
        category: 'documentation_final',
        status: 'open',
      );
      state = state.copyWith(documentationRecordBooks: books);
    } catch (e) {
      state = state.copyWith(documentationRecordBooks: []);
    }
  }

  Future<void> loadGuardianRecordBooks(
    int contractTypeId,
    int guardianId,
  ) async {
    try {
      final books = await _repo.getRecordBooks(
        contractTypeId: contractTypeId,
        category: 'guardian_recording',
        guardianId: guardianId.toString(),
        status: 'open',
      );
      state = state.copyWith(guardianRecordBooks: books);
    } catch (e) {
      state = state.copyWith(guardianRecordBooks: []);
    }
  }

  Future<bool> submitEntry(Map<String, dynamic> data) async {
    state = state.copyWith(
      isSubmitting: true,
      error: null,
      successMessage: null,
    );
    try {
      // Include dynamic formData nested inside 'form_data' key
      final mergedData = Map<String, dynamic>.from(data);
      if (state.formData.isNotEmpty) {
        mergedData['form_data'] = state.formData;
      }

      await _repo.storeRegistryEntry(mergedData);

      // Clear draft on success
      _cacheBox?.delete(_draftKey);

      state = state.copyWith(
        isSubmitting: false,
        hasDraft: false,
        successMessage: 'تم حفظ القيد بنجاح',
        error: null,
      );
      return true;
    } on DioException catch (e) {
      String errorMsg = 'حدث خطأ أثناء حفظ القيد';
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      if (statusCode == 422) {
        if (responseData is Map<String, dynamic>) {
          if (responseData['errors'] != null) {
            final errors = responseData['errors'] as Map<String, dynamic>;
            final List<String> errorMessages = [];
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.addAll(value.map((e) => e.toString()));
              } else {
                errorMessages.add(value.toString());
              }
            });
            if (errorMessages.isNotEmpty) {
              errorMsg = errorMessages.join('\n');
            }
          } else if (responseData['message'] != null) {
            errorMsg = responseData['message'].toString();
          } else {
            errorMsg = 'يرجى التحقق من البيانات المدخلة';
          }
        } else {
          errorMsg = 'يرجى التحقق من البيانات المدخلة';
        }
      } else if (statusCode == 403) {
        errorMsg = 'لا تملك صلاحية لإضافة قيد';
      } else if (statusCode == 409) {
        // Duplicate entry
        if (responseData is Map<String, dynamic>) {
          errorMsg = responseData['message']?.toString() ?? 'القيد مسجل مسبقاً';
          if (responseData['error'] != null) {
            errorMsg += '\n${responseData['error']}';
          }
        } else {
          errorMsg = 'القيد مسجل مسبقاً';
        }
      } else if (statusCode == 404) {
        errorMsg = 'السجل المطلوب غير موجود';
      } else if (statusCode == 500) {
        if (responseData is Map<String, dynamic>) {
          errorMsg = responseData['message']?.toString() ?? 'خطأ في الخادم';
        } else {
          errorMsg = 'خطأ في الخادم';
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = 'لا يوجد اتصال بالإنترنت';
      }
      state = state.copyWith(isSubmitting: false, error: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'حدث خطأ غير متوقع: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> updateEntry(int entryId, Map<String, dynamic> data) async {
    state = state.copyWith(
      isSubmitting: true,
      error: null,
      successMessage: null,
    );
    try {
      // Include dynamic formData nested inside 'form_data' key
      final mergedData = Map<String, dynamic>.from(data);
      if (state.formData.isNotEmpty) {
        mergedData['form_data'] = state.formData;
      }

      await _repo.updateRegistryEntry(entryId, mergedData);

      // Clear draft on success
      _cacheBox?.delete(_draftKey);

      state = state.copyWith(
        isSubmitting: false,
        hasDraft: false,
        successMessage: 'تم تعديل القيد بنجاح',
        error: null,
      );
      return true;
    } on DioException catch (e) {
      String errorMsg = 'حدث خطأ أثناء تعديل القيد';
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      if (statusCode == 422) {
        if (responseData is Map<String, dynamic>) {
          if (responseData['errors'] != null) {
            final errors = responseData['errors'] as Map<String, dynamic>;
            final List<String> errorMessages = [];
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.addAll(value.map((e) => e.toString()));
              } else {
                errorMessages.add(value.toString());
              }
            });
            if (errorMessages.isNotEmpty) {
              errorMsg = errorMessages.join('\n');
            }
          } else if (responseData['message'] != null) {
            errorMsg = responseData['message'].toString();
          } else {
            errorMsg = 'يرجى التحقق من البيانات المدخلة';
          }
        } else {
          errorMsg = 'يرجى التحقق من البيانات المدخلة';
        }
      } else if (statusCode == 403) {
        errorMsg = 'لا تملك صلاحية لتعديل هذا القيد';
      } else if (statusCode == 409) {
        if (responseData is Map<String, dynamic>) {
          errorMsg = responseData['message']?.toString() ?? 'القيد مسجل مسبقاً';
        } else {
          errorMsg = 'القيد مسجل مسبقاً';
        }
      } else if (statusCode == 404) {
        errorMsg = 'القيد المطلوب غير موجود';
      } else if (statusCode == 500) {
        if (responseData is Map<String, dynamic>) {
          errorMsg = responseData['message']?.toString() ?? 'خطأ في الخادم';
        } else {
          errorMsg = 'خطأ في الخادم';
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = 'لا يوجد اتصال بالإنترنت';
      }
      state = state.copyWith(isSubmitting: false, error: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'حدث خطأ غير متوقع: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> loadFormFields(int contractTypeId) async {
    state = state.copyWith(isLoadingFields: true);

    // مفتاح الكاش ومفتاح الـ hash
    final cacheKey = 'fields_$contractTypeId';
    final hashKey = 'fields_hash_$contractTypeId';
    final cached = _cacheBox?.get(cacheKey);

    // ① عرض فوري من الكاش (إن وُجد)
    if (cached != null) {
      try {
        final fields = (cached as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        // الحفاظ على formData الحالية (مهم لوضع التعديل)
        final existingFormData = state.formData;
        state = state.copyWith(
          allFields: fields,
          isLoadingFields: false,
          filteredFields: [],
          formData: (existingFormData.isNotEmpty) ? existingFormData : {},
        );
        filterFields();
      } catch (_) {}
    }

    // ② جلب البيانات من الشبكة في الخلفية
    try {
      final fields = await _repo.getFormFields(contractTypeId);

      // ③ حساب hash للبيانات الجديدة ومقارنته بالقديم
      final newHash = fields.toString().hashCode.toString();
      final oldHash = _cacheBox?.get(hashKey) as String?;

      if (newHash != oldHash) {
        // تغيير مُكتشَف → تحديث الكاش والـ state
        _cacheBox?.put(cacheKey, fields);
        _cacheBox?.put(hashKey, newHash);

        // الحفاظ على formData الحالية (مهم لوضع التعديل)
        final existingData = state.formData;
        state = state.copyWith(
          allFields: fields,
          isLoadingFields: false,
          filteredFields: [],
          formData: (existingData.isNotEmpty) ? existingData : {},
        );
        filterFields();
      } else {
        // لا تغيير → إيقاف التحميل فقط دون إعادة بناء
        if (state.isLoadingFields) {
          state = state.copyWith(isLoadingFields: false);
        }
      }
    } catch (e) {
      // فشل الشبكة → إبقاء الكاش إن وُجد
      if (cached == null) {
        state = state.copyWith(
          isLoadingFields: false,
          allFields: [],
          filteredFields: [],
        );
      } else {
        state = state.copyWith(isLoadingFields: false);
      }
    }
  }

  void filterFields({String? subtype1, String? subtype2}) {
    if (state.allFields.isEmpty) {
      state = state.copyWith(filteredFields: []);
      return;
    }

    final filtered = state.allFields.where((field) {
      final fSub1 = field['subtype_1'];
      final fSub2 = field['subtype_2'];

      if (fSub1 == null && fSub2 == null) return true;

      if (fSub1 != null) {
        if (subtype1 == null) return false;
        if (fSub1.toString() != subtype1.toString()) return false;
      }

      if (fSub2 != null) {
        if (subtype2 == null) return false;
        if (fSub2.toString() != subtype2.toString()) return false;
      }

      return true;
    }).toList();

    state = state.copyWith(filteredFields: filtered);
  }

  void updateFormData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(state.formData);
    newData[key] = value;
    state = state.copyWith(formData: newData);
  }

  void setFormData(Map<String, dynamic> data) {
    state = state.copyWith(formData: Map<String, dynamic>.from(data));
  }

  /// Save current form data as a draft
  Future<void> saveDraft(Map<String, dynamic> formData) async {
    final allData = Map<String, dynamic>.from(formData);
    allData.addAll(state.formData);
    allData['_draft_timestamp'] = DateTime.now().toIso8601String();

    await _cacheBox?.put(_draftKey, json.encode(allData));
    state = state.copyWith(hasDraft: true);
  }

  /// Load saved draft
  Map<String, dynamic>? loadDraft() {
    final draftJson = _cacheBox?.get(_draftKey);
    if (draftJson == null) return null;
    try {
      return json.decode(draftJson as String) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Discard saved draft
  Future<void> discardDraft() async {
    await _cacheBox?.delete(_draftKey);
    state = state.copyWith(hasDraft: false);
  }
}

final addEntryProvider =
    StateNotifierProvider.autoDispose<AddEntryNotifier, AddEntryState>((ref) {
      final repo = ref.watch(adminRepositoryProvider);
      return AddEntryNotifier(repo);
    });
