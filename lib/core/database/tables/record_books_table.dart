import 'package:drift/drift.dart';

class RecordBooks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get guardianId => integer().nullable()();
  TextColumn get uuid => text().unique()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get serialNumber => text().nullable()();
  IntColumn get currentNumber => integer().withDefault(const Constant(0))();
  IntColumn get totalPages => integer().withDefault(const Constant(50))();
  IntColumn get usedPages => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
