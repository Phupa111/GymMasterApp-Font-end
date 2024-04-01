import 'package:flutter/material.dart';
import 'package:gym_master_fontend/screen/exercise_page.dart';
import 'package:gym_master_fontend/screen/hom_page.dart';
import 'package:gym_master_fontend/screen/profile_page.dart';
import 'package:gym_master_fontend/screen/static_page.dart';

class MenuNavBar extends StatefulWidget {
  const MenuNavBar({super.key});

  @override
  State<MenuNavBar> createState() => _MenuNavBarState();
}

class _MenuNavBarState extends State<MenuNavBar> {
  int currentPageIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    StaticPage(),
    ExercisePage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _pages[currentPageIndex],
        bottomNavigationBar: NavigationBar(
          indicatorShape: CircleBorder(),
          backgroundColor: Colors.orange,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.stacked_bar_chart_outlined),
              label: 'Static',
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_run),
              label: 'Exercise',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle),
              label: 'profile',
            ),
          ],
        ),
      ),
    );
  }
}
