import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../records/data/models/record_book.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../../data/models/contract_type_model.dart';
import '../../data/repositories/registry_repository.dart';
import '../providers/registry_provider.dart' show registryRepositoryProvider;

/// State for Add Registry Entry (Guardian)
class AddRegistryEntryState {
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? success;

  // Step 0: Contract Types
  final List<ContractTypeModel> contractTypes;
  final ContractTypeModel? selectedType;
  final bool isLoadingTypes;

  // Subtypes
  final List<Map<String, dynamic>> subtypes1;
  final List<Map<String, dynamic>> subtypes2;
  final String? selectedSubtype1;
  final String? selectedSubtype2;
  final bool isLoadingSubtypes1;
  final bool isLoadingSubtypes2;

  // Dynamic Form Fields
  final List<Map<String, dynamic>> allFields;
  final List<Map<String, dynamic>> filteredFields;
  final bool isLoadingFields;

  // Form Data
  final Map<String, dynamic> formData;

  // Record Books
  final List<RecordBook> allRecordBooks;
  final List<RecordBook> filteredRecordBooks;
  final RecordBook? selectedRecordBook;
  final bool isLoadingRecordBooks;

  // Delivery
  final String deliveryStatus;
  final DateTime? deliveryDate;

  // Sequential Mode
  final bool isSequentialMode;

  // Step tracking
  final int currentStep;
  final bool isFormLoading;

  // Attachment
  final String? attachmentPath;

  // Record Book Selection
  final int? selectedRecordBookId;

  const AddRegistryEntryState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.success,
    this.contractTypes = const [],
    this.selectedType,
    this.isLoadingTypes = true,
    this.subtypes1 = const [],
    this.subtypes2 = const [],
    this.selectedSubtype1,
    this.selectedSubtype2,
    this.isLoadingSubtypes1 = false,
    this.isLoadingSubtypes2 = false,
    this.allFields = const [],
    this.filteredFields = const [],
    this.isLoadingFields = false,
    this.formData = const {},
    this.allRecordBooks = const [],
    this.filteredRecordBooks = const [],
    this.selectedRecordBook,
    this.isLoadingRecordBooks = false,
    this.deliveryStatus = 'preserved',
    this.deliveryDate,
    this.isSequentialMode = false,
    this.currentStep = 0,
    this.isFormLoading = false,
    this.attachmentPath,
    this.selectedRecordBookId,
  });

  AddRegistryEntryState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    String? success,
    List<ContractTypeModel>? contractTypes,
    ContractTypeModel? selectedType,
    bool clearSelectedType = false,
    bool? isLoadingTypes,
    List<Map<String, dynamic>>? subtypes1,
    List<Map<String, dynamic>>? subtypes2,
    String? selectedSubtype1,
    String? selectedSubtype2,
    bool clearSubtype1 = false,
    bool clearSubtype2 = false,
    bool? isLoadingSubtypes1,
    bool? isLoadingSubtypes2,
    List<Map<String, dynamic>>? allFields,
    List<Map<String, dynamic>>? filteredFields,
    bool? isLoadingFields,
    Map<String, dynamic>? formData,
    List<RecordBook>? allRecordBooks,
    List<RecordBook>? filteredRecordBooks,
    RecordBook? selectedRecordBook,
    bool clearSelectedRecordBook = false,
    bool? isLoadingRecordBooks,
    String? deliveryStatus,
    DateTime? deliveryDate,
    bool? isSequentialMode,
    int? currentStep,
    bool? isFormLoading,
    String? attachmentPath,
    int? selectedRecordBookId,
  }) {
    return AddRegistryEntryState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      success: success,
      contractTypes: contractTypes ?? this.contractTypes,
      selectedType: clearSelectedType
          ? null
          : (selectedType ?? this.selectedType),
      isLoadingTypes: isLoadingTypes ?? this.isLoadingTypes,
      subtypes1: subtypes1 ?? this.subtypes1,
      subtypes2: subtypes2 ?? this.subtypes2,
      selectedSubtype1: clearSubtype1
          ? null
          : (selectedSubtype1 ?? this.selectedSubtype1),
      selectedSubtype2: clearSubtype2
          ? null
          : (selectedSubtype2 ?? this.selectedSubtype2),
      isLoadingSubtypes1: isLoadingSubtypes1 ?? this.isLoadingSubtypes1,
      isLoadingSubtypes2: isLoadingSubtypes2 ?? this.isLoadingSubtypes2,
      allFields: allFields ?? this.allFields,
      filteredFields: filteredFields ?? this.filteredFields,
      isLoadingFields: isLoadingFields ?? this.isLoadingFields,
      formData: formData ?? this.formData,
      allRecordBooks: allRecordBooks ?? this.allRecordBooks,
      filteredRecordBooks: filteredRecordBooks ?? this.filteredRecordBooks,
      selectedRecordBook: clearSelectedRecordBook
          ? null
          : (selectedRecordBook ?? this.selectedRecordBook),
      isLoadingRecordBooks: isLoadingRecordBooks ?? this.isLoadingRecordBooks,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      isSequentialMode: isSequentialMode ?? this.isSequentialMode,
      currentStep: currentStep ?? this.currentStep,
      isFormLoading: isFormLoading ?? this.isFormLoading,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      selectedRecordBookId: selectedRecordBookId ?? this.selectedRecordBookId,
    );
  }
}

