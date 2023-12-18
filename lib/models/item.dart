import 'package:decimal/decimal.dart';
import 'package:flutter_application_1/models/table_item.dart';

class Item extends TableItem {
  final String itemCode;
  final String itemName;
  final String type;
  final String series;
  final Decimal price;

  Item(
      {required this.itemCode,
      required this.itemName,
      required this.type,
      required this.series,
      required this.price});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      type: json['item_type'],
      series: json['series'],
      price: Decimal.parse(json['price']),
    );
  }
  @override
  Map<String, dynamic> toTableData() {
    return {
      'itemCode': itemCode,
      'itemName': itemName,
      'type': type,
      'series': series,
      'price': price
    };
  }

  static const columnsForLargeScreen = [
    'itemCode',
    'itemName',
    'type',
    'series',
    'price',
  ];

  static const columnsForMediumScreen = [
    'itemCode',
    'itemName',
    'type',
    'series',
    'price',
  ];

  static const columnsForSmallScreen = [
    'itemCode',
    'itemName',
    'price',
  ];
}
