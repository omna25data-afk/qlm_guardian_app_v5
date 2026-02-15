import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/contract_type_model.dart';
import '../providers/registry_provider.dart';

final contractTypesProvider = FutureProvider<List<ContractTypeModel>>((
  ref,
) async {
  final repository = ref.watch(registryRepositoryProvider);
  return repository.getContractTypes();
});

final contractTypeMapProvider = Provider<Map<int, ContractTypeModel>>((ref) {
  final typesAsync = ref.watch(contractTypesProvider);
  return typesAsync.maybeWhen(
    data: (types) => {for (var type in types) type.id: type},
    orElse: () => {},
  );
});