class AddRegistryEntryNotifier extends StateNotifier<AddRegistryEntryState> {
  final RegistryRepository _repository;
  final ApiClient _apiClient;

  AddRegistryEntryNotifier(this._repository, this._apiClient)
    : super(const AddRegistryEntryState()) {
    _loadContractTypes();
  }

  Future<void> _loadContractTypes() async {
    state = state.copyWith(isLoadingTypes: true);
    try {
      final types = await _repository.getContractTypes();
      state = state.copyWith(contractTypes: types, isLoadingTypes: false);
    } catch (e) {
      state = state.copyWith(
        isLoadingTypes: false,
        error: 'خطأ في تحميل أنواع العقود: $e',
      );
    }
  }

  void selectContractType(ContractTypeModel type) {
    state = state.copyWith(
      selectedType: type,
      formData: {},
      allFields: [],
      filteredFields: [],
      subtypes1: [],
      subtypes2: [],
      clearSubtype1: true,
      clearSubtype2: true,
      clearSelectedRecordBook: true,
    );

    _fetchSubtypes(type.id, level: 1);
    loadFormFields(type.id);
    _fetchRecordBooks();
  }

  Future<void> _fetchSubtypes(
    int contractTypeId, {
    required int level,
    String? parentCode,
  }) async {
    state = state.copyWith(
      isLoadingSubtypes1: level == 1 ? true : null,
      isLoadingSubtypes2: level == 2 ? true : null,
    );

    try {
      String url = ApiEndpoints.contractSubtypes(contractTypeId);
      if (parentCode != null) {
        url += '?parent_code=$parentCode';
      }

      final response = await _apiClient.get(url);

      dynamic rawData = response.data;
      if (rawData is Map) {
        rawData = rawData['data'];
      }

      final list = (rawData as List? ?? []);
      final data = list
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      if (level == 1) {
        state = state.copyWith(subtypes1: data, isLoadingSubtypes1: false);
      } else {
        state = state.copyWith(subtypes2: data, isLoadingSubtypes2: false);
      }
    } catch (_) {
      state = state.copyWith(
        isLoadingSubtypes1: level == 1 ? false : null,
        isLoadingSubtypes2: level == 2 ? false : null,
      );
    }
  }

  void selectSubtype1(String? code) {
    state = state.copyWith(
      selectedSubtype1: code,
      clearSubtype2: true,
      subtypes2: [],
    );

    if (code != null && state.selectedType != null) {
      _fetchSubtypes(state.selectedType!.id, level: 2, parentCode: code);
    }

    filterFields();
  }

  void selectSubtype2(String? code) {
    state = state.copyWith(selectedSubtype2: code);
    filterFields();
  }

  void filterFields({String? subtype1, String? subtype2}) {
    if (subtype1 != null) state = state.copyWith(selectedSubtype1: subtype1);
    if (subtype2 != null) state = state.copyWith(selectedSubtype2: subtype2);

    if (state.allFields.isEmpty) {
      state = state.copyWith(filteredFields: []);
      return;
    }

    int? selectedSubtype1Id;
    if (state.selectedSubtype1 != null) {
      final sub1 = state.subtypes1.firstWhere(
        (s) => s['code'] == state.selectedSubtype1,
        orElse: () => {},
      );
      selectedSubtype1Id = sub1['id'] as int?;
    }

    int? selectedSubtype2Id;
    if (state.selectedSubtype2 != null) {
      final sub2 = state.subtypes2.firstWhere(
        (s) => s['code'] == state.selectedSubtype2,
        orElse: () => {},
      );
      selectedSubtype2Id = sub2['id'] as int?;
    }

    final filtered = state.allFields.where((field) {
      final fSub1 = field['subtype_1'];
      final fSub2 = field['subtype_2'];

      if (fSub1 == null && fSub2 == null) return true;

      // Check Subtype 1
      if (fSub1 != null) {
        if (state.selectedSubtype1 == null) return false;
        final fSub1Str = fSub1.toString();
        final selectedSub1Str = state.selectedSubtype1.toString();
        final selectedSub1IdStr = selectedSubtype1Id?.toString();

        final matchesCode = fSub1Str == selectedSub1Str;
        final matchesId =
            selectedSub1IdStr != null && fSub1Str == selectedSub1IdStr;

        if (!matchesCode && !matchesId) return false;
      }

      // Check Subtype 2
      if (fSub2 != null) {
        if (state.selectedSubtype2 == null) return false;
        final fSub2Str = fSub2.toString();
        final selectedSub2Str = state.selectedSubtype2.toString();
        final selectedSub2IdStr = selectedSubtype2Id?.toString();

        final matchesCode = fSub2Str == selectedSub2Str;
        final matchesId =
            selectedSub2IdStr != null && fSub2Str == selectedSub2IdStr;

        if (!matchesCode && !matchesId) return false;
      }

      return true;
    }).toList();

    state = state.copyWith(filteredFields: filtered);
  }

