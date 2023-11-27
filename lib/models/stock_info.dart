import 'item_info.dart';

class StockShipmentInfo extends ItemInfo {
  final int stockQuantity;
  final int shipmentQuantity;

  StockShipmentInfo({
    required super.itemCode,
    required super.itemName,
    required super.type,
    required super.series,
    required super.price,
    required this.stockQuantity,
    required this.shipmentQuantity,
  });

  factory StockShipmentInfo.fromJson(Map<String, dynamic> json) {
    return StockShipmentInfo(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      type: json['item_type'],
      series: json['series'],
      price: json['price'],
      stockQuantity: json['stock_quantity'],
      shipmentQuantity: json['shipment_quantity'],
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
    'stockQuantity',
    'shipmentQuantity',
  ];

  static const columnsForMediumScreen = [
    'itemCode',
    'itemName',
    'type',
    'series',
    'stockQuantity',
    'shipmentQuantity',
  ];

  static const columnsForSmallScreen = [
    'itemName',
    'type',
    'series',
    'stockQuantity',
  ];
}
