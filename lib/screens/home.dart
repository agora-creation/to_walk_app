import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/models/user_alk.dart';
import 'package:to_walk_app/providers/steps.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/screens/game.dart';
import 'package:to_walk_app/screens/history.dart';
import 'package:to_walk_app/screens/room.dart';
import 'package:to_walk_app/screens/setting.dart';
import 'package:to_walk_app/widgets/custom_bottom_bar.dart';
import 'package:to_walk_app/widgets/custom_footer.dart';

class HomeScreen extends StatefulWidget {
  final int index;

  const HomeScreen({
    this.index = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectIndex = 0;
  final List<Widget> _items = [
    const RoomScreen(),
    const HistoryScreen(),
    const GameScreen(),
    const SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final stepsProvider = Provider.of<StepsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    UserAlkModel? alk = userProvider.alk;

    return Scaffold(
      body: _items[_selectIndex],
      bottomNavigationBar: CustomBottomBar(
        tabs: [
          GButton(
            icon: Icons.home_rounded,
            text: alk?.getRoomName() ?? '',
          ),
          const GButton(
            icon: Icons.calendar_month_rounded,
            text: '記録',
          ),
          const GButton(
            icon: Icons.interests_rounded,
            text: '遊ぶ',
          ),
          const GButton(
            icon: Icons.settings_rounded,
            text: '設定',
          ),
        ],
        selectedIndex: _selectIndex,
        onTabChange: (index) {
          setState(() => _selectIndex = index);
        },
      ),
      bottomSheet: CustomFooter(
        stepsProvider: stepsProvider,
        userProvider: userProvider,
      ),
    );
  }
}
