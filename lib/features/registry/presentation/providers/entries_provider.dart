import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';
import '../../data/repositories/registry_repository.dart';
import '../../../../core/di/injection.dart';

// Repository Provider
final registryRepositoryProvider = Provider<RegistryRepository>((ref) {
  return getIt<RegistryRepository>();
});

// ─── Filter Providers ─── //
final entrySearchQueryProvider = StateProvider<String>((ref) => '');
final entryStatusesFilterProvider = StateProvider<List<String>>((ref) => []);
final entryContractTypeFilterProvider = StateProvider<int?>((ref) => null);
final entryDateFromFilterProvider = StateProvider<DateTime?>((ref) => null);
final entryDateToFilterProvider = StateProvider<DateTime?>((ref) => null);
final entryDeliveryStatusFilterProvider = StateProvider<String?>((ref) => null);

// ─── Sort Provider ─── //
final entrySortProvider = StateProvider<String>((ref) => 'newest');

// ─── Raw Data Provider ─── //
final rawEntriesProvider = FutureProvider<List<RegistryEntrySections>>((
  ref,
) async {
  final repository = ref.watch(registryRepositoryProvider);
  return await repository.getEntries();
});

// ─── Filtered Data Provider ─── //
final filteredEntriesProvider =
    Provider<AsyncValue<List<RegistryEntrySections>>>((ref) {
      final entriesAsync = ref.watch(rawEntriesProvider);

      final searchQuery = ref
          .watch(entrySearchQueryProvider)
          .trim()
          .toLowerCase();
      final statusesFilter = ref.watch(entryStatusesFilterProvider);
      final contractTypeFilter = ref.watch(entryContractTypeFilterProvider);
      final dateFrom = ref.watch(entryDateFromFilterProvider);
      final dateTo = ref.watch(entryDateToFilterProvider);
      final deliveryStatus = ref.watch(entryDeliveryStatusFilterProvider);
      final sortOption = ref.watch(entrySortProvider);

      return entriesAsync.whenData((entries) {
        var filtered = entries.where((entry) {
          // 1. Status Filter
          if (statusesFilter.isNotEmpty &&
              !statusesFilter.contains(entry.statusInfo.status)) {
            return false;
          }

          // 2. Contract Type Filter
          if (contractTypeFilter != null &&
              entry.basicInfo.contractTypeId != contractTypeFilter) {
            return false;
          }

          // 3. Delivery Status Filter
          if (deliveryStatus != null &&
              entry.statusInfo.deliveryStatus != deliveryStatus) {
            return false;
          }

          // 4. Date Range Filter (Document Gregorian Date)
          if (dateFrom != null || dateTo != null) {
            final docDateStr = entry.documentInfo.documentGregorianDate;
            if (docDateStr == null || docDateStr.isEmpty) return false;

            final docDate = DateTime.tryParse(docDateStr);
            if (docDate == null) return false;

            if (dateFrom != null &&
                docDate.isBefore(
                  dateFrom.copyWith(
                    hour: 0,
                    minute: 0,
                    second: 0,
                    microsecond: 0,
                  ),
                )) {
              return false;
            }
            if (dateTo != null &&
                docDate.isAfter(
                  dateTo.copyWith(hour: 23, minute: 59, second: 59),
                )) {
              return false;
            }
          }

          // 5. Search Query Filter
          if (searchQuery.isNotEmpty) {
            final matchesSubject =
                entry.basicInfo.subject?.toLowerCase().contains(searchQuery) ??
                false;
            final matchesParty1 = entry.basicInfo.firstPartyName
                .toLowerCase()
                .contains(searchQuery);
            final matchesParty2 = entry.basicInfo.secondPartyName
                .toLowerCase()
                .contains(searchQuery);

            final matchesRegNum =
                entry.basicInfo.registerNumber?.toString().contains(
                  searchQuery,
                ) ??
                false;
            final matchesSerialNum = entry.basicInfo.serialNumber
                .toString()
                .contains(searchQuery);
            final matchesGuardianNum =
                entry.guardianInfo.guardianEntryNumber?.toString().contains(
                  searchQuery,
                ) ??
                false;
            final matchesDocNum =
                entry.documentInfo.docEntryNumber?.toString().contains(
                  searchQuery,
                ) ??
                false;

            return matchesSubject ||
                matchesParty1 ||
                matchesParty2 ||
                matchesRegNum ||
                matchesSerialNum ||
                matchesGuardianNum ||
                matchesDocNum;
          }

          return true;
        }).toList();

        // ─── Sort Data ─── //
        switch (sortOption) {
          case 'newest':
            filtered.sort(
              (a, b) => (b.metadata.createdAt ?? '').compareTo(
                a.metadata.createdAt ?? '',
              ),
            );
            break;
          case 'oldest':
            filtered.sort(
              (a, b) => (a.metadata.createdAt ?? '').compareTo(
                b.metadata.createdAt ?? '',
              ),
            );
            break;
          case 'highest_amount':
            filtered.sort(
              (a, b) => b.financialInfo.totalAmount.compareTo(
                a.financialInfo.totalAmount,
              ),
            );
            break;
          case 'lowest_amount':
            filtered.sort(
              (a, b) => a.financialInfo.totalAmount.compareTo(
                b.financialInfo.totalAmount,
              ),
            );
            break;
          case 'newest_doc_date':
            filtered.sort(
              (a, b) => (b.documentInfo.documentGregorianDate ?? '').compareTo(
                a.documentInfo.documentGregorianDate ?? '',
              ),
            );
            break;
          case 'oldest_doc_date':
            filtered.sort(
              (a, b) => (a.documentInfo.documentGregorianDate ?? '').compareTo(
                b.documentInfo.documentGregorianDate ?? '',
              ),
            );
            break;
          case 'status':
            filtered.sort(
              (a, b) => a.statusInfo.status.compareTo(b.statusInfo.status),
            );
            break;
          case 'contract_type':
            filtered.sort(
              (a, b) => (a.basicInfo.contractTypeId ?? 0).compareTo(
                b.basicInfo.contractTypeId ?? 0,
              ),
            );
            break;
        }

        return filtered;
      });
    });
