import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/login_page.dart';

class HomePage extends StatefulWidget {
  int? uid;
  int? roleid;
  HomePage({Key? key, this.uid, this.roleid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User?
      currentUser; // Correctly declare a User? object to hold the current user

  @override
  void initState() {
    super.initState();
    // Listen to the authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? updatedUser) {
      setState(() {
        currentUser =
            updatedUser; // Update the currentUser with the updated user
      });
    });
  }

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      // After signing out, navigate to a login or start page
      // You can replace the MaterialPageRoute and choose the appropriate page
      Get.to(const LoginPage());
    } catch (e) {
      // Handle sign-out errors
      print("Error signing out: $e");
      // Add your error handling logic here, such as displaying an error message
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
                  ? "Logged in as ${currentUser!.email}  ${widget.uid} ${widget.roleid}" // Use currentUser to access the email
                  : "Guset",
            ),
          ),
        ],
      ),
    );
  }
}
