import 'item_info.dart';

class StockShipmentInfo extends ItemInfo {
  final int stockQuantity;
  final int shipmentQuantity;

  StockShipmentInfo({
    required super.itemCode,
    required super.itemName,
    required super.type,
    required super.serise,
    required super.price,
    required this.stockQuantity,
    required this.shipmentQuantity,
  });

  factory StockShipmentInfo.fromJson(Map<String, dynamic> json) {
    return StockShipmentInfo(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      type: json['type'],
      serise: json['serise'],
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
      'serise': serise,
      'price': price,
      'stockQuantity': stockQuantity,
      'shipmentQuantity': shipmentQuantity
    };
  }

  static const columnsForLargeScreen = [
    'itemCode',
    'itemName',
    'type',
    'serise',
    'price',
    'stockQuantity',
    'shipmentQuantity',
  ];

  static const columnsForMediumScreen = [
    'itemCode',
    'itemName',
    'type',
    'serise',
    'stockQuantity',
    'shipmentQuantity',
  ];

  static const columnsForSmallScreen = [
    'itemName',
    'type',
    'serise',
    'stockQuantity',
  ];
}
