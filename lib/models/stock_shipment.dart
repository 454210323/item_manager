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
    required this.stockQuantity,
    required this.shipmentQuantity,
  });

  factory StockShipment.fromJson(Map<String, dynamic> json) {
    return StockShipment(
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
