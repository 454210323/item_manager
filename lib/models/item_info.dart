class ItemInfo {
  final String itemCode;
  final String itemName;
  final int itemPrice;

  ItemInfo(
      {required this.itemCode,
      required this.itemName,
      required this.itemPrice});

  factory ItemInfo.fromJson(Map<String, dynamic> json) {
    return ItemInfo(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      itemPrice: json['item_price'],
    );
  }
}
