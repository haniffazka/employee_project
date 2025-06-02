class PoDetail {
  final int lineNo;
  final String itemCode;
  final String item;
  final String description;
  final double quantity;
  final String uom;
  final double unitPrice;
  final double amount;
  final double discount;
  final double subtotal;
  final String expiredDate;

  PoDetail({
    required this.lineNo,
    required this.itemCode,
    required this.item,
    required this.description,
    required this.quantity,
    required this.uom,
    required this.unitPrice,
    required this.amount,
    required this.discount,
    required this.subtotal,
    required this.expiredDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'lineNo': lineNo,
      'itemCode': itemCode,
      'item': item,
      'description': description,
      'quantity': quantity,
      'uom': uom,
      'unitPrice': unitPrice,
      'amount': amount,
      'discount': discount,
      'subtotal': subtotal,
      'expiredDate': expiredDate,
    };
  }

  factory PoDetail.fromMap(Map<String, dynamic> map) {
    return PoDetail(
      lineNo: map['lineNo'] ?? 0,
      itemCode: map['itemCode'] ?? '',
      item: map['item'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 0.0,
      uom: map['uom'] ?? '',
      unitPrice: map['unitPrice'] ?? 0.0,
      amount: map['amount'] ?? 0.0,
      discount: map['discount'] ?? 0.0,
      subtotal: map['subtotal'] ?? 0.0,
      expiredDate: map['expiredDate'] ?? '',
    );
  }
}