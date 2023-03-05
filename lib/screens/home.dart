import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:to_walk_app/widgets/custom_nav_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView.custom(
        context,
        controller: _controller,
        itemCount: 4,
        screens: _buildScreens(),
        confineInSafeArea: true,
        handleAndroidBackButtonPress: false,
        customWidget: CustomNavBarWidget(
          items: _navBarsItems(),
          selectedIndex: _controller.index,
          onItemSelected: (index) {
            setState(() {
              _controller.index = index;
            });
          },
        ),
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [
    Container(),
    Container(),
    Container(),
    Container(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: ("？？？"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.auto_graph),
      title: ("記録"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.games),
      title: ("遊ぶ"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.settings),
      title: ("設定"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
