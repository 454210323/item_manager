import 'item_info.dart';

class StockInfo extends ItemInfo {
  final int stockQuantity;
  final int shipmentQuantity;

  StockInfo({
    required super.itemCode,
    required super.itemName,
    required super.itemPrice,
    required this.stockQuantity,
    required this.shipmentQuantity,
  });

  factory StockInfo.fromJson(Map<String, dynamic> json) {
    return StockInfo(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      itemPrice: json['item_price'],
      stockQuantity: json['stock_quantity'],
      shipmentQuantity: json['shipment_quantity'],
    );
  }
}
