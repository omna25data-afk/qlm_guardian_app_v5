class DocumentDelivery {
  final int id;
  final int constraintId;
  final String deliveredTo;
  final String? receiverNationalId;
  final String? receiverPhone;
  final String deliveryDate;
  final String deliveryMethod;
  final String? deliveryNotes;
  final String? deliveryDocumentPath;
  final int? deliveredBy;
  final int? receivedBy;
  final bool isDelivered;
  final String? createdAt;
  final String? updatedAt;

  DocumentDelivery({
    required this.id,
    required this.constraintId,
    required this.deliveredTo,
    this.receiverNationalId,
    this.receiverPhone,
    required this.deliveryDate,
    required this.deliveryMethod,
    this.deliveryNotes,
    this.deliveryDocumentPath,
    this.deliveredBy,
    this.receivedBy,
    required this.isDelivered,
    this.createdAt,
    this.updatedAt,
  });

  factory DocumentDelivery.fromJson(Map<String, dynamic> json) {
    return DocumentDelivery(
      id: json['id'] != null
          ? (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? 0)
          : 0,
      constraintId: json['constraint_id'] != null
          ? (json['constraint_id'] is int
                ? json['constraint_id']
                : int.tryParse(json['constraint_id'].toString()) ?? 0)
          : 0,
      deliveredTo: json['delivered_to'] ?? '',
      receiverNationalId: json['receiver_national_id'] ?? null,
      receiverPhone: json['receiver_phone'] ?? null,
      deliveryDate: json['delivery_date'] ?? '',
      deliveryMethod: json['delivery_method'] ?? '',
      deliveryNotes: json['delivery_notes'] ?? null,
      deliveryDocumentPath: json['delivery_document_path'] ?? null,
      deliveredBy: json['delivered_by'] != null
          ? (json['delivered_by'] is int
                ? json['delivered_by']
                : int.tryParse(json['delivered_by'].toString()) ?? null)
          : null,
      receivedBy: json['received_by'] != null
          ? (json['received_by'] is int
                ? json['received_by']
                : int.tryParse(json['received_by'].toString()) ?? null)
          : null,
      isDelivered:
          json['is_delivered'] == 1 ||
          json['is_delivered'] == true ||
          json['is_delivered'] == '1',
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'constraint_id': constraintId,
      'delivered_to': deliveredTo,
      'receiver_national_id': receiverNationalId,
      'receiver_phone': receiverPhone,
      'delivery_date': deliveryDate,
      'delivery_method': deliveryMethod,
      'delivery_notes': deliveryNotes,
      'delivery_document_path': deliveryDocumentPath,
      'delivered_by': deliveredBy,
      'received_by': receivedBy,
      'is_delivered': isDelivered,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
