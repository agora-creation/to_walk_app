import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/providers/steps.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/screens/game.dart';
import 'package:to_walk_app/screens/history.dart';
import 'package:to_walk_app/screens/room.dart';
import 'package:to_walk_app/screens/setting.dart';
import 'package:to_walk_app/widgets/custom_bottom_bar.dart';
import 'package:to_walk_app/widgets/custom_footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _items = [
    const RoomScreen(),
    const HistoryScreen(),
    const GameScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final stepsProvider = Provider.of<StepsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: _items[_selectedIndex],
      bottomNavigationBar: CustomBottomBar(
        tabs: const [
          GButton(
            icon: Icons.home_rounded,
            text: '？？？',
          ),
          GButton(
            icon: Icons.calendar_month_rounded,
            text: '記録',
          ),
          GButton(
            icon: Icons.interests_rounded,
            text: '遊ぶ',
          ),
          GButton(
            icon: Icons.settings_rounded,
            text: '設定',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      bottomSheet: CustomFooter(
        stepsProvider: stepsProvider,
        userProvider: userProvider,
      ),
    );
  }
}