  Future<void> loadFormFields(int contractTypeId) async {
    state = state.copyWith(isLoadingFields: true);

    try {
      final fields = await _repository.getFormFields(contractTypeId);

      final rawFields = fields
          .map(
            (f) => <String, dynamic>{
              'name': f.name,
              'label': f.label,
              'type': f.type,
              'required': f.required,
              'placeholder': f.placeholder,
              'helper_text': f.helperText,
              'options': f.options,
              'subtype_1': f.subtype1,
              'subtype_2': f.subtype2,
            },
          )
          .toList();

      state = state.copyWith(allFields: rawFields, isLoadingFields: false);
      filterFields();
    } catch (e) {
      state = state.copyWith(
        isLoadingFields: false,
        allFields: [],
        filteredFields: [],
      );
    }
  }

  Future<void> _fetchRecordBooks() async {
    state = state.copyWith(isLoadingRecordBooks: true);
    try {
      final response = await _apiClient.get(ApiEndpoints.guardianRecordBooks);
      final data = response.data;
      final items = data is Map
          ? (data['data'] as List? ?? [])
          : (data as List? ?? []);
      final books = items
          .map((x) => RecordBook.fromJson(Map<String, dynamic>.from(x)))
          .toList();

      // Filter by category (guardian can only use guardian_recording or both)
      final guardianBooks = books
          .where(
            (b) => b.category == 'guardian_recording' || b.category == 'both',
          )
          .toList();

      final filtered = state.selectedType != null
          ? guardianBooks
                .where((b) => b.contractTypeId == state.selectedType!.id)
                .toList()
          : guardianBooks;

      RecordBook? autoSelected;
      if (filtered.length == 1) {
        autoSelected = filtered.first;
      }

      state = state.copyWith(
        allRecordBooks: books,
        filteredRecordBooks: filtered,
        selectedRecordBook: autoSelected,
        isLoadingRecordBooks: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingRecordBooks: false);
    }
  }

  void selectRecordBook(RecordBook? book) {
    state = state.copyWith(
      selectedRecordBook: book,
      clearSelectedRecordBook: book == null,
    );
  }

