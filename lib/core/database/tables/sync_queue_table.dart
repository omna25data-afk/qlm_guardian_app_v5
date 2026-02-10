import 'package:drift/drift.dart';

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()(); // INSERT, UPDATE, DELETE
  TextColumn get targetTable => text()(); // 'registry_entries', 'record_books'
  TextColumn get recordId => text()(); // UUID
  TextColumn get payload => text().nullable()(); // JSON
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
}
