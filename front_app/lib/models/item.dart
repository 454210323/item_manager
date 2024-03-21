import 'package:decimal/decimal.dart';
import 'package:flutter_application_1/models/table_item.dart';

import '../constants.dart';

class Item extends TableItem {
  final String itemCode;
  final String itemName;
  final String type;
  final String series;
  final Decimal price;
  final String janCode;
  final String image;

  Item(
      {required this.itemCode,
      required this.itemName,
      required this.type,
      required this.series,
      required this.price,
      required this.janCode,
      required this.image});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        itemCode: json['item_code'],
        itemName: json['item_name'],
        type: json['item_type'],
        series: json['series'],
        price: Decimal.parse(json['price'] ?? '0'),
        janCode: json['jan_code'],
        image: "${API.ITEM_IMAGE}${json['item_code']}.jpg");
  }
  @override
  Map<String, dynamic> toTableData() {
    return {
      'itemCode': itemCode,
      'itemName': itemName,
      'type': type,
      'series': series,
      'price': price,
      'janCode': janCode,
      'image': image
    };
  }

  static const columnsForLargeScreen = [
    'itemCode',
    'itemName',
    'type',
    'series',
    'price',
    'janCode',
    'image',
  ];

  static const columnsForMediumScreen = [
    'itemCode',
    'itemName',
    'type',
    'series',
    'price',
    'janCode',
    'image'
  ];

  static const columnsForSmallScreen = ['itemCode', 'itemName', 'image'];
}
