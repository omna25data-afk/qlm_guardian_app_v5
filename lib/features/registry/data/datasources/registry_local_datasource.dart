import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import 'package:qlm_guardian_app_v5/features/system/data/models/registry_entry_sections.dart';

abstract class RegistryLocalDataSource {
  Future<List<RegistryEntrySections>> getAllEntries();
  Future<int> insertEntry(RegistryEntrySections entry);
  Future<void> updateEntry(RegistryEntrySections entry);
  Future<RegistryEntrySections?> getEntryByUuid(String uuid);
}

class RegistryLocalDataSourceImpl implements RegistryLocalDataSource {
  final AppDatabase _db;

  RegistryLocalDataSourceImpl(this._db);

  @override
  Future<List<RegistryEntrySections>> getAllEntries() async {
    final entries = await _db.getAllEntries();
    return entries.map(_mapToModel).toList();
  }

  @override
  Future<RegistryEntrySections?> getEntryByUuid(String uuid) async {
    final entry = await _db.getEntryByUuid(uuid);
    return entry != null ? _mapToModel(entry) : null;
  }

  @override
  Future<int> insertEntry(RegistryEntrySections entry) {
    final companion = _mapToCompanion(entry);
    return _db.insertEntry(companion);
  }

  @override
  Future<void> updateEntry(RegistryEntrySections entry) {
    final companion = _mapToCompanion(entry);
    return _db.updateEntry(companion);
  }

  RegistryEntrySections _mapToModel(RegistryEntry e) {
    // Reconstruct sections from flat DB row
    // Note: Some fields might be missing in DB, using defaults
    return RegistryEntrySections(
      id: e.id,
      uuid: e.uuid,
      remoteId: e.remoteId,
      basicInfo: RegistryBasicInfo(
        serialNumber: e.serialNumber ?? 0,
        hijriYear: e.hijriYear ?? 0,
        subject: e.subject,
        content: e.content,
        registerNumber: e.registerNumber,
        firstPartyName: '', // Not in DB yet? Check Parties table usually...
        secondPartyName: '', // Not in DB yet?
        contractTypeId: e.contractTypeId,
      ),
      writerInfo: const RegistryWriterInfo(
        writerType: 'guardian',
        writerName: '',
      ), // Defaults
      documentInfo: RegistryDocumentInfo(
        docHijriDate: e.hijriDate,
        documentHijriDate: e.hijriDate,
        docGregorianDate: e.date?.toIso8601String(),
        documentGregorianDate: e.date?.toIso8601String(),
      ),
      financialInfo: RegistryFinancialInfo(
        feeAmount: 0, // Not in DB
        supportAmount: 0,
        sustainabilityAmount: 0,
        totalAmount: e.totalAmount,
        paidAmount: e.paidAmount,
        penaltyAmount: 0,
      ),
      guardianInfo: RegistryGuardianInfo(
        guardianId: e.guardianId,
        guardianRecordBookId: e.recordBookId, // Assuming relation
      ),
      statusInfo: RegistryStatusInfo(
        status: e.status,
        deliveryStatus: 'preserved', // Default
      ),
      metadata: RegistryMetadata(
        createdBy: 0,
        createdAt: e.createdAt.toIso8601String(),
        updatedAt: e.lastUpdated?.toIso8601String(),
      ),
      formData: {}, // DB doesn't store this yet
    );
  }

  RegistryEntriesCompanion _mapToCompanion(RegistryEntrySections entry) {
    return RegistryEntriesCompanion(
      uuid: Value(entry.uuid ?? ''),
      remoteId: Value(entry.remoteId),
      guardianId: Value(entry.guardianInfo.guardianId),
      // recordBookId: Value(entry.guardianInfo.guardianRecordBookId), // If column exists
      contractTypeId: Value(entry.basicInfo.contractTypeId),
      status: Value(entry.statusInfo.status),
      serialNumber: Value(entry.basicInfo.serialNumber),
      registerNumber: Value(entry.basicInfo.registerNumber),
      date: entry.documentInfo.documentGregorianDate != null
          ? Value(DateTime.tryParse(entry.documentInfo.documentGregorianDate!))
          : const Value.absent(),
      hijriYear: Value(entry.basicInfo.hijriYear),
      hijriDate: Value(entry.documentInfo.documentHijriDate),
      subject: Value(entry.basicInfo.subject),
      content: Value(entry.basicInfo.content),
      totalAmount: Value(entry.financialInfo.totalAmount),
      paidAmount: Value(entry.financialInfo.paidAmount),
      createdAt: entry.metadata.createdAt != null
          ? Value(
              DateTime.tryParse(entry.metadata.createdAt!) ?? DateTime.now(),
            )
          : const Value.absent(),
    );
  }
}
