class AppConst {
  static const String appName = "Avocado";
  static const List<String> menuItems = <String>[
    ScreenConst.ABOUT,
    ScreenConst.ITEMS,
    ScreenConst.STOCK,
    ScreenConst.SIGN_OUT,
  ];
}

class ScreenConst {
  static const ABOUT = "ABOUT";
  static const ITEMS = "ITEMS";
  static const STOCK = "STOCK";
  static const SIGN_OUT = "SIGN_OUT";
}

class API {
  static const BASE_URL = "http://127.0.0.1:5000/";
  // Item List (GET)
  static const ITEM_LIST = "${BASE_URL}ItemList";
  // Register New Item (POST)
  static const REGISTER_ITEM = "${BASE_URL}RegisterItem";
}
