class SaleContract {
  final int id;
  final int? registryEntryId;
  final int? constraintId;
  final String sellerName;
  final String? sellerNationalId;
  final String buyerName;
  final String? buyerNationalId;
  final String saleType;
  final String? saleSubtype;
  final String? itemDescription;
  final String? saleArea;
  final String? saleAreaQasab;
  final double? saleAreaSqm;
  final String? propertyType;
  final String? propertyLocation;
  final String? propertyBoundaries;
  final double salePrice;
  final double? taxAmount;
  final String? taxReceiptNumber;
  final double? zakatAmount;
  final String? zakatReceiptNumber;
  final String? paymentMethod;
  final String? witnesses;
  final String? deedNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? subtype1;
  final String? subtype2;

  SaleContract({
    required this.id,
    this.registryEntryId,
    this.constraintId,
    required this.sellerName,
    this.sellerNationalId,
    required this.buyerName,
    this.buyerNationalId,
    required this.saleType,
    this.saleSubtype,
    this.itemDescription,
    this.saleArea,
    this.saleAreaQasab,
    this.saleAreaSqm,
    this.propertyType,
    this.propertyLocation,
    this.propertyBoundaries,
    required this.salePrice,
    this.taxAmount,
    this.taxReceiptNumber,
    this.zakatAmount,
    this.zakatReceiptNumber,
    this.paymentMethod,
    this.witnesses,
    this.deedNumber,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subtype1,
    this.subtype2,
  });

  factory SaleContract.fromJson(Map<String, dynamic> json) {
    return SaleContract(
      id: json['id'] != null ? (json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0) : 0,
      registryEntryId: json['registry_entry_id'] != null ? (json['registry_entry_id'] is int ? json['registry_entry_id'] : int.tryParse(json['registry_entry_id'].toString()) ?? null) : null,
      constraintId: json['constraint_id'] != null ? (json['constraint_id'] is int ? json['constraint_id'] : int.tryParse(json['constraint_id'].toString()) ?? null) : null,
      sellerName: json['seller_name'] ?? '',
      sellerNationalId: json['seller_national_id'] ?? null,
      buyerName: json['buyer_name'] ?? '',
      buyerNationalId: json['buyer_national_id'] ?? null,
      saleType: json['sale_type'] ?? '',
      saleSubtype: json['sale_subtype'] ?? null,
      itemDescription: json['item_description'] ?? null,
      saleArea: json['sale_area'] ?? null,
      saleAreaQasab: json['sale_area_qasab'] ?? null,
      saleAreaSqm: json['sale_area_sqm'] != null ? (json['sale_area_sqm'] is num ? json['sale_area_sqm'].toDouble() : double.tryParse(json['sale_area_sqm'].toString()) ?? null) : null,
      propertyType: json['property_type'] ?? null,
      propertyLocation: json['property_location'] ?? null,
      propertyBoundaries: json['property_boundaries'] ?? null,
      salePrice: json['sale_price'] != null ? (json['sale_price'] is num ? json['sale_price'].toDouble() : double.tryParse(json['sale_price'].toString()) ?? 0.0) : 0.0,
      taxAmount: json['tax_amount'] != null ? (json['tax_amount'] is num ? json['tax_amount'].toDouble() : double.tryParse(json['tax_amount'].toString()) ?? null) : null,
      taxReceiptNumber: json['tax_receipt_number'] ?? null,
      zakatAmount: json['zakat_amount'] != null ? (json['zakat_amount'] is num ? json['zakat_amount'].toDouble() : double.tryParse(json['zakat_amount'].toString()) ?? null) : null,
      zakatReceiptNumber: json['zakat_receipt_number'] ?? null,
      paymentMethod: json['payment_method'] ?? null,
      witnesses: json['witnesses'] ?? null,
      deedNumber: json['deed_number'] ?? null,
      createdAt: json['created_at'] ?? null,
      updatedAt: json['updated_at'] ?? null,
      deletedAt: json['deleted_at'] ?? null,
      subtype1: json['subtype_1'] ?? null,
      subtype2: json['subtype_2'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registry_entry_id': registryEntryId,
      'constraint_id': constraintId,
      'seller_name': sellerName,
      'seller_national_id': sellerNationalId,
      'buyer_name': buyerName,
      'buyer_national_id': buyerNationalId,
      'sale_type': saleType,
      'sale_subtype': saleSubtype,
      'item_description': itemDescription,
      'sale_area': saleArea,
      'sale_area_qasab': saleAreaQasab,
      'sale_area_sqm': saleAreaSqm,
      'property_type': propertyType,
      'property_location': propertyLocation,
      'property_boundaries': propertyBoundaries,
      'sale_price': salePrice,
      'tax_amount': taxAmount,
      'tax_receipt_number': taxReceiptNumber,
      'zakat_amount': zakatAmount,
      'zakat_receipt_number': zakatReceiptNumber,
      'payment_method': paymentMethod,
      'witnesses': witnesses,
      'deed_number': deedNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'subtype_1': subtype1,
      'subtype_2': subtype2,
    };
  }
}
