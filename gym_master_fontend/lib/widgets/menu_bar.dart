import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/services/app_const.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_master_fontend/screen/adminScreen/admin_page.dart';
import 'package:gym_master_fontend/screen/exercise_page.dart';
import 'package:gym_master_fontend/screen/hom_page.dart';
import 'package:gym_master_fontend/screen/profile_page.dart';
import 'package:gym_master_fontend/screen/staticScreen/static_page.dart';

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
  int? uid;
  int? isDisble;
  String? tokenJWT;
  String? username;
  String url = AppConstants.BASE_URL;
  UserModel? user;
  late Future<void> loadData;
  @override
  void initState() {
    super.initState();

    _initializeUser();
  }

  void _initializeUser() {
    auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((auth.User? updatedUser) {
      setState(() {
        currentUser = updatedUser;
      });
      _initializePreferences();
    });
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    role = prefs.getInt("role");
    uid = prefs.getInt("uid");
    isDisble = prefs.getInt("isDisbel");
    tokenJWT = prefs.getString("tokenJwt");
    username = prefs.getString("username");

    log("usernaem $username");
    if (role != null) {
      setState(() {
        _updatePageIndexBasedOnRole();
        loadData = loadDataAsync();
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
      const StaticPage(),
      const ExercisePage(),
      const ProfilePage(),
    ];

    final List<Widget> pagesRole2 = [
      const AdminPage(),
      const ProfilePage(),
    ];

    final List<Widget> pagesRole0 = [
      HomePage(),
      const ProfilePage(),
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

    return FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return PopScope(
              canPop: role == 0 || user?.user.isDisbel == 1 ? true : false,
              child: user?.user.isDisbel == 0
                  ? Scaffold(
                      body: role != null
                          ? pages[currentPageIndex]
                          : const Center(child: CircularProgressIndicator()),
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
                    )
                  : Scaffold(
                      appBar: AppBar(),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('บัญชีของคุณถูกปิดใช้งาน'),
                            ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("Login"))
                          ],
                        ),
                      ),
                    ),
            );
          }
        });
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();

    try {
      log("username : $username");

      final response = await dio.get(
        'http://$url/user/getUser/$username',
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJWT',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200) {
        user = userModelFromJson(jsonEncode(response.data));

        log("disble ${user?.user.isDisbel}");
      } else {
        log("Error fetching user data: ${response.statusCode}");
      }
    } catch (e) {
      log("Error during loadDataAsync: $e");
    }
  }
}
