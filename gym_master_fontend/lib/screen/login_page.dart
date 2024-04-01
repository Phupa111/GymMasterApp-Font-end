import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/captchaPage.dart';
import 'package:gym_master_fontend/screen/register_page/register_page.dart';
import 'package:gym_master_fontend/services/auth_service.dart';
import 'package:gym_master_fontend/widgets/header_container.dart';
import 'package:gym_master_fontend/widgets/menu_bar.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false; // Initially not loading
  }

  // void signUserIn() async {
  //   setState(() {
  //     _isLoading = true; // Set loading to true when starting the login process
  //   });

  //   if (_emailController.text.isNotEmpty &&
  //       _passwordController.text.isNotEmpty) {
  //     var regBody = {
  //       "login": _emailController.text,
  //       "password": _passwordController.text
  //     };

  //     var response = await http.post(
  //         Uri.parse('http://192.168.175.2:8080/user/login'),
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(regBody));

  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       var userData = jsonDecode(response.body);
  //       var userEmail = userData['user']['email'];
  //       // ถ้าล็อกอินสำเร็จ
  //       try {
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //             email: userEmail, password: _passwordController.text);

  //         // Navigate to MenuNavBar after successful sign-in
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => MenuNavBar()),
  //         ).then((_) {
  //           // Optional: You can perform additional actions after navigating
  //           // For example, you can clear the text fields or update the UI
  //           _emailController.clear();
  //           _passwordController.clear();
  //         });
  //       } catch (e) {
  //         // Handle sign-in errors
  //         print("Error signing in: $e");
  //         // Add your error handling logic here, such as displaying an error message
  //       } finally {
  //         setState(() {
  //           _isLoading =
  //               false; // Set loading to false when the login process is complete
  //         });
  //       }
  //     } else {
  //       print("not sucess");
  //     }
  //   }
  // }

  void googleSigIn() async {
    setState(() {
      _isLoading = true; // Set loading to true when starting the login process
    });

    try {
      User? user = await AuthService().signInWithGoogle();
      if (user != null) {
        // Navigate to MenuNavBar after successful sign-in
        Get.to(MenuNavBar());
      }
    } catch (e) {
      // Handle sign-in errors
      log("Error signing in: $e");
      // Add your error handling logic here, such as displaying an error message
    } finally {
      setState(() {
        _isLoading =
            false; // Set loading to false when the login process is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0.0, -40.0),
                  child: Column(
                    children: [
                      HeaderContainer(pageName: "Login"),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey), // Default border color
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email or Username',
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.orange,
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: 'Kanit',
                                color: Colors.orange,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors
                                        .orange), // Change border color on focus
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16)),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.key,
                                  color: Colors.orange,
                                ),
                                hintText: 'Password',
                                hintStyle: const TextStyle(
                                    fontFamily: 'Kanit', color: Colors.orange),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .orange), // Change border color on focus
                                  borderRadius: BorderRadius.circular(16),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amber[800],
                                fixedSize: const Size(150, 50)),
                            child: const Text('Login',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Kanit'))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    googleSigIn();
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.google,
                                    color: Colors.orange,
                                  )),
                              const Text(
                                "Google",
                                style: TextStyle(color: Colors.orange),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.to(const MenuNavBar());
                                  },
                                  icon: const Icon(
                                    Icons.person,
                                    color: Colors.orange,
                                  )),
                              const Text(
                                "Guest",
                                style: TextStyle(color: Colors.orange),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member?',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(const RegisterPage());
                              },
                              child: const Text(
                                'Register now',
                                style: TextStyle(color: Colors.orange),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
