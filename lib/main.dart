import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/about_page.dart';
import 'package:flutter_application_1/widgets/contact_page.dart';
import 'package:flutter_application_1/widgets/home_page.dart';
import 'package:flutter_application_1/widgets/setting_page.dart';
import 'package:flutter_application_1/widgets/signout_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: isDarkMode ? darkTheme : lightTheme,
      home: ResponsiveNavBarPage(toggleTheme: toggleTheme),
    );
  }
}

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
                  "Logo",
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
              child: CircleAvatar(child: _ProfileIcon()),
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
          children: _menuItems
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
        children: _menuItems
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

final List<String> _menuItems = <String>[
  'About',
  'Contact',
  'Settings',
  'Sign Out',
];

enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person),
        offset: const Offset(0, 40),
        onSelected: (Menu item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              const PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: Text('Account'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemTwo,
                child: Text('Settings'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemThree,
                child: Text('Sign Out'),
              ),
            ]);
  }
}

final ThemeData lightTheme =
    ThemeData(brightness: Brightness.light, useMaterial3: true);

final ThemeData darkTheme =
    ThemeData(brightness: Brightness.dark, useMaterial3: true);

Widget _currentPageContent(selectedMenuItem) {
  switch (selectedMenuItem) {
    case 'About':
      return const AboutPage();
    case 'Contact':
      return const ContactPage();
    case 'Settings':
      return const SettingsPage();
    case 'Sign Out':
      return const SignOutPage();
    default:
      return const HomePage();
  }
}
