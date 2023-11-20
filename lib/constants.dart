class AppConst {
  static const String appName = "Avocado";
  static const List<String> menuItems = <String>[
    ScreenConst.ABOUT,
    ScreenConst.ITEMS,
    ScreenConst.SETTIMGS,
    ScreenConst.SIGN_OUT,
  ];
}

class ScreenConst {
  static const ABOUT = "ABOUT";
  static const ITEMS = "ITEMS";
  static const SETTIMGS = "SETTIMGS";
  static const SIGN_OUT = "SIGN_OUT";
}

class API {
  static const BASE_URL = "http://127.0.0.1:5000/";
  // request for Item List
  static const ITEM_LIST = "${BASE_URL}ItemList";
}
