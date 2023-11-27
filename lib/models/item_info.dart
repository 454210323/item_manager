import 'package:flutter_application_1/models/table_item.dart';

class ItemInfo extends TableItem {
  final String itemCode;
  final String itemName;
  final String type;
  final String serise;
  final int price;

  ItemInfo(
      {required this.itemCode,
      required this.itemName,
      required this.type,
      required this.serise,
      required this.price});

  factory ItemInfo.fromJson(Map<String, dynamic> json) {
    return ItemInfo(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      type: json['type'],
      serise: json['serise'],
      price: json['price'],
    );
  }
  @override
  Map<String, dynamic> toTableData() {
    return {
      'itemCode': itemCode,
      'itemName': itemName,
      'type': type,
      'serise': serise,
      'price': price
    };
  }

  static const columnsForLargeScreen = [
    'itemCode',
    'itemName',
    'type',
    'serise',
    'price',
  ];

  static const columnsForMediumScreen = [
    'itemCode',
    'itemName',
    'type',
    'serise',
    'price',
  ];

  static const columnsForSmallScreen = [
    'itemCode',
    'itemName',
    'price',
  ];
}
