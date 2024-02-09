import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: const Color(0xFFF1F0F0),
                    border: InputBorder.none,
                    hintText: "ชื่อ",
                    hintStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFAC41),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors
                              .transparent), // Change border color on focus
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: const Color(0xFFF1F0F0),
                    border: InputBorder.none,
                    hintText: "นามสกุล",
                    hintStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFAC41),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors
                              .transparent), // Change border color on focus
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "Kg",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFFAC41)),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: const Color(0xFFF1F0F0),
                    border: InputBorder.none,
                    hintText: "ชื่อ",
                    hintStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFAC41),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors
                              .transparent), // Change border color on focus
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
