import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/auth_page.dart';

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

  void signUserIn() async {
    setState(() {
      _isLoading = true; // Set loading to true when starting the login process
    });

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var regBody = {
        "login": _emailController.text,
        "password": _passwordController.text
      };

      var response = await http.post(
          Uri.parse('http://192.168.1.119:8080/user/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      log(response.toString());
      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        var userEmail = userData['user']['email'];

        var userModel = userModelFromJson(jsonEncode(userData));

        await GetStorage().write('uid', userModel.user.uid);
        await GetStorage().write('role', userModel.user.role);
        // ถ้าล็อกอินสำเร็จ
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: userEmail, password: _passwordController.text);

          Get.to(AuthPage())?.then((_) {
            _emailController.clear();
            _passwordController.clear();
          });
        } catch (e) {
          // Handle sign-in errors
          print("Error signing in: $e");
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print("not sucess");
      }
    }
  }

  void googleSigIn() async {
    setState(() {
      _isLoading = true; // Set loading to true when starting the login process
    });

    final dio = Dio();

    try {
      var user = await AuthService().signInWithGoogle();
      if (user != null) {
        final response = await dio.get(
            'http://192.168.1.119:8080/user/selectFromEmail/${user.email}');
        if (response.statusCode == 200) {
          var responseData = response.data;
          if (responseData is List<dynamic>) {
            List<UserModel> userModelList =
                responseData.map((item) => UserModel.fromJson(item)).toList();
            log(responseData.length.toString());
            if (userModelList.isNotEmpty) {
              Get.to(MenuNavBar());
            } else {
              Get.to(RegisterPage(
                email: user.email.toString(),
              ));
            }
          } else {
            print('Error: Unexpected response data format');
          }
        } else {
          print('Error fetching user data: ${response.statusCode}');
        }
      }
    } catch (e) {
      print("Error signing in: $e");
    } finally {
      setState(() {
        _isLoading = false;
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
                              hintText: 'อีเมล หรือ ชื่อผู้ใช้',
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
                                hintText: 'รหัสผ่าน',
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
                        child: ElevatedButton.icon(
                          onPressed: () {
                            signUserIn();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber[800],
                            fixedSize: const Size(150, 50),
                          ),
                          icon: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.login,
                                  color: Colors.white,
                                ),
                          label: const Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
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
                                    Get.to(MenuNavBar());
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
                            'ยังไม่เป็นสมาชิก ?',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(RegisterPage(
                                  email: "",
                                ));
                              },
                              child: const Text(
                                'ลงทะเบียน',
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
