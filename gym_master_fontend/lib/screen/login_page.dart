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

import 'package:gym_master_fontend/screen/information_page.dart/information_page.dart';

import 'package:gym_master_fontend/screen/register_page/register_page.dart';
import 'package:gym_master_fontend/services/auth_service.dart';
import 'package:gym_master_fontend/widgets/header_container.dart';
import 'package:gym_master_fontend/widgets/menu_bar.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:slider_captcha/slider_captcha.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
    final SliderController controller = SliderController();
  late bool _isLoading;
 String text = "" ;
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
        Uri.parse('http://192.168.1.101:8080/user/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        var userEmail = userData['user']['email'];

        // Assuming you have a method to parse the user data into a UserModel object
        var userModel = userModelFromJson(jsonEncode(userData));

        await GetStorage().write('userModel', userModel);
        

        // ถ้าล็อกอินสำเร็จ
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userEmail,
            password: _passwordController.text,
          );
 CaptchaDailog();
        } catch (e) {
          // Handle sign-in errors
          print("Error signing in: $e");
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 404)  {
        // Show alert dialog for unsuccessful login
        showDailog("เข้าสู่ระบบไม่สำเร็จ","ชื่อผู้ใช้ หรือ อีเมล ไม่ถูกต้อง");

      }
      else if (response.statusCode == 401) {
   showDailog("เข้าสู่ระบบไม่สำเร็จ","รหัสผ่านไม่ถูกต้อง");
      }
    }
else {
  showDailog("เข้าสู่ระบบไม่สำเร็จ","กรุณาใส่ ชื่อผู้ใช้ หรือ อีเมล และ รหัสผ่าน");

}
    
  }

 Future<dynamic> showDailog(String title,String content) {
   return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                 Navigator.pop(context); // Close the dialog
          setState(() {
            _isLoading = false; // Set isLoading to false after closing the dialog
          }); // Close the dialog
              },
              child: Text("OK"),
              
            ),
          ],
        ),
      );
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
        'http://192.168.1.101:8080/user/selectFromEmail/${user.email.toString()}',
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
    
        if (response.data.isEmpty) {
          Get.to(InformationPage(username: user.email.toString(), email: user.email.toString(), password: "fdhsuyu#372638990ifjkkklf", isGoogleAcc: true));
        } else {
              var userModel = userModelFromJson(jsonEncode(responseData));
          await GetStorage().write('userModel',userModel );
         CaptchaDailog();

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

Future<dynamic> CaptchaDailog() {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:Colors.white,
        title: const Text("ยืนยันความเป็นมนุษย์"),
        content: SliderCaptcha(
          controller: controller,
          image: Image.asset(
            'assets/image.jpeg',
            fit: BoxFit.fitWidth,
          ),
          colorBar: Colors.blue,
          colorCaptChar: Colors.blue,
          onConfirm: (value) async {
            debugPrint(value.toString());

            if (value == true) {
              Navigator.pop(context);
              Get.to(MenuNavBar());
              setState(() {
                text = ""; // ยืนยันความเป็นมนุษย์แล้ว กำหนดค่า text เป็นข้อความว่าง
              });
            } else { 
              setState(() {
                    text = "พบข้อผิดผลาด"; // ยังไม่ยืนยันความเป็นมนุษย์ กำหนดค่า text เป็นข้อความ "พบข้อผิดผลาด"
                  });
              return await Future.delayed(const Duration(seconds: 5)).then(
                (value) {
                  controller.create.call();
                 
                },
              );
            }
          },
        ),
        actions: [
          Column(
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.red),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    text = "";
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
                            _isLoading ? null : signUserIn();
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
