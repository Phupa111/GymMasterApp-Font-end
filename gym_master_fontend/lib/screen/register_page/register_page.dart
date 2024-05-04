import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/information_page.dart/information_page.dart';
import 'package:gym_master_fontend/services/auth_service.dart';

import 'package:gym_master_fontend/widgets/header_container.dart';
import 'package:gym_master_fontend/widgets/menu_bar.dart';

class RegisterPage extends StatefulWidget {
  String email;
  RegisterPage({Key? key, required this.email}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _password = TextEditingController();
  Color orangeColors = Colors.orange;
final _formKey = GlobalKey<FormState>();
var emailStatusCode = 0;
var usernameStatusCode = 0 ;


  @override
  void initState() {
    super.initState();
    if (widget.email.isNotEmpty) {
      _emailController.text =
          widget.email; // Set the text property of _emailController
    }
  }

void checkEmailUsername() async {
  final dio = Dio();
  print(_emailController.text);
  try {
   var emailResponse = await dio.get(
      'http://192.168.1.111:8080/user/selectFromEmail/${_emailController.text.toString()}',
    );

var  userResponse = await dio.get(
      'http://192.168.1.111:8080/user/selectFromEmail/${_usernameController.text.toString()}',
    );

if (emailResponse.data.isEmpty && userResponse.data.isEmpty)
{
       Get.to(InformationPage(
              username: _usernameController.text,
              email: _emailController.text,
              password: _password.text,
              isGoogleAcc: false,
            ));
}
else 
{
  if(emailResponse.data.isNotEmpty)
  {
    emailStatusCode = 200;
  }
  if(userResponse.data.isNotEmpty)
  {
    usernameStatusCode = 200;
  }

}
  } catch (e) {
    print("Error: $e");
    // Handle Dio exceptions or network errors here
    // Show a snackbar or toast message indicating network error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("An error occurred. Please try again."),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
void googleSigIn() async {
  // setState(() {
  //   _isLoading = true; // Set loading to true when starting the login process
  // });

  final dio = Dio();

  try {
    var user = await AuthService().signInWithGoogle();
    if (user != null) {
      final response = await dio.get(
        'http://192.168.1.111:8080/user/selectFromEmail/${user.email.toString()}',
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
    
        if (response.data.isEmpty) {
          Get.to(InformationPage(username: user.email.toString(), email: user.email.toString(), password: "fdhsuyu#372638990ifjkkklf", isGoogleAcc: true));
        } else {
              var userModel = userModelFromJson(jsonEncode(responseData));
          await GetStorage().write('userModel',userModel );
          Get.to(MenuNavBar());
        }
      } else {
        print('Error fetching user data: ${response.statusCode}');
      }
    }
  } catch (e) {
    print("Error signing in: $e");
  } finally {
    // setState(() {
    //   _isLoading = false;
    // });
  }
}

  bool isValidEmail(String email) {
    // Regular expression for email validation
    // This is a basic example; you can use a more comprehensive regex pattern for email validation
    final RegExp emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Center(
            child: Transform.translate(
              offset: const Offset(0.0, 0.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    HeaderContainer(
                      pageName: "Register",
                      onBackButtonPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              const Icon(Icons.person, color: Color(0xFFFFAC41)),
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: const Color(0xFFF1F0F0),
                          border: InputBorder.none,
                          hintText: "ชื่อผู้ใช้",
                          hintStyle: const TextStyle(
                            fontFamily: 'Kanit',
                            color: Color(0xFFFFAC41),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors
                                    .transparent), // Change border color on focus
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                                  validator: (value) {
                                    if(usernameStatusCode == 200)
                                    {
                                      usernameStatusCode = 0;
                                      return 'มีชื่อผู้ใช้นี้อยู่แล้ว';
                                    }
                                    else{
    if (value == null || value.isEmpty) {
      return 'กรุณาใส่ชื่อผู้ใช้';
    }
    if (value.length < 6) {
      return 'ชื่อผู้ใช้ต้องมีมากกว่า 6 ตัวอักษร';
    }
    return null;
                                    }
 // Return null if the password is valid
  }
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                     Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
        ),
        prefixIcon: const Icon(Icons.email, color: Color(0xFFFFAC41)),
        contentPadding: const EdgeInsets.all(15.0),
        filled: true,
        fillColor: const Color(0xFFF1F0F0),
        border: InputBorder.none,
        hintText: "Email",
        hintStyle: const TextStyle(
          fontFamily: 'Kanit',
          color: Color(0xFFFFAC41),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ), // Change border color on focus
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
             if(emailStatusCode == 200)
                                    {
                                      emailStatusCode =0;
                                      return 'มีอีเมลนี้อยู่แล้ว';
                                    
                                    }
                                    else{    if (value == null || value.isEmpty) {
          return 'กรุณาใส่อีเมล';
        }
        if (!isValidEmail(value)) {
          return 'กรุณาใส่ อีเมล ที่ใช้ได้';
        }
        return null;}
     // Return null if the value is valid
      },
    ),
  ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Color(0xFFFFAC41)),
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: const Color(0xFFF1F0F0),
                          border: InputBorder.none,
                          hintText: "รหัสผ่าน",
                          hintStyle: const TextStyle(
                            fontFamily: 'Kanit',
                            color: Color(0xFFFFAC41),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors
                                    .transparent), // Change border color on focus
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                          validator: (value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาใส่รหัสผ่าน';
    }
    if (value.length < 6) {
      return 'รหัสผ่านต้องมีมากกว่า 6 ตัวอักษร';
    }
    return null; // Return null if the password is valid
  },
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Color(0xFFFFAC41)),
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: const Color(0xFFF1F0F0),
                          border: InputBorder.none,
                          hintText: "ยืนยันรหัสผ่าน",
                          hintStyle: const TextStyle(
                            fontFamily: 'Kanit',
                            color: Color(0xFFFFAC41),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors
                                    .transparent), // Change border color on focus
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                          validator: (value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาใส่ การยืนยันรหัสผ่านของคุณ';
    }
    if (value != _password.text) {
      return 'ยืนยันรหัสผ่านไม่ถูกต้อง';
    }
    return null; // Return null if the re-entered password is valid
  },
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      height: 40.0,
                      width: 150.0,
                      child: FilledButton(
                        onPressed: () {
                         if (_formKey.currentState?.validate() ?? false) {
 checkEmailUsername();
    }
                        },
                        child: Text(
                          "Register",
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFFFFAC41))),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                          onPressed: () {googleSigIn();},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color.fromRGBO(66, 255, 0, 1.0),
                                  width: 2),
                              fixedSize: Size(250, 50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                  'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png'),
                              const Text('register with Google',
                                  style: TextStyle(
                                      color: Colors.black, fontFamily: 'Kanit')),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
