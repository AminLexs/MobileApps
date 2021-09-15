import 'package:flutter/material.dart';
import 'package:laba3/CPUsScreen.dart';
import 'package:laba3/MapScreen.dart';
import 'package:laba3/SettingsScreen.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:provider/provider.dart';




class AppTabBar extends StatefulWidget {
  AppTabBar({Key key}) : super(key: key);

  @override
  _AppTabBarState createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> myTabs = <BottomNavigationBarItem>[];

  static List<Widget> _widgetOptions = <Widget>[
    CPUsScreen(),
    MapScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    myTabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.crop_square), label: context.read<LocaleModel>().getString("users")),
      BottomNavigationBarItem(icon: Icon(Icons.map), label: context.read<LocaleModel>().getString("map")),
      BottomNavigationBarItem(icon: Icon(Icons.settings_applications_outlined), label: context.read<LocaleModel>().getString("settings")),
    ];

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: myTabs,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ));
  }
}
