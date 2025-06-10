class PoHeader {
  String purchaseOrderNo;
  String poType;
  String currency;
  String supplierCode;
  String description;
  String createdBy;
  String confirmedBy;
  String maxIdentifierNo;

  PoHeader({
    required this.purchaseOrderNo,
    required this.poType,
    required this.currency,
    required this.supplierCode,
    required this.description,
    required this.createdBy,
    required this.confirmedBy,
    required this.maxIdentifierNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'purchaseOrderNo': purchaseOrderNo,
      'poType': poType,
      'currency': currency,
      'supplierCode': supplierCode,
      'description': description,
      'createdBy': createdBy,
      'confirmedBy': confirmedBy,
      'maxIdentifierNo': maxIdentifierNo,
    };
  }

  factory PoHeader.fromMap(Map<String, dynamic> map) {
    return PoHeader(
      purchaseOrderNo: map['purchaseOrderNo'] ?? '',
      poType: map['poType'] ?? '',
      currency: map['currency'] ?? '',
      supplierCode: map['supplierCode'] ?? '',
      description: map['description'] ?? '',
      createdBy: map['createdBy'] ?? '',
      confirmedBy: map['confirmedBy'] ?? '',
      maxIdentifierNo: map['maxIdentifierNo'] ?? '',
    );
  }
}