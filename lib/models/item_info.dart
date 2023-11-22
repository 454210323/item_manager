class ItemInfo {
  final String itemCode;
  final String itemName;
  final int price;

  ItemInfo(
      {required this.itemCode, required this.itemName, required this.price});

  factory ItemInfo.fromJson(Map<String, dynamic> json) {
    return ItemInfo(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      price: json['price'],
    );
  }
}
