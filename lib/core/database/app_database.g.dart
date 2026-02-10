// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RegistryEntriesTable extends RegistryEntries
    with TableInfo<$RegistryEntriesTable, RegistryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guardianIdMeta = const VerificationMeta(
    'guardianId',
  );
  @override
  late final GeneratedColumn<int> guardianId = GeneratedColumn<int>(
    'guardian_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordBookIdMeta = const VerificationMeta(
    'recordBookId',
  );
  @override
  late final GeneratedColumn<int> recordBookId = GeneratedColumn<int>(
    'record_book_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractTypeIdMeta = const VerificationMeta(
    'contractTypeId',
  );
  @override
  late final GeneratedColumn<int> contractTypeId = GeneratedColumn<int>(
    'contract_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<int> serialNumber = GeneratedColumn<int>(
    'serial_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _registerNumberMeta = const VerificationMeta(
    'registerNumber',
  );
  @override
  late final GeneratedColumn<String> registerNumber = GeneratedColumn<String>(
    'register_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hijriYearMeta = const VerificationMeta(
    'hijriYear',
  );
  @override
  late final GeneratedColumn<int> hijriYear = GeneratedColumn<int>(
    'hijri_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hijriDateMeta = const VerificationMeta(
    'hijriDate',
  );
  @override
  late final GeneratedColumn<String> hijriDate = GeneratedColumn<String>(
    'hijri_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: Constant(DateTime.now()),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    remoteId,
    guardianId,
    recordBookId,
    contractTypeId,
    status,
    serialNumber,
    registerNumber,
    date,
    hijriYear,
    hijriDate,
    subject,
    content,
    totalAmount,
    paidAmount,
    isSynced,
    isDeleted,
    lastUpdated,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registry_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegistryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('guardian_id')) {
      context.handle(
        _guardianIdMeta,
        guardianId.isAcceptableOrUnknown(data['guardian_id']!, _guardianIdMeta),
      );
    }
    if (data.containsKey('record_book_id')) {
      context.handle(
        _recordBookIdMeta,
        recordBookId.isAcceptableOrUnknown(
          data['record_book_id']!,
          _recordBookIdMeta,
        ),
      );
    }
    if (data.containsKey('contract_type_id')) {
      context.handle(
        _contractTypeIdMeta,
        contractTypeId.isAcceptableOrUnknown(
          data['contract_type_id']!,
          _contractTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    }
    if (data.containsKey('register_number')) {
      context.handle(
        _registerNumberMeta,
        registerNumber.isAcceptableOrUnknown(
          data['register_number']!,
          _registerNumberMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('hijri_year')) {
      context.handle(
        _hijriYearMeta,
        hijriYear.isAcceptableOrUnknown(data['hijri_year']!, _hijriYearMeta),
      );
    }
    if (data.containsKey('hijri_date')) {
      context.handle(
        _hijriDateMeta,
        hijriDate.isAcceptableOrUnknown(data['hijri_date']!, _hijriDateMeta),
      );
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_id'],
      ),
      guardianId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}guardian_id'],
      ),
      recordBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_book_id'],
      ),
      contractTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contract_type_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial_number'],
      ),
      registerNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}register_number'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      ),
      hijriYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hijri_year'],
      ),
      hijriDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hijri_date'],
      ),
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid_amount'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RegistryEntriesTable createAlias(String alias) {
    return $RegistryEntriesTable(attachedDatabase, alias);
  }
}

