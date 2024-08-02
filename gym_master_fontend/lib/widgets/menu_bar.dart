import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_master_fontend/screen/adminScreen/admin_page.dart';
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
  auth.User? currentUser;
  late SharedPreferences prefs;
  int? role;

  @override
  void initState() {
    super.initState();
    _initializeNotificationService();
    _initializeUser();
  }

  Future<void> _initializeNotificationService() async {
    
    DateTime scheduledDate = DateTime.now();
 
  }

  void _initializeUser() {
    auth.FirebaseAuth.instance.authStateChanges().listen((auth.User? updatedUser) {
      setState(() {
        currentUser = updatedUser;
      });
      _initializePreferences();
    });
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    role = prefs.getInt("role");
    if (role != null) {
      setState(() {
        _updatePageIndexBasedOnRole();
      });
    }
  }

  void _updatePageIndexBasedOnRole() {
    if (role == 1 && currentPageIndex >= 4) {
      currentPageIndex = 0;
    } else if (role == 2 && currentPageIndex >= 2) {
      currentPageIndex = 0;
    } else if (role == 0 && currentPageIndex >= 2) {
      currentPageIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pagesRole1 = [
      HomePage(),
      StaticPage(),
      ExercisePage(),
      ProfilePage(),
    ];

    final List<Widget> pagesRole2 = [
      AdminPage(),
      ProfilePage(),
    ];

    final List<Widget> pagesRole0 = [
      HomePage(),
      ProfilePage(),
    ];

    final List<Widget> pages;
    if (role == 1) {
      pages = pagesRole1;
    } else if (role == 2) {
      pages = pagesRole2;
    } else {
      pages = pagesRole0;
    }

    // Ensure there are at least two destinations
    final List<NavigationDestination> destinations;
    if (role == 1) {
      destinations = const <NavigationDestination>[
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
          label: 'Profile',
        ),
      ];
    } else if (role == 2) {
      destinations = const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Admin',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ];
    } else {
      destinations = const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ];
    }

    return PopScope(
      canPop:  role ==0 ?true:false,
      child: Scaffold(
        body: role != null ? pages[currentPageIndex] : Center(child: CircularProgressIndicator()),
        bottomNavigationBar: NavigationBar(
          indicatorShape: const CircleBorder(),
          backgroundColor: Colors.orange,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: destinations,
        ),
      ),
    );
  }
}
