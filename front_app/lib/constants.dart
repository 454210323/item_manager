import 'widgets/menu_item.dart';

class AppConst {
  static const String appName = "Avocado";
  static List<MenuItem> menuItems = <MenuItem>[
    MenuItem(ScreenConst.HOME),
    MenuItem(ScreenConst.ITEMS),
    MenuItem(ScreenConst.STOCK_SHIPMENT, subItems: [
      MenuItem(ScreenConst.STOCKS),
      MenuItem(ScreenConst.REGISTER_STOCK_SHIPMENT),
      // MenuItem(ScreenConst.REGISTER_SHIPMENT)
    ]),
    MenuItem(ScreenConst.EXTRA_EXPENSE),
    MenuItem(ScreenConst.STOCK_MONITORING),
  ];
}

class ScreenConst {
  static const HOME = "主页";
  static const ITEMS = "商品一览";
  static const STOCK_SHIPMENT = "库存出货";
  static const STOCKS = "库存一览";
  static const REGISTER_STOCK_SHIPMENT = "添加进货出货";
  // static const REGISTER_SHIPMENT = "增加出货";
  static const EXTRA_EXPENSE = "额外消费";
  static const STOCK_MONITORING = "官网库存监控";
}

class API {
  static const STATIC_RESOURCE_URL = "https://static-resource.fly.dev/";

  static const BASE_URL = "http://192.168.0.126:5000/";

  // Item Base Url
  static const ITEM_BASE = "${BASE_URL}Item/";
  // Item Types (GET)
  static const ITEM_TYPES = "${ITEM_BASE}Type/all";
  // Item Serises (GET)
  static const ITEM_SERIES = "${ITEM_BASE}Series/all";
  // Item Infos (GET)
  static const ITEMS = "${ITEM_BASE}Item/all";
  // Item Info (GET)
  static const ITEM = "${ITEM_BASE}Item";

  // Item info (PUT)
  static const Item_JANCODE = "${ITEM_BASE}JanCode";

  // Item info (GET)
  static const ITEM_CONDITIONS = "${ITEM_BASE}Conditions";

  // Item image
  static const ITEM_IMAGE = "${STATIC_RESOURCE_URL}static/images/";

  // Extra Expense Base Url
  static const EXTRA_EXPENSE_BASE = "${BASE_URL}ExtraExpense/";
  // Extra Expense Type
  static const EXTRA_EXPENSE_TYPES = "${EXTRA_EXPENSE_BASE}ExtraExpenseType";
  // Register Extra Expenditure
  static const EXTRA_EXPENSE = "${EXTRA_EXPENSE_BASE}ExtraExpense";
  // Extra Expenditure -get all
  static const EXTRA_EXPENSE_ALL = "${EXTRA_EXPENSE_BASE}ExtraExpense/all";

  // Stock Base Url
  static const STOCK_BASE = "${BASE_URL}Stock/";
  // Stock
  static const STOCK = "${STOCK_BASE}Stock";

  // Stock Shipemnt List (GET)
  static const STOCK_SHIPMENT_INFOS = "${STOCK_BASE}StockShipmentInfos";

  static const STOCK_SHIPMENT_INFOS_V2 = "${STOCK_BASE}v2/StockShipmentInfos";

  // Shipment Base Url
  static const SHIPMENT_BASE = "${BASE_URL}Shipment/";

  // Shipment Date
  static const SHIPMENT_DATE = "${SHIPMENT_BASE}ShipmentDate";

  // Shipment (POST)
  static const SHIPMENT = "${SHIPMENT_BASE}Shipment";
  // Recipient (GET)
  static const Recipients = "${SHIPMENT_BASE}Recipient/all";

  // Online Store
  static const ONLINE_STORE_BASE = "${BASE_URL}OnlineStore/";

  // Favorite item
  static const FAVORITE_ITEM = "${ONLINE_STORE_BASE}Favorite";

  // Stock Monitoring
  static const STOCK_MONITORING = "${ONLINE_STORE_BASE}StockMonitoring";
}
