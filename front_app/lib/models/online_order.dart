import 'package:flutter_application_1/models/table_item.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class OnlineOrder extends TableItem {
  final String itemCode;
  final String itemName;
  final int shippedQuantity;
  final int totalQuantity;
  final String image;
  final DateTime earliestOrderDate;

  OnlineOrder(
      {required this.itemCode,
      required this.itemName,
      required this.shippedQuantity,
      required this.totalQuantity,
      required this.image,
      required this.earliestOrderDate});

  factory OnlineOrder.fromJson(Map<String, dynamic> json) {
    return OnlineOrder(
        itemCode: json['item_code'],
        itemName: json['item_name'] ?? '',
        shippedQuantity: json['shipped_quantity'],
        totalQuantity: json['total_quantity'],
        image: "${API.ITEM_IMAGE}${json['item_code']}.jpg",
        earliestOrderDate: DateTime.parse(json['earliest_order_date']));
  }

  @override
  Map<String, dynamic> toTableData() {
    return {
      'image': image,
      'itemCode': itemCode,
      'itemName': itemName,
      'shippedQuantity': shippedQuantity,
      'totalQuantity': totalQuantity,
      'earliestOrderDate': DateFormat('yyyy-MM-dd').format(earliestOrderDate)
    };
  }

  static const columnsForLargeScreen = [
    'image',
    'itemCode',
    'itemName',
    'shippedQuantity',
    'totalQuantity',
    'earliestOrderDate'
  ];

  static const columnsForMediumScreen = [
    'image',
    'itemName',
    'shippedQuantity',
    'totalQuantity',
    'earliestOrderDate'
  ];

  static const columnsForSmallScreen = [
    'image',
    'shippedQuantity',
    'totalQuantity',
  ];
}
