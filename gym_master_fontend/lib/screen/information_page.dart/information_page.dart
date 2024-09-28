import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/model/tokenJwtModel.dart';
import 'package:gym_master_fontend/screen/login_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:gym_master_fontend/widgets/header_container.dart';
import 'package:http/http.dart' as http;

class InformationPage extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  final bool isGoogleAcc;

  const InformationPage({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
    required this.isGoogleAcc,
  }) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final _date = TextEditingController();
  var _heightController = TextEditingController();
  var _weightController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  int _selectedGender = 1;
  DateTime date = DateTime(2024, 12, 1);
  String url = AppConstants.BASE_URL;
  void signUp() async {
    log(widget.username);
    var regBody = {
      "username": widget.username,
      "email": widget.email,
      "password": widget.password,
      "height": int.parse(_heightController.text),
      "birthday": "${date.year}-${date.month}-${date.day}",
      "gender": _selectedGender,
      "profile_pic": "",
      "day_success_exerice": 0,
      "role": 1,
      "isDisbel": 0,
    };
    var response = await http.post(Uri.parse('$url/user/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    try {
      // Assuming `sendSignUpRequest` is a function that sends regBody to your backend

      if (response.statusCode == 201) {
        // Try creating a Firebase Auth user with the provided email and passwor
        //
        if (widget.isGoogleAcc == false) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: widget.email, password: widget.password);
        }

        final dio = Dio();

        var regBody = {
          "login": widget.email,
          "password": widget.password,
        };

        final responseToken = await dio.post(
          '$url/user/login',
          data: regBody,
        );

        if (responseToken.statusCode == 200) {
          log("token succes");
          var tokenJWT = tokenJwtModelFromJson(jsonEncode(responseToken.data));

          final response = await dio.get(
            '$url/user/getUser/${widget.email}',
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
                '${url}/progress/weightInsert',
                data: {
                  'uid': userModel
                      .user.uid, // Assuming you have the user ID available
                  'weight': double.parse(_weightController
                      .text), // The weight data you want to insert
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
                Get.to(const LoginPage());
              }
            } catch (e) {
              // Handle any exceptions that occur during the HTTP request
              print('Error while inserting weight progress: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  HeaderContainer(
                    pageName: "Info",
                    onBackButtonPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedGender = 1;
                            });
                          },
                          icon: Icon(
                            Icons.male,
                            size: 50,
                            color: _selectedGender == 1
                                ? Colors.white
                                : const Color(0xFFFFAC41),
                          ),
                          label: Text(
                            'ชาย',
                            style: TextStyle(
                              color: _selectedGender == 1
                                  ? Colors.white
                                  : const Color(0xFFFFAC41),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              _selectedGender == 1
                                  ? const Color(0xFFFFAC41)
                                  : Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedGender = 2;
                            });
                          },
                          icon: Icon(
                            Icons.female,
                            size: 50,
                            color: _selectedGender == 2
                                ? Colors.white
                                : const Color(0xFFFFAC41),
                          ),
                          label: Text(
                            'หญิง',
                            style: TextStyle(
                              color: _selectedGender == 2
                                  ? Colors.white
                                  : const Color(0xFFFFAC41),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              _selectedGender == 2
                                  ? const Color(0xFFFFAC41)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: _weightController,
                      decoration: InputDecoration(
                        focusColor: const Color(0xFFFFAC41),
                        prefixIcon: const Icon(
                          Icons.scale,
                          color: Color(0xFFFFAC41),
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            "กก.",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFFAC41)),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xFFF1F0F0),
                        border: InputBorder.none,
                        hintText: "น้ำหนัก",
                        hintStyle: const TextStyle(
                          fontFamily: 'Kanit',
                          color: Color(0xFFFFAC41),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('บันทึกน้ำหนัก'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Form(
                                    child: TextField(
                                      controller: _weightController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.]')),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: 'ใส่ค่าน้ำหนัก',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    double? weight =
                                        double.tryParse(_weightController.text);

                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาใส่น้ำหนักของคุณ';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: _heightController,
                      decoration: InputDecoration(
                        focusColor: const Color(0xFFFFAC41),
                        prefixIcon: const Icon(
                          Icons.accessibility,
                          color: Color(0xFFFFAC41),
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            "ซม.",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFFAC41)),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xFFF1F0F0),
                        border: InputBorder.none,
                        hintText: "ส่วนสูง",
                        hintStyle: const TextStyle(
                          fontFamily: 'Kanit',
                          color: Color(0xFFFFAC41),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => SizedBox(
                            height: 250,
                            child: CupertinoPicker(
                              backgroundColor: Colors.white,
                              itemExtent: 30,
                              scrollController: FixedExtentScrollController(
                                  initialItem:
                                      70), // ตั้งค่าค่าเริ่มต้นเป็น 120 เพื่อแสดงค่าส่วนสูงที่ 120 (เช่น 120 ซม)
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  _heightController.text =
                                      (value + 100).toString();
                                });
                              },
                              children: List.generate(
                                151, // จำนวนไอเทมที่ต้องการแสดง (0-150)
                                (index) => Center(
                                    child: Text(
                                        '${index + 100} ซม.')), // เริ่มต้นที่ 100 เพื่อแสดงช่วง 100-250 ซม
                              ),
                            ),
                          ),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาใส่ส่วนสูงของคุณ';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.calendar_today_rounded,
                          color: Color(0xFFFFAC41),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xFFF1F0F0),
                        border: InputBorder.none,
                        hintText: "วัน-เดือน-ปีเกิด",
                        hintStyle: const TextStyle(
                          fontFamily: 'Kanit',
                          color: Color(0xFFFFAC41),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      controller: _date,
                      onTap: () {
                        // print("clicked");
                        _selectDate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาใส่ วัน/เดือน/ปีเกิด ของคุณ';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FilledButton(
                    onPressed: () {
                      // _formkey.currentState!.validate();
                      if (_formkey.currentState!.validate()) {
                        signUp();
                      }
                    },
                    child: const Text("ตกลง"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFFFAC41)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                backgroundColor: Colors.white,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: date,
                onDateTimeChanged: (DateTime newTime) {
                  setState(() {
                    date = newTime;
                    _date.text = '${date.month}-${date.day}-${date.year}';
                  });
                },
              ),
            ));
  }
}
