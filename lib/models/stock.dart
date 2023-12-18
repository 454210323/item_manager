import 'package:decimal/decimal.dart';

import 'table_item.dart';

class Stock extends TableItem {
  String itemCode;
  String itemName;
  Decimal price;
  int quantity;

  Stock(
      {required this.itemCode,
      required this.itemName,
      required this.price,
      required this.quantity});

  @override
  Map<String, dynamic> toTableData() {
    return {
      'itemCode': itemCode,
      'itemName': itemName,
      'price': price.toString(),
      'quantity': quantity
    };
  }
}
