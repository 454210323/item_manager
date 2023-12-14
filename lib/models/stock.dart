import 'package:decimal/decimal.dart';

import 'table_item.dart';

class Stock extends TableItem {
  String itemCode;
  Decimal price;
  int quantity;
  DateTime purchaseDate;

  Stock(
      {required this.itemCode,
      required this.price,
      required this.quantity,
      required this.purchaseDate});

  @override
  Map<String, dynamic> toTableData() {
    return {
      'itemCode': itemCode,
      'price': price,
      'quantity': quantity,
      'purchaseDate': purchaseDate
    };
  }
}
