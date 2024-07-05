import 'package:flutter_application_1/models/table_item.dart';

import '../constants.dart';

class OnlineOrder extends TableItem {
  final String itemCode;
  final String itemName;
  final int shippedQuantity;
  final int totalQuantity;
  final String image;

  OnlineOrder(
      {required this.itemCode,
      required this.itemName,
      required this.shippedQuantity,
      required this.totalQuantity,
      required this.image});

  factory OnlineOrder.fromJson(Map<String, dynamic> json) {
    return OnlineOrder(
        itemCode: json['item_code'],
        itemName: json['item_name'] ?? '',
        shippedQuantity: json['shipped_quantity'],
        totalQuantity: json['total_quantity'],
        image: "${API.ITEM_IMAGE}${json['item_code']}.jpg");
  }

  @override
  Map<String, dynamic> toTableData() {
    return {
      'image': image,
      'itemCode': itemCode,
      'itemName': itemName,
      'shippedQuantity': shippedQuantity,
      'totalQuantity': totalQuantity,
    };
  }

  static const columnsForLargeScreen = [
    'image',
    'itemCode',
    'itemName',
    'shippedQuantity',
    'totalQuantity',
  ];

  static const columnsForMediumScreen = [
    'image',
    'itemName',
    'shippedQuantity',
    'totalQuantity',
  ];

  static const columnsForSmallScreen = [
    'image',
    'shippedQuantity',
    'totalQuantity',
  ];
}
