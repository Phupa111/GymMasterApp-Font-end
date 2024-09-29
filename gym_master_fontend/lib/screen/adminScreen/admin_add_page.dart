import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/model/tokenJwtModel.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({super.key});

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordCheck = TextEditingController();
  var emailStatusCode = 0;
  var usernameStatusCode = 0;
  String url = AppConstants.BASE_URL;

  void signUp() async {
    var regBody = {
      "username": _usernameController.text,
      "email": _emailController.text,
      "password": _password.text,
      "height": 170,
      "birthday": "2000-8-2",
      "gender": 1,
      "profile_pic": "",
      "day_success_exerice": 0,
      "role": 2,
      "isDisbel": 0,
    };
    final dio = Dio();

    try {
      // Assuming `sendSignUpRequest` is a function that sends regBody to your backend
      var response = await dio.post('$url/user/register', data: regBody);
      if (response.statusCode == 201) {
        // Try creating a Firebase Auth user with the provided email and passwor
        //

        var regBody1 = {
          "login": _emailController.text,
          "password": _password.text,
        };

        final responseToken = await dio.post(
          '$url/user/login',
          data: regBody1,
        );

        if (responseToken.statusCode == 200) {
          log("token succes");
          var tokenJWT = tokenJwtModelFromJson(jsonEncode(responseToken.data));

          final response = await dio.get(
            '$url/user/getUser/${_emailController.text}',
            options: Options(
              headers: {
                'Authorization': 'Bearer ${tokenJWT.tokenJwt}',
              },
              validateStatus: (status) {
                return status! < 500; // Accept status codes less than 500
              },
            ),
          );
          var userModel = userModelFromJson(jsonEncode(response.data));
          if (response.statusCode == 200) {
            try {
              final progressRes = await dio.post(
                '$url/progress/weightInsert',
                data: {
                  'uid': userModel
                      .user.uid, // Assuming you have the user ID available
                  'weight': 70 // The weight data you want to insert
                },
                options: Options(
                  headers: {
                    'Authorization': 'Bearer ${tokenJWT.tokenJwt}',
                  },
                  validateStatus: (status) {
                    return status! < 500; // Accept status codes less than 500
                  },
                ),
              );
              // Check if weight progress insertion was successful
              if (progressRes.statusCode == 200) {
                // Navigate to the login page
                _usernameController.clear();
                _emailController.clear();
                _password.clear();
                _passwordCheck.clear();
                log("suceess admin add");
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  title: "เพิ่ม แอดมิน สำเร็จ",
                  btnOkOnPress: () async {},
                ).show();
              }
            } catch (e) {
              // Handle any exceptions that occur during the HTTP request
              log('Error while inserting weight progress: $e');
              // Show an error message or take appropriate action
            }
          }
        }

        //n
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to sign up. Please try again."),
        ));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An unexpected error occurred. Please try again."),
      ));
    }
  }

  void checkEmailUsername() async {
    final dio = Dio();
    log(_emailController.text);

    try {
      final responseToken = await dio.get('$url/user/getGuestToken');
      TokenJwtModel tokenJWT =
          tokenJwtModelFromJson(jsonEncode(responseToken.data));

      if (responseToken.statusCode == 200) {
        log("Token success");
        log("Token: ${tokenJWT.tokenJwt}");

        var emailResponse = await dio.get(
          '$url/user/getUser/${_emailController.text}',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${tokenJWT.tokenJwt}',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ),
        );

        var userResponse = await dio.get(
          '$url/user/getUser/${_usernameController.text}',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${tokenJWT.tokenJwt}',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ),
        );

        log("email : ${emailResponse.data}");
        if (emailResponse.data.isEmpty && userResponse.data.isEmpty) {
          signUp();
        } else {
          if (emailResponse.data.isNotEmpty) {
            emailStatusCode = 200;
          }
          if (userResponse.data.isNotEmpty) {
            usernameStatusCode = 200;
          }
        }
      } else {
        log("Invalid credentials");
      }
    } catch (e) {
      log("Error: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  bool isValidEmail(String email) {
    // Regular expression for email validation
    // This is a basic example; you can use a more comprehensive regex pattern for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เพิ่มแอดมิน"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (usernameStatusCode == 200) {
                          usernameStatusCode = 0;
                          return 'มีชื่อผู้ใช้นี้อยู่แล้ว';
                        } else {
                          if (value == null || value.isEmpty) {
                            return 'กรุณาใส่ชื่อผู้ใช้';
                          }
                          if (value.length < 6) {
                            return 'ชื่อผู้ใช้ต้องมีมากกว่า 6 ตัวอักษร';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                            return 'ชื่อผู้ใช้ต้องเป็นภาษาอังกฤษและตัวเลขเท่านั้น ห้ามมีอักขระพิเศษ';
                          }
                          return null;
                        }
                      },
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
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xFFFFAC41)),
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
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (emailStatusCode == 200) {
                          emailStatusCode = 0;
                          return 'มีอีเมลนี้อยู่แล้ว';
                        } else {
                          if (value == null || value.isEmpty) {
                            return 'กรุณาใส่อีเมล';
                          }
                          if (!isValidEmail(value)) {
                            return 'กรุณาใส่ อีเมล ที่ใช้ได้';
                          }
                          return null;
                        }
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
                          borderSide:
                              const BorderSide(color: Colors.transparent),
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
                        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$')
                            .hasMatch(value)) {
                          return 'รหัสผ่านต้องเป็นภาษาอังกฤษและต้องมีตัวเลขอย่างน้อย 1 ตัว';
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
                      controller: _passwordCheck,
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
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFFFFAC41))),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
