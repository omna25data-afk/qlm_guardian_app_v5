import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/contract_type_model.dart';
import '../../data/models/form_field_model.dart';
import '../../data/models/registry_entry_model.dart';
import '../../data/repositories/registry_repository.dart';
import '../providers/registry_provider.dart';

// State class
class AddRegistryEntryState {
  final int currentStep;
  final bool isLoading;
  final String? error;

  // Step 1: Contract Type
  final List<ContractTypeModel> contractTypes;
  final ContractTypeModel? selectedType;

  // Step 2: Dynamic Form
  final List<FormFieldModel> formFields;
  final Map<String, dynamic>
  formData; // Stores values for dynamic fields + basic fields via keys
  final bool isFormLoading;

  // Step 3: Document
  final String? attachmentPath;

  // Step 4: Record Book Link (Optional)
  final int? selectedRecordBookId;

  const AddRegistryEntryState({
    this.currentStep = 0,
    this.isLoading = false,
    this.error,
    this.contractTypes = const [],
    this.selectedType,
    this.formFields = const [],
    this.formData = const {},
    this.isFormLoading = false,
    this.attachmentPath,
    this.selectedRecordBookId,
  });

  AddRegistryEntryState copyWith({
    int? currentStep,
    bool? isLoading,
    String? error,
    List<ContractTypeModel>? contractTypes,
    ContractTypeModel? selectedType,
    List<FormFieldModel>? formFields,
    Map<String, dynamic>? formData,
    bool? isFormLoading,
    String? attachmentPath,
    int? selectedRecordBookId,
  }) {
    return AddRegistryEntryState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error:
          error, // Reset error on change unless explicitly passed (logic in notifier)
      contractTypes: contractTypes ?? this.contractTypes,
      selectedType: selectedType ?? this.selectedType,
      formFields: formFields ?? this.formFields,
      formData: formData ?? this.formData,
      isFormLoading: isFormLoading ?? this.isFormLoading,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      selectedRecordBookId: selectedRecordBookId ?? this.selectedRecordBookId,
    );
  }
}

// Notifier
class AddRegistryEntryNotifier extends StateNotifier<AddRegistryEntryState> {
  final RegistryRepository _repository;

  AddRegistryEntryNotifier(this._repository)
    : super(const AddRegistryEntryState()) {
    _loadContractTypes();
  }

  Future<void> _loadContractTypes() async {
    state = state.copyWith(isLoading: true);
    try {
      final types = await _repository.getContractTypes();
      state = state.copyWith(contractTypes: types, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectContractType(ContractTypeModel type) {
    state = state.copyWith(
      selectedType: type,
      currentStep: 1,
      isFormLoading: true,
    );
    _loadFormFields(type.id);
  }

  Future<void> _loadFormFields(int typeId) async {
    try {
      final fields = await _repository.getFormFields(typeId);
      // Initialize default values
      final initialData = <String, dynamic>{};
      for (var f in fields) {
        if (f.defaultValue != null) {
          initialData[f.name] = f.defaultValue;
        }
      }
      state = state.copyWith(
        formFields: fields,
        formData: {...state.formData, ...initialData},
        isFormLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isFormLoading: false,
        error: 'فشل تحميل الحقول: $e',
      );
    }
  }

  void updateFormData(String key, dynamic value) {
    state = state.copyWith(formData: {...state.formData, key: value});
  }

  void setAttachment(String path) {
    state = state.copyWith(attachmentPath: path);
  }

  void setRecordBookId(int? id) {
    state = state.copyWith(selectedRecordBookId: id);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<bool> submit() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Basic validation
      if (state.selectedType == null) throw 'لم يتم اختيار نوع العقد';

      // Separate basic fields from extra attributes
      // Assuming basic fields are: subject, date, hijri_year, etc.
      // But for dynamic types, maybe simpler to just send mostly to extraAttributes
      // Except common ones like subject, hijri_year.

      // Let's assume the formFields includes everything, OR we map known keys.

      final extraData = Map<String, dynamic>.from(state.formData);

      // Extract known fields if present in formData
      // Or rely on backend to parse them from the dynamic body if they are at root.
      // The RegistryRemoteDataSource logic puts formData into 'data' or 'extraAttributes'.
      // createEntry logic: entry.toJson() + extraAttributes.

      // Let's construct a RegistryEntryModel
      // We assume basic fields (date, subject) are in formData with specific keys
      final subject =
          state.formData['subject'] ??
          state.selectedType!.name; // Default subject
      final dateStr = state.formData['date'] as String?;
      final date = dateStr != null
          ? DateTime.tryParse(dateStr)
          : DateTime.now();

      final entry = RegistryEntryModel(
        uuid: '', // Generated in repo
        status: 'pending', // or 'documented'
        subject: subject,
        date: date,
        hijriYear: state.formData['hijri_year'] is int
            ? state.formData['hijri_year']
            : int.tryParse(state.formData['hijri_year']?.toString() ?? ''),
        contractTypeId:
            state.selectedType!.id, // Need to add this to model or extra
        extraAttributes:
            extraData, // Pass all data as extras, backend filters what it needs
        // recordBookId: state.selectedRecordBookId, // If added to model
      );

      // Note: We are putting contractTypeId in extraAttributes via formData if we add it here
      extraData['contract_type_id'] = state.selectedType!.id;
      if (state.selectedRecordBookId != null) {
        extraData['record_book_id'] = state.selectedRecordBookId;
      }

      await _repository.createEntry(
        entry,
        attachmentPath: state.attachmentPath,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final addRegistryEntryProvider =
    StateNotifierProvider.autoDispose<
      AddRegistryEntryNotifier,
      AddRegistryEntryState
    >((ref) {
      final repository = ref.watch(registryRepositoryProvider);
      return AddRegistryEntryNotifier(repository);
    });
