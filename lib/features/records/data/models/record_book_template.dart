import 'package:json_annotation/json_annotation.dart';

part 'record_book_template.g.dart';

@JsonSerializable()
class RecordBookTemplate {
  final int id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(name: 'total_pages', defaultValue: 100)
  final int totalPages;
  @JsonKey(name: 'constraints_per_page', defaultValue: 10)
  final int constraintsPerPage;
  final String? description;

  RecordBookTemplate({
    required this.id,
    required this.name,
    required this.totalPages,
    required this.constraintsPerPage,
    this.description,
  });

  factory RecordBookTemplate.fromJson(Map<String, dynamic> json) =>
      _$RecordBookTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$RecordBookTemplateToJson(this);
}
