import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/UserModel.dart';

import 'package:gym_master_fontend/screen/exercise_page.dart';
import 'package:gym_master_fontend/screen/hom_page.dart';
import 'package:gym_master_fontend/screen/profile_page.dart';
import 'package:gym_master_fontend/screen/static_page.dart';

class MenuNavBar extends StatefulWidget {
  MenuNavBar({super.key});

  @override
  State<MenuNavBar> createState() => _MenuNavBarState();
}

class _MenuNavBarState extends State<MenuNavBar> {
  int currentPageIndex = 0;
  late int uid;
  late int roleid;
  GetStorage gs = GetStorage();
  @override
  void initState() {
    super.initState();
    // อ่านค่าใน GetStorage เพื่ออัปเดตข้อมูลในหน้าจอ
    updateStorageData();
  }

  void updateStorageData() {
    setState(() {
      uid = gs.read('uid') ?? 0; // Use 0 as the default value if 'uid' is null
      roleid =
          gs.read('role') ?? 0; // Use 0 as the default value if 'role' is null
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(),
      StaticPage(),
      ExercisePage(),
      ProfilePage()
    ];
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _pages[currentPageIndex],
        bottomNavigationBar: NavigationBar(
          indicatorShape: const CircleBorder(),
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
