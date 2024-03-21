import 'package:decimal/decimal.dart';

import 'table_item.dart';

class Stock extends TableItem {
  String itemCode;
  String itemName;
  String image;
  Decimal price;
  int quantity;

  Stock(
      {required this.itemCode,
      required this.itemName,
      required this.image,
      required this.price,
      required this.quantity});

  @override
  Map<String, dynamic> toTableData() {
    return {
      // 'itemCode': itemCode,
      'itemName': itemName,
      'image': image,
      'price': price.toString(),
      'quantity': quantity
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'itemCode': itemCode,
      'itemName': itemName,
      'image': image,
      'price': price.toString(),
      'quantity': quantity
    };
  }
}