  void updateFormData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(state.formData);
    newData[key] = value;
    state = state.copyWith(formData: newData);
  }

  void setDeliveryStatus(String status) {
    state = state.copyWith(deliveryStatus: status);
  }

  void setDeliveryDate(DateTime? date) {
    state = state.copyWith(deliveryDate: date);
  }

  void toggleSequentialMode(bool value) {
    state = state.copyWith(isSequentialMode: value);
  }

  void setAttachment(String? path) {
    state = state.copyWith(attachmentPath: path);
  }

  void setRecordBookId(int? id) {
    state = state.copyWith(selectedRecordBookId: id);
  }

  Future<bool> submitEntry({
    required String? manualBookNumber,
    required String? manualPageNumber,
    required String? manualEntryNumber,
    required DateTime documentDateGregorian,
    required String? documentDateHijri,
    required Map<String, String> textFieldValues,
  }) async {
    if (state.selectedType == null) return false;

    state = state.copyWith(isSubmitting: true, error: null, success: null);

    try {
      final mergedFormData = Map<String, dynamic>.from(state.formData);
      mergedFormData.addAll(textFieldValues);

      final subject = mergedFormData['subject'] as String?;
      final content = mergedFormData['content'] as String?;
      final notes =
          mergedFormData['content'] as String?; // Notes same as content?
      final registerNumber = mergedFormData['register_number'] as String?;
      final subtype1 = int.tryParse(
        mergedFormData['subtype_1']?.toString() ?? '',
      );
      final subtype2 = int.tryParse(
        mergedFormData['subtype_2']?.toString() ?? '',
      );

      final feeAmount =
          double.tryParse(mergedFormData['fee_amount']?.toString() ?? '') ??
          0.0;
      final penaltyAmount =
          double.tryParse(mergedFormData['penalty_amount']?.toString() ?? '') ??
          0.0;
      final authenticationFeeAmount =
          double.tryParse(
            mergedFormData['authentication_fee_amount']?.toString() ?? '',
          ) ??
          0.0;
      final transferFeeAmount =
          double.tryParse(
            mergedFormData['transfer_fee_amount']?.toString() ?? '',
          ) ??
          0.0;
      final otherFeeAmount =
          double.tryParse(
            mergedFormData['other_fee_amount']?.toString() ?? '',
          ) ??
          0.0;
      final exemptionReason = mergedFormData['exemption_reason'] as String?;

      final hijriYear = (mergedFormData['hijri_year'] is int)
          ? mergedFormData['hijri_year'] as int
          : int.tryParse(mergedFormData['hijri_year']?.toString() ?? '') ?? 0;

      final excludedKeys = [
        'subject',
        'content',
        'hijri_year',
        'register_number',
        'first_party_name',
        'second_party_name',
        'subtype_1',
        'subtype_2',
        'fee_amount',
        'penalty_amount',
        'authentication_fee_amount',
        'transfer_fee_amount',
        'other_fee_amount',
        'exemption_reason',
      ];

      final formDataMap = Map<String, dynamic>.from(mergedFormData)
        ..removeWhere((key, value) => excludedKeys.contains(key));

      final entry = RegistryEntrySections(
        id: 0,
        basicInfo: RegistryBasicInfo(
          serialNumber: 0,
          hijriYear: hijriYear,
          constraintTypeId: null,
          contractTypeId: state.selectedType!.id,
          firstPartyName:
              mergedFormData['first_party_name'] as String? ?? 'طرف أول',
          secondPartyName:
              mergedFormData['second_party_name'] as String? ?? 'طرف ثاني',
          subject: subject,
          content: content,
          subtype1: subtype1,
          subtype2: subtype2,
          registerNumber: registerNumber,
        ),
        writerInfo: const RegistryWriterInfo(
          writerType: 'guardian',
          writerName: '',
        ),
        documentInfo: RegistryDocumentInfo(
          docHijriDate: documentDateHijri,
          documentHijriDate: documentDateHijri,
          docGregorianDate: documentDateGregorian.toIso8601String(),
          documentGregorianDate: documentDateGregorian.toIso8601String(),
        ),
        financialInfo: RegistryFinancialInfo(
          feeAmount: feeAmount,
          supportAmount: 0,
          sustainabilityAmount: 0,
          penaltyAmount: penaltyAmount,
          authenticationFeeAmount: authenticationFeeAmount,
          transferFeeAmount: transferFeeAmount,
          otherFeeAmount: otherFeeAmount,
          exemptionReason: exemptionReason,
          totalAmount:
              feeAmount +
              penaltyAmount +
              authenticationFeeAmount +
              transferFeeAmount +
              otherFeeAmount,
        ),
        guardianInfo: RegistryGuardianInfo(
          guardianRecordBookNumber: int.tryParse(manualBookNumber ?? ''),
          guardianPageNumber: int.tryParse(manualPageNumber ?? ''),
          guardianEntryNumber: int.tryParse(manualEntryNumber ?? ''),
        ),
        statusInfo: RegistryStatusInfo(
          status: 'draft',
          deliveryStatus: 'preserved',
          notes: notes,
        ),
        metadata: RegistryMetadata(
          createdBy: 0,
          createdAt: DateTime.now().toIso8601String(),
        ),
        formData: formDataMap,
      );

      await _repository.createEntry(
        entry,
        attachmentPath: state.attachmentPath,
      );

      state = state.copyWith(
        isSubmitting: false,
        success: 'تم إضافة القيد بنجاح',
      );

      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: 'خطأ: $e');
      return false;
    }
  }

  void resetForNewEntry({int? nextEntryNumber}) {
    state = state.copyWith(formData: {}, error: null, success: null);
  }

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final addRegistryEntryProvider =
    StateNotifierProvider.autoDispose<
      AddRegistryEntryNotifier,
      AddRegistryEntryState
    >((ref) {
      final repo = ref.watch(registryRepositoryProvider);
      final apiClient = getIt<ApiClient>();
      return AddRegistryEntryNotifier(repo, apiClient);
    });
