class AppConst {
  static const String appName = "Avocado";
  static const List<String> menuItems = <String>[
    ScreenConst.ABOUT,
    ScreenConst.ITEMS,
    ScreenConst.STOCK_SHIPMENT,
    ScreenConst.EXTRA_EXPENDITURE,
  ];
}

class ScreenConst {
  static const ABOUT = "ABOUT";
  static const ITEMS = "ITEMS";
  static const STOCK_SHIPMENT = "STOCK SHIPMENT";
  static const EXTRA_EXPENDITURE = "EXTRA EXPENDITURE";
}

class API {
  static const BASE_URL = "http://127.0.0.1:5000/";
  // Item Types (GET)
  static const ITEM_TYPES = "${BASE_URL}ItemTypes";
// Item Serises (GET)
  static const ITEM_SERIES = "${BASE_URL}ItemSeries";
  // Item Infos (GET)
  static const ITEM_INFOS = "${BASE_URL}ItemInfos";
  // Register New Item (POST)
  static const REGISTER_ITEM = "${BASE_URL}RegisterItem";
  // Stock Shipemnt List (GET)
  static const STOCK_SHIPMENT_INFOS = "${BASE_URL}StockShipmentInfos";
}
