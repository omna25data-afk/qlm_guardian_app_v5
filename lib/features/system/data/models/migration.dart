class Migration {
  final int id;
  final String migration;
  final int batch;

  Migration({
    required this.id,
    required this.migration,
    required this.batch,
  });

  factory Migration.fromJson(Map<String, dynamic> json) {
    return Migration(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      migration: json['migration'] ?? '',
      batch: json['batch'] != null ? (json['batch'] is int ? json['batch'] : int.tryParse(json['batch'].toString()) ?? 0) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'migration': migration,
      'batch': batch,
    };
  }
}
