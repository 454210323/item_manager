import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/register_stock_shipment_page.dart';

import '../constants.dart';
import '../pages/extra_expense_page.dart';
import '../pages/home_page.dart';
import '../pages/item_page.dart';
import '../pages/stocks_page.dart';
import 'expansion_tile.dart';
import 'menu_item.dart';
import 'profile_icon.dart';

class ResponsiveNavBarPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const ResponsiveNavBarPage({Key? key, required this.toggleTheme})
      : super(key: key);

  @override
  State<ResponsiveNavBarPage> createState() => _ResponsiveNavBarPageState();
}

class _ResponsiveNavBarPageState extends State<ResponsiveNavBarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedMenuItem = ScreenConst.HOME;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppConst.appName,
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                if (isLargeScreen) Expanded(child: _navBarItems())
              ],
            ),
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: ProfileIcon()),
            ),
            IconButton(
              icon: const Icon(Icons.brightness_4),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(),
        body: _currentPageContent(_selectedMenuItem));
  }

  Widget _drawer() => Drawer(
        child: ListView(
          children: AppConst.menuItems.map(_buildMenuItem).toList(),
        ),
      );

  Widget _buildMenuItem(MenuItem item) {
    if (item.subItems != null && item.subItems!.isNotEmpty) {
      return CustomExpansionTile(
        title: item.title,
        children: item.subItems!.map(_buildMenuItem).toList(),
      );
    } else {
      return ListTile(
          title: Text(item.title),
          onTap: () {
            Navigator.of(context).pop();
            setState(() {
              _selectedMenuItem = item.title;
            });
          });
    }
  }

  Widget _navBarItems() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: AppConst.menuItems
            .map(
              (item) => InkWell(
                onTap: () {
                  setState(() {
                    _selectedMenuItem = item.title;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: Text(item.title, style: const TextStyle(fontSize: 18)),
                ),
              ),
            )
            .toList(),
      );
}

Widget _currentPageContent(selectedMenuItem) {
  switch (selectedMenuItem) {
    case ScreenConst.HOME:
      return const HomePage();
    case ScreenConst.ITEMS:
      return const ItemPage();
    case ScreenConst.STOCKS:
      return const StocksPage();
    case ScreenConst.REGISTER_STOCK:
      return const RegisterStockShipmentPage();
    case ScreenConst.REGISTER_SHIPMENT:
      return const Text('todo');
    case ScreenConst.EXTRA_EXPENSE:
      return const ExtraExpensePage();
    default:
      return const HomePage();
  }
}
