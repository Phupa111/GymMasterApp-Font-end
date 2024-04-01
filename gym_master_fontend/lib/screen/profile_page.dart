import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile"),
        automaticallyImplyLeading: currentUser != null ? false : true,
      ),
    );
  }
}
