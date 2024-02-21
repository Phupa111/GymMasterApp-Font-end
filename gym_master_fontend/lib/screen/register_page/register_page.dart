import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/information_page.dart/information_page.dart';
import 'package:gym_master_fontend/widgets/background.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.transparent,
              ),
              onPressed: () {
                // Navigator.pop(context);
                Get.back();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Text(
                        "Register",
                        style:
                            TextStyle(color: Color(0xFFFFAC41), fontSize: 40.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xFFFFAC41)),
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: const Color(0xFFF1F0F0),
                          border: InputBorder.none,
                          hintText: "Username",
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
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFFFFAC41)),
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
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFFFFAC41)),
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: const Color(0xFFF1F0F0),
                          border: InputBorder.none,
                          hintText: "Password",
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
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFFFFAC41)),
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: const Color(0xFFF1F0F0),
                          border: InputBorder.none,
                          hintText: "Re-Password",
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
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        height: 40.0,
                        width: 150.0,
                        child: FilledButton(
                          onPressed: () {
                            Get.to(InformationPage());
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFFFAC41))),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(
                                    color: Color.fromRGBO(66, 255, 0, 1.0),
                                    width: 2),
                                fixedSize: Size(250, 50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                    'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png'),
                                Text('register with Google',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Kanit')),
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
      ],
    );
  }
}
