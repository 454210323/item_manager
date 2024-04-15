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
      image: "${API.ITEM_IMAGE}${json['item_code']}.jpg",
      stockQuantity: int.parse(json['stock_quantity']),
      shipmentQuantity: int.parse(json['shipment_quantity']),
    );
  }
  @override
  Map<String, dynamic> toTableData() {
    return {
      'image': image,
      'itemCode': itemCode,
      'itemName': itemName,
      'type': type,
      'series': series,
      'price': price,
      'stockQuantity': stockQuantity,
      'shipmentQuantity': shipmentQuantity
    };
  }

  static const columnsForLargeScreen = [
    'image',
    'itemCode',
    'itemName',
    'type',
    'series',
    'price',
    'stockQuantity',
    'shipmentQuantity',
  ];

  static const columnsForMediumScreen = [
    'image',
    'itemCode',
    'itemName',
    'type',
    'series',
    'stockQuantity',
    'shipmentQuantity',
  ];

  static const columnsForSmallScreen = [
    'image',
    'stockQuantity',
    'shipmentQuantity',
  ];
}
