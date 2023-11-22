import 'item_info.dart';

class StockShipmentInfo extends ItemInfo {
  final int stockQuantity;
  final int shipmentQuantity;

  StockShipmentInfo({
    required super.itemCode,
    required super.itemName,
    required super.price,
    required this.stockQuantity,
    required this.shipmentQuantity,
  });

  factory StockShipmentInfo.fromJson(Map<String, dynamic> json) {
    return StockShipmentInfo(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      price: json['price'],
      stockQuantity: json['stock_quantity'],
      shipmentQuantity: json['shipment_quantity'],
    );
  }
}
