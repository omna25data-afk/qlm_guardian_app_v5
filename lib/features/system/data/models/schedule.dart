class Schedule {
  final int id;
  final String command;
  final String? commandCustom;
  final String? params;
  final String expression;
  final String? environments;
  final String? options;
  final String? optionsWithValue;
  final String? logFilename;
  final int evenInMaintenanceMode;
  final int withoutOverlapping;
  final int onOneServer;
  final String? webhookBefore;
  final String? webhookAfter;
  final String? emailOutput;
  final int sendmailError;
  final int logSuccess;
  final int logError;
  final String status;
  final int runInBackground;
  final int sendmailSuccess;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int limitHistoryCount;
  final int maxHistoryCount;

  Schedule({
    required this.id,
    required this.command,
    this.commandCustom,
    this.params,
    required this.expression,
    this.environments,
    this.options,
    this.optionsWithValue,
    this.logFilename,
    required this.evenInMaintenanceMode,
    required this.withoutOverlapping,
    required this.onOneServer,
    this.webhookBefore,
    this.webhookAfter,
    this.emailOutput,
    required this.sendmailError,
    required this.logSuccess,
    required this.logError,
    required this.status,
    required this.runInBackground,
    required this.sendmailSuccess,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.limitHistoryCount,
    required this.maxHistoryCount,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      command: json['command'] ?? '',
      commandCustom: json['command_custom'] ?? null,
      params: json['params'] ?? null,
      expression: json['expression'] ?? '',
      environments: json['environments'] ?? null,
      options: json['options'] ?? null,
      optionsWithValue: json['options_with_value'] ?? null,
      logFilename: json['log_filename'] ?? null,
      evenInMaintenanceMode: json['even_in_maintenance_mode'] != null ? (json['even_in_maintenance_mode'] is int ? json['even_in_maintenance_mode'] : int.tryParse(json['even_in_maintenance_mode'].toString()) ?? 0) : 0,
      withoutOverlapping: json['without_overlapping'] != null ? (json['without_overlapping'] is int ? json['without_overlapping'] : int.tryParse(json['without_overlapping'].toString()) ?? 0) : 0,
      onOneServer: json['on_one_server'] != null ? (json['on_one_server'] is int ? json['on_one_server'] : int.tryParse(json['on_one_server'].toString()) ?? 0) : 0,
      webhookBefore: json['webhook_before'] ?? null,
      webhookAfter: json['webhook_after'] ?? null,
      emailOutput: json['email_output'] ?? null,
      sendmailError: json['sendmail_error'] != null ? (json['sendmail_error'] is int ? json['sendmail_error'] : int.tryParse(json['sendmail_error'].toString()) ?? 0) : 0,
      logSuccess: json['log_success'] != null ? (json['log_success'] is int ? json['log_success'] : int.tryParse(json['log_success'].toString()) ?? 0) : 0,
      logError: json['log_error'] != null ? (json['log_error'] is int ? json['log_error'] : int.tryParse(json['log_error'].toString()) ?? 0) : 0,
      status: json['status'] ?? '',
      runInBackground: json['run_in_background'] != null ? (json['run_in_background'] is int ? json['run_in_background'] : int.tryParse(json['run_in_background'].toString()) ?? 0) : 0,
      sendmailSuccess: json['sendmail_success'] != null ? (json['sendmail_success'] is int ? json['sendmail_success'] : int.tryParse(json['sendmail_success'].toString()) ?? 0) : 0,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
      limitHistoryCount: json['limit_history_count'] != null ? (json['limit_history_count'] is int ? json['limit_history_count'] : int.tryParse(json['limit_history_count'].toString()) ?? 0) : 0,
      maxHistoryCount: json['max_history_count'] != null ? (json['max_history_count'] is int ? json['max_history_count'] : int.tryParse(json['max_history_count'].toString()) ?? 0) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'command': command,
      'command_custom': commandCustom,
      'params': params,
      'expression': expression,
      'environments': environments,
      'options': options,
      'options_with_value': optionsWithValue,
      'log_filename': logFilename,
      'even_in_maintenance_mode': evenInMaintenanceMode,
      'without_overlapping': withoutOverlapping,
      'on_one_server': onOneServer,
      'webhook_before': webhookBefore,
      'webhook_after': webhookAfter,
      'email_output': emailOutput,
      'sendmail_error': sendmailError,
      'log_success': logSuccess,
      'log_error': logError,
      'status': status,
      'run_in_background': runInBackground,
      'sendmail_success': sendmailSuccess,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'limit_history_count': limitHistoryCount,
      'max_history_count': maxHistoryCount,
    };
  }
}
