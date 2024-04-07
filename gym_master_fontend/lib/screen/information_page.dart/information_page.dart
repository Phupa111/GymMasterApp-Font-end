import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_master_fontend/screen/login_page.dart';
import 'package:http/http.dart' as http;

class InformationPage extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  const InformationPage({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  TextEditingController _date = TextEditingController();
  String _dropdownValue = "male";
  final _gender = ["Male", "Female"];
  final _formkey = GlobalKey<FormState>();

  int genderid = 0;

  void signUp() async {
    print(widget.username);
    var regBody = {
      "username": widget.username,
      "email": widget.email,
      "password": widget.password,
      "height": 180,
      "birthday": "1990-05-15",
      "gender": 1,
      "profile_pic": "",
      "day_success_exerice": 0,
      "role": 1
    };
    var response = await http.post(
        Uri.parse('http://192.168.1.119:8080/user/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    print(response.statusCode);

    try {
      // Assuming `sendSignUpRequest` is a function that sends regBody to your backend

      if (response.statusCode == 201) {
        // Try creating a Firebase Auth user with the provided email and password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: widget.email, password: widget.password);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        ).then((_) {
          ;
        }); //n
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An unexpected error occurred. Please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.orange,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const Text(
                      "กรอกข้อมูล",
                      style: TextStyle(
                        fontSize: 42,
                        color: Color(0xFFFFAC41),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (username) {
                        if (username!.isEmpty) {
                          return "Please Enter username";
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xFFF1F0F0),
                        border: InputBorder.none,
                        hintText: "ชื่อ-นามสกุล",
                        hintStyle: const TextStyle(
                          fontFamily: 'Kanit',
                          color: Color(0xFFFFAC41),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.monitor_weight_sharp,
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
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    DropdownButtonFormField(
                      iconEnabledColor: const Color(0xFFFFAC41),
                      items: _gender.map((String gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _dropdownValue = value!;
                          if (_dropdownValue == "Male") {
                            genderid = 4;
                          } else {
                            genderid = 3;
                          }
                        });
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F0F0),
                          prefixIcon: const Icon(
                            Icons.transgender_sharp,
                            color: Color(0xFFFFAC41),
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                          border: InputBorder.none,
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
                          hintText: "เพศ",
                          hintStyle: const TextStyle(color: Color(0xFFFFAC41))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(25.0),
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
                        prefixIcon: const Icon(
                          Icons.percent_sharp,
                          color: Color(0xFFFFAC41),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xFFF1F0F0),
                        border: InputBorder.none,
                        hintText: "Body Fat",
                        hintStyle: const TextStyle(
                          fontFamily: 'Kanit',
                          color: Color(0xFFFFAC41),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FilledButton(
                        onPressed: () {
                          // _formkey.currentState!.validate();
                          signUp();
                        },
                        child: Text("submit"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFFFAC41),
              ),
            ),
            child: child!);
      },
    );

    if (_picked != null) {
      setState(() {
        _date.text =
            "${_picked.day.toString().padLeft(2, '0')}-${_picked.month.toString().padLeft(2, '0')}-${_picked.year.toString()}";
        print(_date.text);
      });
    }
  }
}
