import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/form_field_config_model.dart';
import '../../data/datasources/field_management_remote_datasource.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';

part 'field_management_provider.g.dart';

class FieldManagementState {
  final Map<String, List<FormFieldConfigModel>> groupedFields;
  final List<String> availableContracts;
  final List<String> availableTables;
  final String? activeContract;
  final String? activeTable;

  FieldManagementState({
    required this.groupedFields,
    this.availableContracts = const [],
    this.availableTables = const [],
    this.activeContract,
    this.activeTable,
  });

  FieldManagementState copyWith({
    Map<String, List<FormFieldConfigModel>>? groupedFields,
    List<String>? availableContracts,
    List<String>? availableTables,
    String? activeContract,
    String? activeTable,
    bool clearContract = false,
    bool clearTable = false,
  }) {
    return FieldManagementState(
      groupedFields: groupedFields ?? this.groupedFields,
      availableContracts: availableContracts ?? this.availableContracts,
      availableTables: availableTables ?? this.availableTables,
      activeContract: clearContract
          ? null
          : (activeContract ?? this.activeContract),
      activeTable: clearTable ? null : (activeTable ?? this.activeTable),
    );
  }
}

@riverpod
class FieldManagement extends _$FieldManagement {
  late final FieldManagementRemoteDataSource _dataSource;
  List<FormFieldConfigModel> _allFields = [];

  @override
  FutureOr<FieldManagementState> build() async {
    _dataSource = FieldManagementRemoteDataSource(getIt<ApiClient>());
    return _fetchFields();
  }

  Future<FieldManagementState> _fetchFields() async {
    final response = await _dataSource.fetchFields();
    final rawData = response['data'] as List;
    _allFields = rawData.map((e) => FormFieldConfigModel.fromJson(e)).toList();

    final contracts = _allFields.map((e) => e.contractTypeName).toSet().toList()
      ..sort();
    final tables =
        _allFields.map((e) => e.tableSchemaName ?? 'غير محدد').toSet().toList()
          ..sort();

    return FieldManagementState(
      groupedFields: _groupFields(_allFields),
      availableContracts: contracts,
      availableTables: tables,
    );
  }

  Map<String, List<FormFieldConfigModel>> _groupFields(
    List<FormFieldConfigModel> fields,
  ) {
    Map<String, List<FormFieldConfigModel>> grouped = {};
    for (var field in fields) {
      final groupName =
          '${field.contractTypeName} - ${field.sectionName ?? "عام"}';
      if (!grouped.containsKey(groupName)) {
        grouped[groupName] = [];
      }
      grouped[groupName]!.add(field);
    }
    return grouped;
  }

  void setFilter({String? contract, String? table}) {
    if (!state.hasValue) return;

    final currentState = state.value!;
    final newContract = contract == 'All'
        ? null
        : (contract ?? currentState.activeContract);
    final newTable = table == 'All'
        ? null
        : (table ?? currentState.activeTable);

    var filtered = _allFields;
    if (newContract != null) {
      filtered = filtered
          .where((f) => f.contractTypeName == newContract)
          .toList();
    }
    if (newTable != null) {
      filtered = filtered
          .where((f) => (f.tableSchemaName ?? 'غير محدد') == newTable)
          .toList();
    }

    state = AsyncValue.data(
      currentState.copyWith(
        groupedFields: _groupFields(filtered),
        activeContract: newContract,
        activeTable: newTable,
        clearContract: contract == 'All',
        clearTable: table == 'All',
      ),
    );
  }

  Future<void> loadFields() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFields());
  }

  Future<bool> updateField(int id, Map<String, dynamic> updateData) async {
    try {
      await _dataSource.updateField(id, updateData);

      if (state.hasValue) {
        final index = _allFields.indexWhere((f) => f.id == id);

        if (index != -1) {
          final oldField = _allFields[index];
          _allFields[index] = FormFieldConfigModel(
            id: oldField.id,
            tableSchemaId: oldField.tableSchemaId,
            tableSchemaName: oldField.tableSchemaName,
            contractTypeId: oldField.contractTypeId,
            contractTypeName: oldField.contractTypeName,
            columnName: oldField.columnName,
            fieldLabel: updateData['field_label'] ?? oldField.fieldLabel,
            fieldType: oldField.fieldType,
            isRequired: updateData['is_required'] ?? oldField.isRequired,
            isVisible: updateData['is_visible'] ?? oldField.isVisible,
            isDisabled: updateData['is_disabled'] ?? oldField.isDisabled,
            sectionName: oldField.sectionName,
            sectionOrder: oldField.sectionOrder,
            sortOrder: oldField.sortOrder,
          );

          // Apply current filters again after update
          setFilter();
          return true;
        }
      }
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
