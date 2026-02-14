import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import 'package:qlm_guardian_app_v5/features/registry/data/models/registry_entry_model.dart';

abstract class RegistryLocalDataSource {
  Future<List<RegistryEntryModel>> getAllEntries();
  Future<int> insertEntry(RegistryEntryModel entry);
  Future<void> updateEntry(RegistryEntryModel entry);
  Future<RegistryEntryModel?> getEntryByUuid(String uuid);
}

class RegistryLocalDataSourceImpl implements RegistryLocalDataSource {
  final AppDatabase _db;

  RegistryLocalDataSourceImpl(this._db);

  @override
  Future<List<RegistryEntryModel>> getAllEntries() async {
    final entries = await _db.getAllEntries();
    return entries.map(_mapToModel).toList();
  }

  @override
  Future<RegistryEntryModel?> getEntryByUuid(String uuid) async {
    final entry = await _db.getEntryByUuid(uuid);
    return entry != null ? _mapToModel(entry) : null;
  }

  @override
  Future<int> insertEntry(RegistryEntryModel entry) {
    final companion = _mapToCompanion(entry);
    return _db.insertEntry(companion);
  }

  @override
  Future<void> updateEntry(RegistryEntryModel entry) {
    final companion = _mapToCompanion(entry);
    return _db.updateEntry(companion);
  }

  RegistryEntryModel _mapToModel(RegistryEntry e) {
    return RegistryEntryModel(
      id: e.id,
      uuid: e.uuid,
      remoteId: e.remoteId,
      guardianId: e.guardianId,
      status: e.status,
      serialNumber: e.serialNumber,
      registerNumber: e.registerNumber,
      date: e.date,
      hijriYear: e.hijriYear,
      hijriDate: e.hijriDate,
      subject: e.subject,
      content: e.content,
      totalAmount: e.totalAmount,
      paidAmount: e.paidAmount,
      createdAt: e.createdAt,
    );
  }

  RegistryEntriesCompanion _mapToCompanion(RegistryEntryModel entry) {
    return RegistryEntriesCompanion(
      uuid: Value(entry.uuid ?? ''),
      remoteId: Value(entry.remoteId),
      guardianId: Value(entry.guardianId),
      status: Value(entry.status ?? 'draft'),
      serialNumber: Value(entry.serialNumber),
      registerNumber: Value(entry.registerNumber),
      date: Value(entry.date),
      hijriYear: Value(entry.hijriYear),
      hijriDate: Value(entry.hijriDate),
      subject: Value(entry.subject),
      content: Value(entry.content),
      totalAmount: Value(entry.totalAmount),
      paidAmount: Value(entry.paidAmount),
      createdAt: entry.createdAt != null
          ? Value(entry.createdAt!)
          : const Value.absent(),
    );
  }
}
