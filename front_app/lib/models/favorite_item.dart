import 'package:flutter_application_1/models/table_item.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class FavoriteItem extends TableItem {
  @override
  final String itemCode;
  @override
  final String itemName;
  final DateTime checkTime;
  final int stockQuantity;
  final String image;

  FavoriteItem(
      {required this.itemCode,
      required this.itemName,
      required this.checkTime,
      required this.stockQuantity,
      required this.image});

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
        itemCode: json['item_code'],
        itemName: json['item_name'],
        checkTime: DateTime.parse(json['check_datetime']),
        stockQuantity: json['stock_quantity'],
        image: "${API.ITEM_IMAGE}${json['item_code']}.jpg");
  }
  @override
  Map<String, dynamic> toTableData() {
    return {
      'image': image,
      'itemName': itemName,
      'itemCode': itemCode,
      'checkTime': DateFormat('yyyy-MM-dd – HH:mm:ss').format(checkTime),
      'stockQuantity': stockQuantity,
    };
  }

  static const columnsForLargeScreen = [
    'image',
    'itemName',
    'itemCode',
    'checkTime',
    'stockQuantity',
  ];

  static const columnsForMediumScreen = [
    'image',
    'itemName',
    'itemCode',
    'checkTime',
    'stockQuantity',
  ];

  static const columnsForSmallScreen = ['image', 'checkTime', 'stockQuantity'];
}
