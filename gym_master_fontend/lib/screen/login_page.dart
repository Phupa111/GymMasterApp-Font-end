import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/model/tokenJwtModel.dart';
import 'package:gym_master_fontend/screen/Tabel/course_view_page.dart';
import 'package:gym_master_fontend/screen/information_page.dart/information_page.dart';
import 'package:gym_master_fontend/screen/register_page/register_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:gym_master_fontend/services/auth_service.dart';
import 'package:gym_master_fontend/widgets/header_container.dart';
import 'package:gym_master_fontend/widgets/menu_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_captcha/slider_captcha.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SliderController _sliderController = SliderController();
  late bool _isLoading;
  late SharedPreferences _prefs;
  String _captchaErrorText = "";
  String url = AppConstants.BASE_URL;

  @override
  void initState() {
    super.initState();
    _isLoading = false; // Initially not loading
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<void> _signUserIn() async {
    setState(() {
      _isLoading = true;
    });

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final dio = Dio();
      var regBody = {
        "login": _emailController.text,
        "password": _passwordController.text,
      };

      try {
        // Login and get the token
        final responseToken = await dio.post(
          'http://$url/user/login',
          data: regBody,
        );

        if (responseToken.statusCode == 200) {
          log("token succes");
          var tokenJWT = tokenJwtModelFromJson(jsonEncode(responseToken.data));
          await _prefs.setString("tokenJwt", tokenJWT.tokenJwt);

          // Fetch user data
          final response = await dio.get(
            'http://$url/user/getUser/${_emailController.text}',
            options: Options(
              headers: {
                'Authorization': 'Bearer ${tokenJWT.tokenJwt}',
              },
              validateStatus: (status) {
                return status! < 500; // Accept status codes less than 500
              },
            ),
          );

          if (response.statusCode == 200) {
            var userModel = userModelFromJson(jsonEncode(response.data));
            await _prefs.setInt("uid", userModel.user.uid);
            await _prefs.setInt("role", userModel.user.role);
            await _prefs.setString("username", userModel.user.username);
            await _prefs.setInt("isDisbel", userModel.user.isDisbel);

            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: userModel.user.email,
                password: _passwordController.text,
              );
              _showCaptchaDialog();
            } catch (e) {
              log("Error signing in: $e");
            }
          } else if (response.statusCode == 404) {
            log('User not found: ${response.statusCode}');
            _showDialog("User not found", "The user could not be found.");
          } else {
            log('Error fetching user data: ${response.statusCode}');
          }
        } else {
          log("Login failed: ${responseToken.statusCode}");
          _showDialog("Login failed", "Invalid credentials.");
        }
      } catch (e) {
        log("An error occurred: $e");
        _showDialog("Error", "An unexpected error occurred.");
      }
    } else {
      _showDialog("เข้าสู่ระบบไม่สำเร็จ",
          "กรุณาใส่ ชื่อผู้ใช้ หรือ อีเมล และ รหัสผ่าน");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _googleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final dio = Dio();

    try {
      var user = await AuthService().signInWithGoogle();
      if (user != null) {
        var regBody = {
          "login": user.email,
        };

        final responseToken = await dio.post(
          'http://$url/user/googleLogin',
          data: regBody,
        );

        if (responseToken.statusCode == 200) {
          log("token succes");
          var tokenJWT = tokenJwtModelFromJson(jsonEncode(responseToken.data));
          await _prefs.setString("tokenJwt", tokenJWT.tokenJwt);

          final response = await dio.get(
            'http://$url/user/getUser/${user.email}',
            options: Options(
              headers: {
                'Authorization': 'Bearer ${tokenJWT.tokenJwt}',
              },
              validateStatus: (status) {
                return status! < 500; // Accept status codes less than 500
              },
            ),
          );
          if (response.statusCode == 200) {
            var responseData = response.data;
            if (response.data.isEmpty) {
              Get.to(RegisterPage(email: user.email.toString()));
            } else {
              var userModel = userModelFromJson(jsonEncode(responseData));
              await GetStorage().write('userModel', userModel);
              await _prefs.setInt("uid", userModel.user.uid);
              await _prefs.setInt("role", userModel.user.role);
              await _prefs.setString("username", userModel.user.username);
              await _prefs.setInt("isDisbel", userModel.user.isDisbel);
              _showCaptchaDialog();
              log(userModel.user.uid.toString());
            }
          } else {
            log('Error fetching user data: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      log("Error signing in: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showCaptchaDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("ยืนยันความเป็นมนุษย์"),
          content: SliderCaptcha(
            controller: _sliderController,
            image: Image.asset(
              'assets/image.jpeg',
              fit: BoxFit.fitWidth,
            ),
            colorBar: Colors.blue,
            colorCaptChar: Colors.blue,
            onConfirm: (value) async {
              if (value) {
                Navigator.pop(context);
                Get.to(const MenuNavBar());
                setState(() {
                  _captchaErrorText = "";
                });
              } else {
                setState(() {
                  _captchaErrorText = "พบข้อผิดผลาด";
                });
                await Future.delayed(const Duration(seconds: 5));
                _sliderController.create.call();
              }
            },
          ),
          actions: [
            Column(
              children: [
                Text(
                  _captchaErrorText,
                  style: const TextStyle(color: Colors.red),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _captchaErrorText = "";
                    });
                  },
                  child: const Text("ปิด"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _handleErrorResponse(http.Response response) {
    if (response.statusCode == 404) {
      _showDialog("เข้าสู่ระบบไม่สำเร็จ", "ชื่อผู้ใช้ หรือ อีเมล ไม่ถูกต้อง");
    } else if (response.statusCode == 401) {
      _showDialog("เข้าสู่ระบบไม่สำเร็จ", "รหัสผ่านไม่ถูกต้อง");
    }
  }

  Future<void> _showDialog(String title, String content) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isLoading = false;
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
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
                                      fontFamily: 'Kanit',
                                      color: Colors.orange),
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
                              _isLoading ? null : _signUserIn();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[800],
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
                                      _googleSignIn();
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
                                    onPressed: () async {
                                      geustMode();
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
      ),
    );
  }

  void geustMode() async {
    final dio = Dio();
    try {
      final responeGusetToken = await dio.get('http://$url/user/getGuestToken');
      TokenJwtModel tokenJWT =
          tokenJwtModelFromJson(jsonEncode(responeGusetToken.data));

      if (responeGusetToken.statusCode == 200) {
        await _prefs.setInt("role", 0);

        Get.to(CourseView(
            uid: 0,
            isAdminCouser: true,
            isEnnabel: false,
            tokenJWT: tokenJWT.tokenJwt));
      }
    } catch (e) {
      log("An error occurred: $e");
      _showDialog("Error", "An unexpected error occurred.");
    }
  }
}
