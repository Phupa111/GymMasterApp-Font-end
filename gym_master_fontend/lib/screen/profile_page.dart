import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gym_master_fontend/screen/login_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  auth.User? currentUser;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    auth.FirebaseAuth.instance.authStateChanges().listen((auth.User? updatedUser) {
      setState(() {
        currentUser = updatedUser;
      });
    });
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void logOut() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      if (prefs != null) {
        await prefs!.remove('uid');
        await prefs!.remove('role');
      }
      Get.to(const LoginPage());
    } catch (e) {
      // Handle sign-out errors
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: currentUser != null ? false : true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: logOut,
              child: const Text("Log Out"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
