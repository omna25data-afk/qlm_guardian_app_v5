import 'package:drift/drift.dart';
import 'connection/connection.dart' as connection;
import 'tables/registry_entries_table.dart';
import 'tables/record_books_table.dart';
import 'tables/sync_queue_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [RegistryEntries, Parties, RecordBooks, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Registry Entries DAO
  Future<List<RegistryEntry>> getAllEntries() => select(registryEntries).get();

  Future<List<RegistryEntry>> getEntriesForGuardian(int guardianId) => (select(
    registryEntries,
  )..where((tbl) => tbl.guardianId.equals(guardianId))).get();

  Future<RegistryEntry?> getEntryByUuid(String uuid) => (select(
    registryEntries,
  )..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

  Future<int> insertEntry(RegistryEntriesCompanion entry) =>
      into(registryEntries).insert(entry);

  Future<bool> updateEntry(RegistryEntriesCompanion entry) =>
      update(registryEntries).replace(entry);

  Future<int> deleteEntry(String uuid) =>
      (delete(registryEntries)..where((tbl) => tbl.uuid.equals(uuid))).go();

  // Parties DAO
  Future<List<Party>> getPartiesForEntry(int entryId) => (select(
    parties,
  )..where((tbl) => tbl.registryEntryId.equals(entryId))).get();

  Future<int> insertParty(PartiesCompanion party) =>
      into(parties).insert(party);

  Future<void> deletePartiesForEntry(int entryId) => (delete(
    parties,
  )..where((tbl) => tbl.registryEntryId.equals(entryId))).go();

  // Transaction: Create full entry with parties
  Future<void> createEntryWithParties(
    RegistryEntriesCompanion entry,
    List<PartiesCompanion> entryParties,
  ) {
    return transaction(() async {
      final entryId = await into(registryEntries).insert(entry);

      for (final party in entryParties) {
        await into(
          parties,
        ).insert(party.copyWith(registryEntryId: Value(entryId)));
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return await connection.openConnection();
  });
}
