import 'package:flutter/material.dart';
import 'package:gym_master_fontend/screen/register_page/register_page.dart';
import 'package:gym_master_fontend/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // Remove the app bar shadow
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0.0, -30.0),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(-55.0, 0.0),
                        child: const Text(
                          'GYM',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 65,
                              fontFamily: 'Kanit',
                              color:
                                  Colors.orange // Change font family to Kanit
                              ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(49.0, -30.0),
                        child: const Text(
                          'Master',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 54,
                              fontFamily: 'Kanit',
                              color: Colors.white // Change font family to Kanit
                              ),
                        ),
                      ),
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
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(16)),
                          child: TextField(
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
                                fixedSize: Size(150, 50)),
                            child: Text('Login',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Kanit'))),
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
                                fixedSize: Size(200, 50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                    'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png'),
                                Text('Google',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Kanit')),
                              ],
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()));
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
        )
      ],
    );
  }
}
