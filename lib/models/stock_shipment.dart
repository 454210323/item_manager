import 'package:decimal/decimal.dart';

import '../constants.dart';
import 'item.dart';

class StockShipment extends Item {
  final int stockQuantity;
  final int shipmentQuantity;

  StockShipment({
    required super.itemCode,
    required super.itemName,
    required super.type,
    required super.series,
    required super.price,
    required super.janCode,
    required super.image,
    required this.stockQuantity,
    required this.shipmentQuantity,
  });

  factory StockShipment.fromJson(Map<String, dynamic> json) {
    return StockShipment(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      type: json['item_type'],
      series: json['series'],
      price: Decimal.parse(json['price']),
      janCode: json['jan_code'],
      image: "${API.ITEM_IMAGE}${json['item_code']}.jpg",
      stockQuantity: int.parse(json['stock_quantity']),
      shipmentQuantity: int.parse(json['shipment_quantity']),
    );
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
      'image': image,
      'stockQuantity': stockQuantity,
      'shipmentQuantity': shipmentQuantity
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
    'stockQuantity',
    'shipmentQuantity',
  ];

  static const columnsForMediumScreen = [
    'itemCode',
    'itemName',
    'type',
    'series',
    'image',
    'stockQuantity',
    'shipmentQuantity',
  ];

  static const columnsForSmallScreen = [
    'itemName',
    'image',
    'stockQuantity',
    'shipmentQuantity',
  ];
}
