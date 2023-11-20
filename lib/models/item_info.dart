class ItemInfo {
  final String itemNo;
  final String itemName;
  final int itemPrice;

  ItemInfo(
      {required this.itemNo, required this.itemName, required this.itemPrice});

  factory ItemInfo.fromJson(Map<String, dynamic> json) {
    return ItemInfo(
      itemNo: json['item_no'],
      itemName: json['item_name'],
      itemPrice: json['item_price'],
    );
  }
}
