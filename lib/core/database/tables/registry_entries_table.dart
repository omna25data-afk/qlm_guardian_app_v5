import 'package:drift/drift.dart';

class RegistryEntries extends Table {
  // Identifiers
  IntColumn get id => integer().autoIncrement()(); // Local ID
  TextColumn get uuid => text().unique()(); // Global UUID for sync
  IntColumn get remoteId => integer().nullable()(); // ID from Backend

  // Metadata
  IntColumn get guardianId => integer().nullable()();
  IntColumn get recordBookId => integer().nullable()();
  IntColumn get contractTypeId => integer().nullable()();

  // Status & Numbers
  TextColumn get status => text().withDefault(
    const Constant('draft'),
  )(); // draft, pending, documented...
  IntColumn get serialNumber => integer().nullable()();
  TextColumn get registerNumber => text().nullable()();

  // Dates
  DateTimeColumn get date => dateTime().nullable()();
  IntColumn get hijriYear => integer().nullable()();
  TextColumn get hijriDate => text().nullable()();

  // Content
  TextColumn get subject => text().nullable()(); // subject/title
  TextColumn get content => text().nullable()(); // full text content

  // Financial
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();

  // Sync Status
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(Constant(DateTime.now()))(); // Local creation time
}

class Parties extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get registryEntryId =>
      integer().references(RegistryEntries, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()();
  TextColumn get type => text()(); // first_party, second_party, witness...
  TextColumn get nationalId => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}
