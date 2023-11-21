import 'package:flutter/material.dart';

import '../constants.dart';
import '../pages/about_page.dart';
import '../pages/home_page.dart';
import '../pages/item_page.dart';
import '../pages/stock_page.dart';
import '../pages/signout_page.dart';
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
  String _selectedMenuItem = 'Home';
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
          children: AppConst.menuItems
              .map((item) => ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _selectedMenuItem = item;
                      });
                    },
                    title: Text(item),
                  ))
              .toList(),
        ),
      );

  Widget _navBarItems() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: AppConst.menuItems
            .map(
              (item) => InkWell(
                onTap: () {
                  setState(() {
                    _selectedMenuItem = item;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: Text(item, style: const TextStyle(fontSize: 18)),
                ),
              ),
            )
            .toList(),
      );
}

Widget _currentPageContent(selectedMenuItem) {
  switch (selectedMenuItem) {
    case ScreenConst.ABOUT:
      return const AboutPage();
    case ScreenConst.ITEMS:
      return const ItemPage();
    case ScreenConst.STOCK:
      return const StockPage();
    case ScreenConst.SIGN_OUT:
      return const SignOutPage();
    default:
      return const HomePage();
  }
}
