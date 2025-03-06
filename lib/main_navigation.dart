import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'features/home/views/home_screen.dart';
import 'features/write/views/write_screen.dart';

class MainNavigation extends StatefulWidget {
  static const String routeName = "mainNavigation";
  final String tab;

  const MainNavigation({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final List<String> _tabs = [
    "home",
    "write",
  ];
  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) async {
    if (_selectedIndex == index) return;

    context.go("/${_tabs[index]}");

    setState(() {
      _selectedIndex = index;
      print(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const WriteScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.yellow.shade100,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.house,
              ),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                _selectedIndex == 1
                    ? FontAwesomeIcons.solidPenToSquare
                    : FontAwesomeIcons.penToSquare,
              ),
              label: 'post',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black45,
          onTap: _onTap,
        ),
      ),
    );
  }
}