class RegistryEntry extends DataClass implements Insertable<RegistryEntry> {
  final int id;
  final String uuid;
  final int? remoteId;
  final int? guardianId;
  final int? recordBookId;
  final int? contractTypeId;
  final String status;
  final int? serialNumber;
  final String? registerNumber;
  final DateTime? date;
  final int? hijriYear;
  final String? hijriDate;
  final String? subject;
  final String? content;
  final double totalAmount;
  final double paidAmount;
  final bool isSynced;
  final bool isDeleted;
  final DateTime? lastUpdated;
  final DateTime createdAt;
  const RegistryEntry({
    required this.id,
    required this.uuid,
    this.remoteId,
    this.guardianId,
    this.recordBookId,
    this.contractTypeId,
    required this.status,
    this.serialNumber,
    this.registerNumber,
    this.date,
    this.hijriYear,
    this.hijriDate,
    this.subject,
    this.content,
    required this.totalAmount,
    required this.paidAmount,
    required this.isSynced,
    required this.isDeleted,
    this.lastUpdated,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    if (!nullToAbsent || guardianId != null) {
      map['guardian_id'] = Variable<int>(guardianId);
    }
    if (!nullToAbsent || recordBookId != null) {
      map['record_book_id'] = Variable<int>(recordBookId);
    }
    if (!nullToAbsent || contractTypeId != null) {
      map['contract_type_id'] = Variable<int>(contractTypeId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<int>(serialNumber);
    }
    if (!nullToAbsent || registerNumber != null) {
      map['register_number'] = Variable<String>(registerNumber);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || hijriYear != null) {
      map['hijri_year'] = Variable<int>(hijriYear);
    }
    if (!nullToAbsent || hijriDate != null) {
      map['hijri_date'] = Variable<String>(hijriDate);
    }
    if (!nullToAbsent || subject != null) {
      map['subject'] = Variable<String>(subject);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RegistryEntriesCompanion toCompanion(bool nullToAbsent) {
    return RegistryEntriesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      guardianId: guardianId == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianId),
      recordBookId: recordBookId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordBookId),
      contractTypeId: contractTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(contractTypeId),
      status: Value(status),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      registerNumber: registerNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(registerNumber),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      hijriYear: hijriYear == null && nullToAbsent
          ? const Value.absent()
          : Value(hijriYear),
      hijriDate: hijriDate == null && nullToAbsent
          ? const Value.absent()
          : Value(hijriDate),
      subject: subject == null && nullToAbsent
          ? const Value.absent()
          : Value(subject),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      totalAmount: Value(totalAmount),
      paidAmount: Value(paidAmount),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
      createdAt: Value(createdAt),
    );
  }

  factory RegistryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistryEntry(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      guardianId: serializer.fromJson<int?>(json['guardianId']),
      recordBookId: serializer.fromJson<int?>(json['recordBookId']),
      contractTypeId: serializer.fromJson<int?>(json['contractTypeId']),
      status: serializer.fromJson<String>(json['status']),
      serialNumber: serializer.fromJson<int?>(json['serialNumber']),
      registerNumber: serializer.fromJson<String?>(json['registerNumber']),
      date: serializer.fromJson<DateTime?>(json['date']),
      hijriYear: serializer.fromJson<int?>(json['hijriYear']),
      hijriDate: serializer.fromJson<String?>(json['hijriDate']),
      subject: serializer.fromJson<String?>(json['subject']),
      content: serializer.fromJson<String?>(json['content']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'remoteId': serializer.toJson<int?>(remoteId),
      'guardianId': serializer.toJson<int?>(guardianId),
      'recordBookId': serializer.toJson<int?>(recordBookId),
      'contractTypeId': serializer.toJson<int?>(contractTypeId),
      'status': serializer.toJson<String>(status),
      'serialNumber': serializer.toJson<int?>(serialNumber),
      'registerNumber': serializer.toJson<String?>(registerNumber),
      'date': serializer.toJson<DateTime?>(date),
      'hijriYear': serializer.toJson<int?>(hijriYear),
      'hijriDate': serializer.toJson<String?>(hijriDate),
      'subject': serializer.toJson<String?>(subject),
      'content': serializer.toJson<String?>(content),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RegistryEntry copyWith({
    int? id,
    String? uuid,
    Value<int?> remoteId = const Value.absent(),
    Value<int?> guardianId = const Value.absent(),
    Value<int?> recordBookId = const Value.absent(),
    Value<int?> contractTypeId = const Value.absent(),
    String? status,
    Value<int?> serialNumber = const Value.absent(),
    Value<String?> registerNumber = const Value.absent(),
    Value<DateTime?> date = const Value.absent(),
    Value<int?> hijriYear = const Value.absent(),
    Value<String?> hijriDate = const Value.absent(),
    Value<String?> subject = const Value.absent(),
    Value<String?> content = const Value.absent(),
    double? totalAmount,
    double? paidAmount,
    bool? isSynced,
    bool? isDeleted,
    Value<DateTime?> lastUpdated = const Value.absent(),
    DateTime? createdAt,
  }) => RegistryEntry(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    guardianId: guardianId.present ? guardianId.value : this.guardianId,
    recordBookId: recordBookId.present ? recordBookId.value : this.recordBookId,
    contractTypeId: contractTypeId.present
        ? contractTypeId.value
        : this.contractTypeId,
    status: status ?? this.status,
    serialNumber: serialNumber.present ? serialNumber.value : this.serialNumber,
    registerNumber: registerNumber.present
        ? registerNumber.value
        : this.registerNumber,
    date: date.present ? date.value : this.date,
    hijriYear: hijriYear.present ? hijriYear.value : this.hijriYear,
    hijriDate: hijriDate.present ? hijriDate.value : this.hijriDate,
    subject: subject.present ? subject.value : this.subject,
    content: content.present ? content.value : this.content,
    totalAmount: totalAmount ?? this.totalAmount,
    paidAmount: paidAmount ?? this.paidAmount,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
    createdAt: createdAt ?? this.createdAt,
  );
  RegistryEntry copyWithCompanion(RegistryEntriesCompanion data) {
    return RegistryEntry(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      guardianId: data.guardianId.present
          ? data.guardianId.value
          : this.guardianId,
      recordBookId: data.recordBookId.present
          ? data.recordBookId.value
          : this.recordBookId,
      contractTypeId: data.contractTypeId.present
          ? data.contractTypeId.value
          : this.contractTypeId,
      status: data.status.present ? data.status.value : this.status,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      registerNumber: data.registerNumber.present
          ? data.registerNumber.value
          : this.registerNumber,
      date: data.date.present ? data.date.value : this.date,
      hijriYear: data.hijriYear.present ? data.hijriYear.value : this.hijriYear,
      hijriDate: data.hijriDate.present ? data.hijriDate.value : this.hijriDate,
      subject: data.subject.present ? data.subject.value : this.subject,
      content: data.content.present ? data.content.value : this.content,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistryEntry(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('remoteId: $remoteId, ')
          ..write('guardianId: $guardianId, ')
          ..write('recordBookId: $recordBookId, ')
          ..write('contractTypeId: $contractTypeId, ')
          ..write('status: $status, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('registerNumber: $registerNumber, ')
          ..write('date: $date, ')
          ..write('hijriYear: $hijriYear, ')
          ..write('hijriDate: $hijriDate, ')
          ..write('subject: $subject, ')
          ..write('content: $content, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    remoteId,
    guardianId,
    recordBookId,
    contractTypeId,
    status,
    serialNumber,
    registerNumber,
    date,
    hijriYear,
    hijriDate,
    subject,
    content,
    totalAmount,
    paidAmount,
    isSynced,
    isDeleted,
    lastUpdated,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistryEntry &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.remoteId == this.remoteId &&
          other.guardianId == this.guardianId &&
          other.recordBookId == this.recordBookId &&
          other.contractTypeId == this.contractTypeId &&
          other.status == this.status &&
          other.serialNumber == this.serialNumber &&
          other.registerNumber == this.registerNumber &&
          other.date == this.date &&
          other.hijriYear == this.hijriYear &&
          other.hijriDate == this.hijriDate &&
          other.subject == this.subject &&
          other.content == this.content &&
          other.totalAmount == this.totalAmount &&
          other.paidAmount == this.paidAmount &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted &&
          other.lastUpdated == this.lastUpdated &&
          other.createdAt == this.createdAt);
}

class RegistryEntriesCompanion extends UpdateCompanion<RegistryEntry> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int?> remoteId;
  final Value<int?> guardianId;
  final Value<int?> recordBookId;
  final Value<int?> contractTypeId;
  final Value<String> status;
  final Value<int?> serialNumber;
  final Value<String?> registerNumber;
  final Value<DateTime?> date;
  final Value<int?> hijriYear;
  final Value<String?> hijriDate;
  final Value<String?> subject;
  final Value<String?> content;
  final Value<double> totalAmount;
  final Value<double> paidAmount;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<DateTime?> lastUpdated;
  final Value<DateTime> createdAt;
  const RegistryEntriesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.guardianId = const Value.absent(),
    this.recordBookId = const Value.absent(),
    this.contractTypeId = const Value.absent(),
    this.status = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.registerNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.hijriYear = const Value.absent(),
    this.hijriDate = const Value.absent(),
    this.subject = const Value.absent(),
    this.content = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RegistryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    this.remoteId = const Value.absent(),
    this.guardianId = const Value.absent(),
    this.recordBookId = const Value.absent(),
    this.contractTypeId = const Value.absent(),
    this.status = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.registerNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.hijriYear = const Value.absent(),
    this.hijriDate = const Value.absent(),
    this.subject = const Value.absent(),
    this.content = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : uuid = Value(uuid);
  static Insertable<RegistryEntry> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? remoteId,
    Expression<int>? guardianId,
    Expression<int>? recordBookId,
    Expression<int>? contractTypeId,
    Expression<String>? status,
    Expression<int>? serialNumber,
    Expression<String>? registerNumber,
    Expression<DateTime>? date,
    Expression<int>? hijriYear,
    Expression<String>? hijriDate,
    Expression<String>? subject,
    Expression<String>? content,
    Expression<double>? totalAmount,
    Expression<double>? paidAmount,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<DateTime>? lastUpdated,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (remoteId != null) 'remote_id': remoteId,
      if (guardianId != null) 'guardian_id': guardianId,
      if (recordBookId != null) 'record_book_id': recordBookId,
      if (contractTypeId != null) 'contract_type_id': contractTypeId,
      if (status != null) 'status': status,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (registerNumber != null) 'register_number': registerNumber,
      if (date != null) 'date': date,
      if (hijriYear != null) 'hijri_year': hijriYear,
      if (hijriDate != null) 'hijri_date': hijriDate,
      if (subject != null) 'subject': subject,
      if (content != null) 'content': content,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RegistryEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int?>? remoteId,
    Value<int?>? guardianId,
    Value<int?>? recordBookId,
    Value<int?>? contractTypeId,
    Value<String>? status,
    Value<int?>? serialNumber,
    Value<String?>? registerNumber,
    Value<DateTime?>? date,
    Value<int?>? hijriYear,
    Value<String?>? hijriDate,
    Value<String?>? subject,
    Value<String?>? content,
    Value<double>? totalAmount,
    Value<double>? paidAmount,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<DateTime?>? lastUpdated,
    Value<DateTime>? createdAt,
  }) {
    return RegistryEntriesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      remoteId: remoteId ?? this.remoteId,
      guardianId: guardianId ?? this.guardianId,
      recordBookId: recordBookId ?? this.recordBookId,
      contractTypeId: contractTypeId ?? this.contractTypeId,
      status: status ?? this.status,
      serialNumber: serialNumber ?? this.serialNumber,
      registerNumber: registerNumber ?? this.registerNumber,
      date: date ?? this.date,
      hijriYear: hijriYear ?? this.hijriYear,
      hijriDate: hijriDate ?? this.hijriDate,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (guardianId.present) {
      map['guardian_id'] = Variable<int>(guardianId.value);
    }
    if (recordBookId.present) {
      map['record_book_id'] = Variable<int>(recordBookId.value);
    }
    if (contractTypeId.present) {
      map['contract_type_id'] = Variable<int>(contractTypeId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<int>(serialNumber.value);
    }
    if (registerNumber.present) {
      map['register_number'] = Variable<String>(registerNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (hijriYear.present) {
      map['hijri_year'] = Variable<int>(hijriYear.value);
    }
    if (hijriDate.present) {
      map['hijri_date'] = Variable<String>(hijriDate.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('remoteId: $remoteId, ')
          ..write('guardianId: $guardianId, ')
          ..write('recordBookId: $recordBookId, ')
          ..write('contractTypeId: $contractTypeId, ')
          ..write('status: $status, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('registerNumber: $registerNumber, ')
          ..write('date: $date, ')
          ..write('hijriYear: $hijriYear, ')
          ..write('hijriDate: $hijriDate, ')
          ..write('subject: $subject, ')
          ..write('content: $content, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PartiesTable extends Parties with TableInfo<$PartiesTable, Party> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _registryEntryIdMeta = const VerificationMeta(
    'registryEntryId',
  );
  @override
  late final GeneratedColumn<int> registryEntryId = GeneratedColumn<int>(
    'registry_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES registry_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nationalIdMeta = const VerificationMeta(
    'nationalId',
  );
  @override
  late final GeneratedColumn<String> nationalId = GeneratedColumn<String>(
    'national_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    registryEntryId,
    name,
    type,
    nationalId,
    phone,
    address,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Party> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('registry_entry_id')) {
      context.handle(
        _registryEntryIdMeta,
        registryEntryId.isAcceptableOrUnknown(
          data['registry_entry_id']!,
          _registryEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registryEntryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('national_id')) {
      context.handle(
        _nationalIdMeta,
        nationalId.isAcceptableOrUnknown(data['national_id']!, _nationalIdMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Party map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Party(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      registryEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}registry_entry_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      nationalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}national_id'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PartiesTable createAlias(String alias) {
    return $PartiesTable(attachedDatabase, alias);
  }
}

class Party extends DataClass implements Insertable<Party> {
  final int id;
  final String uuid;
  final int registryEntryId;
  final String name;
  final String type;
  final String? nationalId;
  final String? phone;
  final String? address;
  final bool isSynced;
  const Party({
    required this.id,
    required this.uuid,
    required this.registryEntryId,
    required this.name,
    required this.type,
    this.nationalId,
    this.phone,
    this.address,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['registry_entry_id'] = Variable<int>(registryEntryId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || nationalId != null) {
      map['national_id'] = Variable<String>(nationalId);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PartiesCompanion toCompanion(bool nullToAbsent) {
    return PartiesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      registryEntryId: Value(registryEntryId),
      name: Value(name),
      type: Value(type),
      nationalId: nationalId == null && nullToAbsent
          ? const Value.absent()
          : Value(nationalId),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      isSynced: Value(isSynced),
    );
  }

  factory Party.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Party(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      registryEntryId: serializer.fromJson<int>(json['registryEntryId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      nationalId: serializer.fromJson<String?>(json['nationalId']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'registryEntryId': serializer.toJson<int>(registryEntryId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'nationalId': serializer.toJson<String?>(nationalId),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Party copyWith({
    int? id,
    String? uuid,
    int? registryEntryId,
    String? name,
    String? type,
    Value<String?> nationalId = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    bool? isSynced,
  }) => Party(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    registryEntryId: registryEntryId ?? this.registryEntryId,
    name: name ?? this.name,
    type: type ?? this.type,
    nationalId: nationalId.present ? nationalId.value : this.nationalId,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    isSynced: isSynced ?? this.isSynced,
  );
  Party copyWithCompanion(PartiesCompanion data) {
    return Party(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      registryEntryId: data.registryEntryId.present
          ? data.registryEntryId.value
          : this.registryEntryId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      nationalId: data.nationalId.present
          ? data.nationalId.value
          : this.nationalId,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Party(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('registryEntryId: $registryEntryId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('nationalId: $nationalId, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    registryEntryId,
    name,
    type,
    nationalId,
    phone,
    address,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Party &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.registryEntryId == this.registryEntryId &&
          other.name == this.name &&
          other.type == this.type &&
          other.nationalId == this.nationalId &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.isSynced == this.isSynced);
}

class PartiesCompanion extends UpdateCompanion<Party> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> registryEntryId;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> nationalId;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<bool> isSynced;
  const PartiesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.registryEntryId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.nationalId = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  PartiesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int registryEntryId,
    required String name,
    required String type,
    this.nationalId = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : uuid = Value(uuid),
       registryEntryId = Value(registryEntryId),
       name = Value(name),
       type = Value(type);
  static Insertable<Party> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? registryEntryId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? nationalId,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (registryEntryId != null) 'registry_entry_id': registryEntryId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (nationalId != null) 'national_id': nationalId,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  PartiesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? registryEntryId,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? nationalId,
    Value<String?>? phone,
    Value<String?>? address,
    Value<bool>? isSynced,
  }) {
    return PartiesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      registryEntryId: registryEntryId ?? this.registryEntryId,
      name: name ?? this.name,
      type: type ?? this.type,
      nationalId: nationalId ?? this.nationalId,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (registryEntryId.present) {
      map['registry_entry_id'] = Variable<int>(registryEntryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (nationalId.present) {
      map['national_id'] = Variable<String>(nationalId.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartiesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('registryEntryId: $registryEntryId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('nationalId: $nationalId, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $RecordBooksTable extends RecordBooks
    with TableInfo<$RecordBooksTable, RecordBook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordBooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _guardianIdMeta = const VerificationMeta(
    'guardianId',
  );
  @override
  late final GeneratedColumn<int> guardianId = GeneratedColumn<int>(
    'guardian_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
    'serial_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentNumberMeta = const VerificationMeta(
    'currentNumber',
  );
  @override
  late final GeneratedColumn<int> currentNumber = GeneratedColumn<int>(
    'current_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPagesMeta = const VerificationMeta(
    'totalPages',
  );
  @override
  late final GeneratedColumn<int> totalPages = GeneratedColumn<int>(
    'total_pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _usedPagesMeta = const VerificationMeta(
    'usedPages',
  );
  @override
  late final GeneratedColumn<int> usedPages = GeneratedColumn<int>(
    'used_pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    guardianId,
    uuid,
    status,
    serialNumber,
    currentNumber,
    totalPages,
    usedPages,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'record_books';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordBook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('guardian_id')) {
      context.handle(
        _guardianIdMeta,
        guardianId.isAcceptableOrUnknown(data['guardian_id']!, _guardianIdMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    }
    if (data.containsKey('current_number')) {
      context.handle(
        _currentNumberMeta,
        currentNumber.isAcceptableOrUnknown(
          data['current_number']!,
          _currentNumberMeta,
        ),
      );
    }
    if (data.containsKey('total_pages')) {
      context.handle(
        _totalPagesMeta,
        totalPages.isAcceptableOrUnknown(data['total_pages']!, _totalPagesMeta),
      );
    }
    if (data.containsKey('used_pages')) {
      context.handle(
        _usedPagesMeta,
        usedPages.isAcceptableOrUnknown(data['used_pages']!, _usedPagesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordBook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordBook(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      guardianId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}guardian_id'],
      ),
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_number'],
      ),
      currentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_number'],
      )!,
      totalPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pages'],
      )!,
      usedPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}used_pages'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $RecordBooksTable createAlias(String alias) {
    return $RecordBooksTable(attachedDatabase, alias);
  }
}

class RecordBook extends DataClass implements Insertable<RecordBook> {
  final int id;
  final int? guardianId;
  final String uuid;
  final String status;
  final String? serialNumber;
  final int currentNumber;
  final int totalPages;
  final int usedPages;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const RecordBook({
    required this.id,
    this.guardianId,
    required this.uuid,
    required this.status,
    this.serialNumber,
    required this.currentNumber,
    required this.totalPages,
    required this.usedPages,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || guardianId != null) {
      map['guardian_id'] = Variable<int>(guardianId);
    }
    map['uuid'] = Variable<String>(uuid);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<String>(serialNumber);
    }
    map['current_number'] = Variable<int>(currentNumber);
    map['total_pages'] = Variable<int>(totalPages);
    map['used_pages'] = Variable<int>(usedPages);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RecordBooksCompanion toCompanion(bool nullToAbsent) {
    return RecordBooksCompanion(
      id: Value(id),
      guardianId: guardianId == null && nullToAbsent
          ? const Value.absent()
          : Value(guardianId),
      uuid: Value(uuid),
      status: Value(status),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      currentNumber: Value(currentNumber),
      totalPages: Value(totalPages),
      usedPages: Value(usedPages),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RecordBook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordBook(
      id: serializer.fromJson<int>(json['id']),
      guardianId: serializer.fromJson<int?>(json['guardianId']),
      uuid: serializer.fromJson<String>(json['uuid']),
      status: serializer.fromJson<String>(json['status']),
      serialNumber: serializer.fromJson<String?>(json['serialNumber']),
      currentNumber: serializer.fromJson<int>(json['currentNumber']),
      totalPages: serializer.fromJson<int>(json['totalPages']),
      usedPages: serializer.fromJson<int>(json['usedPages']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'guardianId': serializer.toJson<int?>(guardianId),
      'uuid': serializer.toJson<String>(uuid),
      'status': serializer.toJson<String>(status),
      'serialNumber': serializer.toJson<String?>(serialNumber),
      'currentNumber': serializer.toJson<int>(currentNumber),
      'totalPages': serializer.toJson<int>(totalPages),
      'usedPages': serializer.toJson<int>(usedPages),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RecordBook copyWith({
    int? id,
    Value<int?> guardianId = const Value.absent(),
    String? uuid,
    String? status,
    Value<String?> serialNumber = const Value.absent(),
    int? currentNumber,
    int? totalPages,
    int? usedPages,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => RecordBook(
    id: id ?? this.id,
    guardianId: guardianId.present ? guardianId.value : this.guardianId,
    uuid: uuid ?? this.uuid,
    status: status ?? this.status,
    serialNumber: serialNumber.present ? serialNumber.value : this.serialNumber,
    currentNumber: currentNumber ?? this.currentNumber,
    totalPages: totalPages ?? this.totalPages,
    usedPages: usedPages ?? this.usedPages,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  RecordBook copyWithCompanion(RecordBooksCompanion data) {
    return RecordBook(
      id: data.id.present ? data.id.value : this.id,
      guardianId: data.guardianId.present
          ? data.guardianId.value
          : this.guardianId,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      status: data.status.present ? data.status.value : this.status,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      currentNumber: data.currentNumber.present
          ? data.currentNumber.value
          : this.currentNumber,
      totalPages: data.totalPages.present
          ? data.totalPages.value
          : this.totalPages,
      usedPages: data.usedPages.present ? data.usedPages.value : this.usedPages,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordBook(')
          ..write('id: $id, ')
          ..write('guardianId: $guardianId, ')
          ..write('uuid: $uuid, ')
          ..write('status: $status, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('currentNumber: $currentNumber, ')
          ..write('totalPages: $totalPages, ')
          ..write('usedPages: $usedPages, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    guardianId,
    uuid,
    status,
    serialNumber,
    currentNumber,
    totalPages,
    usedPages,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordBook &&
          other.id == this.id &&
          other.guardianId == this.guardianId &&
          other.uuid == this.uuid &&
          other.status == this.status &&
          other.serialNumber == this.serialNumber &&
          other.currentNumber == this.currentNumber &&
          other.totalPages == this.totalPages &&
          other.usedPages == this.usedPages &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecordBooksCompanion extends UpdateCompanion<RecordBook> {
  final Value<int> id;
  final Value<int?> guardianId;
  final Value<String> uuid;
  final Value<String> status;
  final Value<String?> serialNumber;
  final Value<int> currentNumber;
  final Value<int> totalPages;
  final Value<int> usedPages;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const RecordBooksCompanion({
    this.id = const Value.absent(),
    this.guardianId = const Value.absent(),
    this.uuid = const Value.absent(),
    this.status = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.currentNumber = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.usedPages = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RecordBooksCompanion.insert({
    this.id = const Value.absent(),
    this.guardianId = const Value.absent(),
    required String uuid,
    this.status = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.currentNumber = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.usedPages = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : uuid = Value(uuid);
  static Insertable<RecordBook> custom({
    Expression<int>? id,
    Expression<int>? guardianId,
    Expression<String>? uuid,
    Expression<String>? status,
    Expression<String>? serialNumber,
    Expression<int>? currentNumber,
    Expression<int>? totalPages,
    Expression<int>? usedPages,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (guardianId != null) 'guardian_id': guardianId,
      if (uuid != null) 'uuid': uuid,
      if (status != null) 'status': status,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (currentNumber != null) 'current_number': currentNumber,
      if (totalPages != null) 'total_pages': totalPages,
      if (usedPages != null) 'used_pages': usedPages,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RecordBooksCompanion copyWith({
    Value<int>? id,
    Value<int?>? guardianId,
    Value<String>? uuid,
    Value<String>? status,
    Value<String?>? serialNumber,
    Value<int>? currentNumber,
    Value<int>? totalPages,
    Value<int>? usedPages,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return RecordBooksCompanion(
      id: id ?? this.id,
      guardianId: guardianId ?? this.guardianId,
      uuid: uuid ?? this.uuid,
      status: status ?? this.status,
      serialNumber: serialNumber ?? this.serialNumber,
      currentNumber: currentNumber ?? this.currentNumber,
      totalPages: totalPages ?? this.totalPages,
      usedPages: usedPages ?? this.usedPages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (guardianId.present) {
      map['guardian_id'] = Variable<int>(guardianId.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (currentNumber.present) {
      map['current_number'] = Variable<int>(currentNumber.value);
    }
    if (totalPages.present) {
      map['total_pages'] = Variable<int>(totalPages.value);
    }
    if (usedPages.present) {
      map['used_pages'] = Variable<int>(usedPages.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordBooksCompanion(')
          ..write('id: $id, ')
          ..write('guardianId: $guardianId, ')
          ..write('uuid: $uuid, ')
          ..write('status: $status, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('currentNumber: $currentNumber, ')
          ..write('totalPages: $totalPages, ')
          ..write('usedPages: $usedPages, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operation,
    targetTable,
    recordId,
    payload,
    status,
    attempts,
    createdAt,
    lastAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String operation;
  final String targetTable;
  final String recordId;
  final String? payload;
  final String status;
  final int attempts;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  const SyncQueueData({
    required this.id,
    required this.operation,
    required this.targetTable,
    required this.recordId,
    this.payload,
    required this.status,
    required this.attempts,
    required this.createdAt,
    this.lastAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation'] = Variable<String>(operation);
    map['target_table'] = Variable<String>(targetTable);
    map['record_id'] = Variable<String>(recordId);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      targetTable: Value(targetTable),
      recordId: Value(recordId),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      status: Value(status),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      payload: serializer.fromJson<String?>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(operation),
      'targetTable': serializer.toJson<String>(targetTable),
      'recordId': serializer.toJson<String>(recordId),
      'payload': serializer.toJson<String?>(payload),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? operation,
    String? targetTable,
    String? recordId,
    Value<String?> payload = const Value.absent(),
    String? status,
    int? attempts,
    DateTime? createdAt,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    operation: operation ?? this.operation,
    targetTable: targetTable ?? this.targetTable,
    recordId: recordId ?? this.recordId,
    payload: payload.present ? payload.value : this.payload,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    createdAt: createdAt ?? this.createdAt,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operation,
    targetTable,
    recordId,
    payload,
    status,
    attempts,
    createdAt,
    lastAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> operation;
  final Value<String> targetTable;
  final Value<String> recordId;
  final Value<String?> payload;
  final Value<String> status;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String operation,
    required String targetTable,
    required String recordId,
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  }) : operation = Value(operation),
       targetTable = Value(targetTable),
       recordId = Value(recordId);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? targetTable,
    Expression<String>? recordId,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (targetTable != null) 'target_table': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? operation,
    Value<String>? targetTable,
    Value<String>? recordId,
    Value<String?>? payload,
    Value<String>? status,
    Value<int>? attempts,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastAttemptAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RegistryEntriesTable registryEntries = $RegistryEntriesTable(
    this,
  );
  late final $PartiesTable parties = $PartiesTable(this);
  late final $RecordBooksTable recordBooks = $RecordBooksTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    registryEntries,
    parties,
    recordBooks,
    syncQueue,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'registry_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('parties', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$RegistryEntriesTableCreateCompanionBuilder =
    RegistryEntriesCompanion Function({
      Value<int> id,
      required String uuid,
      Value<int?> remoteId,
      Value<int?> guardianId,
      Value<int?> recordBookId,
      Value<int?> contractTypeId,
      Value<String> status,
      Value<int?> serialNumber,
      Value<String?> registerNumber,
      Value<DateTime?> date,
      Value<int?> hijriYear,
      Value<String?> hijriDate,
      Value<String?> subject,
      Value<String?> content,
      Value<double> totalAmount,
      Value<double> paidAmount,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<DateTime?> lastUpdated,
      Value<DateTime> createdAt,
    });
typedef $$RegistryEntriesTableUpdateCompanionBuilder =
    RegistryEntriesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int?> remoteId,
      Value<int?> guardianId,
      Value<int?> recordBookId,
      Value<int?> contractTypeId,
      Value<String> status,
      Value<int?> serialNumber,
      Value<String?> registerNumber,
      Value<DateTime?> date,
      Value<int?> hijriYear,
      Value<String?> hijriDate,
      Value<String?> subject,
      Value<String?> content,
      Value<double> totalAmount,
      Value<double> paidAmount,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<DateTime?> lastUpdated,
      Value<DateTime> createdAt,
    });

final class $$RegistryEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RegistryEntriesTable, RegistryEntry> {
  $$RegistryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PartiesTable, List<Party>> _partiesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.parties,
    aliasName: $_aliasNameGenerator(
      db.registryEntries.id,
      db.parties.registryEntryId,
    ),
  );

  $$PartiesTableProcessedTableManager get partiesRefs {
    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.registryEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RegistryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $RegistryEntriesTable> {
  $$RegistryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get guardianId => $composableBuilder(
    column: $table.guardianId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordBookId => $composableBuilder(
    column: $table.recordBookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contractTypeId => $composableBuilder(
    column: $table.contractTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registerNumber => $composableBuilder(
    column: $table.registerNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hijriYear => $composableBuilder(
    column: $table.hijriYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hijriDate => $composableBuilder(
    column: $table.hijriDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> partiesRefs(
    Expression<bool> Function($$PartiesTableFilterComposer f) f,
  ) {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.registryEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RegistryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RegistryEntriesTable> {
  $$RegistryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get guardianId => $composableBuilder(
    column: $table.guardianId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordBookId => $composableBuilder(
    column: $table.recordBookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contractTypeId => $composableBuilder(
    column: $table.contractTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registerNumber => $composableBuilder(
    column: $table.registerNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hijriYear => $composableBuilder(
    column: $table.hijriYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hijriDate => $composableBuilder(
    column: $table.hijriDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegistryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegistryEntriesTable> {
  $$RegistryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<int> get guardianId => $composableBuilder(
    column: $table.guardianId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordBookId => $composableBuilder(
    column: $table.recordBookId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contractTypeId => $composableBuilder(
    column: $table.contractTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get registerNumber => $composableBuilder(
    column: $table.registerNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get hijriYear =>
      $composableBuilder(column: $table.hijriYear, builder: (column) => column);

  GeneratedColumn<String> get hijriDate =>
      $composableBuilder(column: $table.hijriDate, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> partiesRefs<T extends Object>(
    Expression<T> Function($$PartiesTableAnnotationComposer a) f,
  ) {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.registryEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RegistryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegistryEntriesTable,
          RegistryEntry,
          $$RegistryEntriesTableFilterComposer,
          $$RegistryEntriesTableOrderingComposer,
          $$RegistryEntriesTableAnnotationComposer,
          $$RegistryEntriesTableCreateCompanionBuilder,
          $$RegistryEntriesTableUpdateCompanionBuilder,
          (RegistryEntry, $$RegistryEntriesTableReferences),
          RegistryEntry,
          PrefetchHooks Function({bool partiesRefs})
        > {
  $$RegistryEntriesTableTableManager(
    _$AppDatabase db,
    $RegistryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int?> remoteId = const Value.absent(),
                Value<int?> guardianId = const Value.absent(),
                Value<int?> recordBookId = const Value.absent(),
                Value<int?> contractTypeId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> serialNumber = const Value.absent(),
                Value<String?> registerNumber = const Value.absent(),
                Value<DateTime?> date = const Value.absent(),
                Value<int?> hijriYear = const Value.absent(),
                Value<String?> hijriDate = const Value.absent(),
                Value<String?> subject = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RegistryEntriesCompanion(
                id: id,
                uuid: uuid,
                remoteId: remoteId,
                guardianId: guardianId,
                recordBookId: recordBookId,
                contractTypeId: contractTypeId,
                status: status,
                serialNumber: serialNumber,
                registerNumber: registerNumber,
                date: date,
                hijriYear: hijriYear,
                hijriDate: hijriDate,
                subject: subject,
                content: content,
                totalAmount: totalAmount,
                paidAmount: paidAmount,
                isSynced: isSynced,
                isDeleted: isDeleted,
                lastUpdated: lastUpdated,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                Value<int?> remoteId = const Value.absent(),
                Value<int?> guardianId = const Value.absent(),
                Value<int?> recordBookId = const Value.absent(),
                Value<int?> contractTypeId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> serialNumber = const Value.absent(),
                Value<String?> registerNumber = const Value.absent(),
                Value<DateTime?> date = const Value.absent(),
                Value<int?> hijriYear = const Value.absent(),
                Value<String?> hijriDate = const Value.absent(),
                Value<String?> subject = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RegistryEntriesCompanion.insert(
                id: id,
                uuid: uuid,
                remoteId: remoteId,
                guardianId: guardianId,
                recordBookId: recordBookId,
                contractTypeId: contractTypeId,
                status: status,
                serialNumber: serialNumber,
                registerNumber: registerNumber,
                date: date,
                hijriYear: hijriYear,
                hijriDate: hijriDate,
                subject: subject,
                content: content,
                totalAmount: totalAmount,
                paidAmount: paidAmount,
                isSynced: isSynced,
                isDeleted: isDeleted,
                lastUpdated: lastUpdated,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RegistryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (partiesRefs) db.parties],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (partiesRefs)
                    await $_getPrefetchedData<
                      RegistryEntry,
                      $RegistryEntriesTable,
                      Party
                    >(
                      currentTable: table,
                      referencedTable: $$RegistryEntriesTableReferences
                          ._partiesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RegistryEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).partiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.registryEntryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RegistryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegistryEntriesTable,
      RegistryEntry,
      $$RegistryEntriesTableFilterComposer,
      $$RegistryEntriesTableOrderingComposer,
      $$RegistryEntriesTableAnnotationComposer,
      $$RegistryEntriesTableCreateCompanionBuilder,
      $$RegistryEntriesTableUpdateCompanionBuilder,
      (RegistryEntry, $$RegistryEntriesTableReferences),
      RegistryEntry,
      PrefetchHooks Function({bool partiesRefs})
    >;
typedef $$PartiesTableCreateCompanionBuilder =
    PartiesCompanion Function({
      Value<int> id,
      required String uuid,
      required int registryEntryId,
      required String name,
      required String type,
      Value<String?> nationalId,
      Value<String?> phone,
      Value<String?> address,
      Value<bool> isSynced,
    });
typedef $$PartiesTableUpdateCompanionBuilder =
    PartiesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> registryEntryId,
      Value<String> name,
      Value<String> type,
      Value<String?> nationalId,
      Value<String?> phone,
      Value<String?> address,
      Value<bool> isSynced,
    });

final class $$PartiesTableReferences
    extends BaseReferences<_$AppDatabase, $PartiesTable, Party> {
  $$PartiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RegistryEntriesTable _registryEntryIdTable(_$AppDatabase db) =>
      db.registryEntries.createAlias(
        $_aliasNameGenerator(db.parties.registryEntryId, db.registryEntries.id),
      );

  $$RegistryEntriesTableProcessedTableManager get registryEntryId {
    final $_column = $_itemColumn<int>('registry_entry_id')!;

    final manager = $$RegistryEntriesTableTableManager(
      $_db,
      $_db.registryEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_registryEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PartiesTableFilterComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$RegistryEntriesTableFilterComposer get registryEntryId {
    final $$RegistryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registryEntryId,
      referencedTable: $db.registryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.registryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$RegistryEntriesTableOrderingComposer get registryEntryId {
    final $$RegistryEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registryEntryId,
      referencedTable: $db.registryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistryEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.registryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get nationalId => $composableBuilder(
    column: $table.nationalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$RegistryEntriesTableAnnotationComposer get registryEntryId {
    final $$RegistryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registryEntryId,
      referencedTable: $db.registryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.registryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartiesTable,
          Party,
          $$PartiesTableFilterComposer,
          $$PartiesTableOrderingComposer,
          $$PartiesTableAnnotationComposer,
          $$PartiesTableCreateCompanionBuilder,
          $$PartiesTableUpdateCompanionBuilder,
          (Party, $$PartiesTableReferences),
          Party,
          PrefetchHooks Function({bool registryEntryId})
        > {
  $$PartiesTableTableManager(_$AppDatabase db, $PartiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> registryEntryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> nationalId = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PartiesCompanion(
                id: id,
                uuid: uuid,
                registryEntryId: registryEntryId,
                name: name,
                type: type,
                nationalId: nationalId,
                phone: phone,
                address: address,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int registryEntryId,
                required String name,
                required String type,
                Value<String?> nationalId = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PartiesCompanion.insert(
                id: id,
                uuid: uuid,
                registryEntryId: registryEntryId,
                name: name,
                type: type,
                nationalId: nationalId,
                phone: phone,
                address: address,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({registryEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (registryEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.registryEntryId,
                                referencedTable: $$PartiesTableReferences
                                    ._registryEntryIdTable(db),
                                referencedColumn: $$PartiesTableReferences
                                    ._registryEntryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartiesTable,
      Party,
      $$PartiesTableFilterComposer,
      $$PartiesTableOrderingComposer,
      $$PartiesTableAnnotationComposer,
      $$PartiesTableCreateCompanionBuilder,
      $$PartiesTableUpdateCompanionBuilder,
      (Party, $$PartiesTableReferences),
      Party,
      PrefetchHooks Function({bool registryEntryId})
    >;
typedef $$RecordBooksTableCreateCompanionBuilder =
    RecordBooksCompanion Function({
      Value<int> id,
      Value<int?> guardianId,
      required String uuid,
      Value<String> status,
      Value<String?> serialNumber,
      Value<int> currentNumber,
      Value<int> totalPages,
      Value<int> usedPages,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$RecordBooksTableUpdateCompanionBuilder =
    RecordBooksCompanion Function({
      Value<int> id,
      Value<int?> guardianId,
      Value<String> uuid,
      Value<String> status,
      Value<String?> serialNumber,
      Value<int> currentNumber,
      Value<int> totalPages,
      Value<int> usedPages,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$RecordBooksTableFilterComposer
    extends Composer<_$AppDatabase, $RecordBooksTable> {
  $$RecordBooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get guardianId => $composableBuilder(
    column: $table.guardianId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentNumber => $composableBuilder(
    column: $table.currentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usedPages => $composableBuilder(
    column: $table.usedPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordBooksTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordBooksTable> {
  $$RecordBooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get guardianId => $composableBuilder(
    column: $table.guardianId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentNumber => $composableBuilder(
    column: $table.currentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usedPages => $composableBuilder(
    column: $table.usedPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordBooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordBooksTable> {
  $$RecordBooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get guardianId => $composableBuilder(
    column: $table.guardianId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentNumber => $composableBuilder(
    column: $table.currentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usedPages =>
      $composableBuilder(column: $table.usedPages, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecordBooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordBooksTable,
          RecordBook,
          $$RecordBooksTableFilterComposer,
          $$RecordBooksTableOrderingComposer,
          $$RecordBooksTableAnnotationComposer,
          $$RecordBooksTableCreateCompanionBuilder,
          $$RecordBooksTableUpdateCompanionBuilder,
          (
            RecordBook,
            BaseReferences<_$AppDatabase, $RecordBooksTable, RecordBook>,
          ),
          RecordBook,
          PrefetchHooks Function()
        > {
  $$RecordBooksTableTableManager(_$AppDatabase db, $RecordBooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordBooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordBooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordBooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> guardianId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> serialNumber = const Value.absent(),
                Value<int> currentNumber = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<int> usedPages = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => RecordBooksCompanion(
                id: id,
                guardianId: guardianId,
                uuid: uuid,
                status: status,
                serialNumber: serialNumber,
                currentNumber: currentNumber,
                totalPages: totalPages,
                usedPages: usedPages,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> guardianId = const Value.absent(),
                required String uuid,
                Value<String> status = const Value.absent(),
                Value<String?> serialNumber = const Value.absent(),
                Value<int> currentNumber = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<int> usedPages = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => RecordBooksCompanion.insert(
                id: id,
                guardianId: guardianId,
                uuid: uuid,
                status: status,
                serialNumber: serialNumber,
                currentNumber: currentNumber,
                totalPages: totalPages,
                usedPages: usedPages,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordBooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordBooksTable,
      RecordBook,
      $$RecordBooksTableFilterComposer,
      $$RecordBooksTableOrderingComposer,
      $$RecordBooksTableAnnotationComposer,
      $$RecordBooksTableCreateCompanionBuilder,
      $$RecordBooksTableUpdateCompanionBuilder,
      (
        RecordBook,
        BaseReferences<_$AppDatabase, $RecordBooksTable, RecordBook>,
      ),
      RecordBook,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String operation,
      required String targetTable,
      required String recordId,
      Value<String?> payload,
      Value<String> status,
      Value<int> attempts,
      Value<DateTime> createdAt,
      Value<DateTime?> lastAttemptAt,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> operation,
      Value<String> targetTable,
      Value<String> recordId,
      Value<String?> payload,
      Value<String> status,
      Value<int> attempts,
      Value<DateTime> createdAt,
      Value<DateTime?> lastAttemptAt,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                operation: operation,
                targetTable: targetTable,
                recordId: recordId,
                payload: payload,
                status: status,
                attempts: attempts,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String operation,
                required String targetTable,
                required String recordId,
                Value<String?> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                operation: operation,
                targetTable: targetTable,
                recordId: recordId,
                payload: payload,
                status: status,
                attempts: attempts,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RegistryEntriesTableTableManager get registryEntries =>
      $$RegistryEntriesTableTableManager(_db, _db.registryEntries);
  $$PartiesTableTableManager get parties =>
      $$PartiesTableTableManager(_db, _db.parties);
  $$RecordBooksTableTableManager get recordBooks =>
      $$RecordBooksTableTableManager(_db, _db.recordBooks);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
