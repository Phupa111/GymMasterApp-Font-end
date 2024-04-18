import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/login_page.dart';

class HomePage extends StatefulWidget {
  int? uid = 0;
  HomePage({Key? key,this.uid }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  auth.User? currentUser;
 int uid =0;
 
  late Future<void> loadData ;
   GetStorage gs = GetStorage();
   late UserModel  userModel = gs.read('userModel'); 
  @override
  void initState() {
    super.initState();
    // Listen to the authentication state changes
    auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((auth.User? updatedUser) {
      setState(() {
        currentUser = updatedUser;
      });
    });

   
 
  }

  void logOut() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
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
        title: const Text("Home"),
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
          Center(
            child: Text(
              currentUser != null
                  ? "Logged in as ${currentUser!.email} ${userModel.user.uid} ${userModel.user.isDisbel}"
                  : "Guest",
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> loadDataAsync() async {
  //   if (currentUser == null) {
  //     return; // Return early if currentUser is null
  //   }

  //   final dio = Dio();
  //   final response = await dio.get(
  //       'http://192.168.1.125:8080/user/selectFromEmail/${currentUser!.email}');

  //   if (response.statusCode == 200) {
  //     await GetStorage().write('uid', userModel.uid);
  //     await GetStorage().write('role', userModel.role);
  //     log("Success");
  //   }
  // }
}
