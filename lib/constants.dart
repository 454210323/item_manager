import 'widgets/menu_item.dart';

class AppConst {
  static const String appName = "Avocado";
  static List<MenuItem> menuItems = <MenuItem>[
    MenuItem(ScreenConst.HOME),
    MenuItem(ScreenConst.ITEMS),
    MenuItem(ScreenConst.STOCK_SHIPMENT, subItems: [
      MenuItem(ScreenConst.STOCKS),
      MenuItem(ScreenConst.REGISTER_STOCK),
      MenuItem(ScreenConst.REGISTER_SHIPMENT)
    ]),
    MenuItem(ScreenConst.EXTRA_EXPENSE),
  ];
}

class ScreenConst {
  static const HOME = "主页";
  static const ITEMS = "商品一览";
  static const STOCK_SHIPMENT = "库存出货";
  static const STOCKS = "库存一览";
  static const REGISTER_STOCK = "增加库存";
  static const REGISTER_SHIPMENT = "增加出货";
  static const EXTRA_EXPENSE = "额外消费";
}

class API {
  static const BASE_URL = "http://127.0.0.1:5000/";

  // Item Base Url
  static const ITEM_BASE = "${BASE_URL}Item/";
  // Item Types (GET)
  static const ITEM_TYPES = "${BASE_URL}ItemTypes";
  // Item Serises (GET)
  static const ITEM_SERIES = "${BASE_URL}ItemSeries";
  // Item Infos (GET)
  static const ITEM = "${ITEM_BASE}Item";
  // Register New Item (POST)
  static const REGISTER_ITEM = "${BASE_URL}RegisterItem";

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
  static const STOCK_SHIPMENT_INFOS = "${BASE_URL}StockShipmentInfos";
}
