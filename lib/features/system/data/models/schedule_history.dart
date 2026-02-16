class ScheduleHistory {
  final int id;
  final int scheduleId;
  final String command;
  final String? params;
  final String output;
  final String? options;
  final String? createdAt;
  final String? updatedAt;

  ScheduleHistory({
    required this.id,
    required this.scheduleId,
    required this.command,
    this.params,
    required this.output,
    this.options,
    this.createdAt,
    this.updatedAt,
  });

  factory ScheduleHistory.fromJson(Map<String, dynamic> json) {
    return ScheduleHistory(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      scheduleId: json['schedule_id'] != null ? (json['schedule_id'] is int ? json['schedule_id'] : int.tryParse(json['schedule_id'].toString()) ?? 0) : 0,
      command: json['command'] ?? '',
      params: json['params'] ?? null,
      output: json['output'] ?? '',
      options: json['options'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schedule_id': scheduleId,
      'command': command,
      'params': params,
      'output': output,
      'options': options,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
