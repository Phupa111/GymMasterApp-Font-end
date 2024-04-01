import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_master_fontend/screen/hom_page.dart';
import 'package:gym_master_fontend/screen/login_page.dart';

import 'package:gym_master_fontend/widgets/menu_bar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is signed in
            return const MenuNavBar(); // Just return the widget without MaterialPageRoute
          } else {
            // User is not signed in
            return const LoginPage();
          }
        },
      ),
    );
  }
}
