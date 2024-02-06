import 'package:flutter/material.dart';
import 'package:gym_master_fontend/screen/login_page.dart';
import 'package:gym_master_fontend/widgets/background.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 125,
                ),
                Transform.translate(
                  offset: const Offset(-55.0, 0.0),
                  child: const Text(
                    'GYM',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 65,
                        fontFamily: 'Kanit',
                        color: Colors.orange // Change font family to Kanit
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
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginPage()), // Replace YourLoginPage with your actual login page widget
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber[800], fixedSize: Size(250, 50)),
                      child: const Text('Login',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Kanit'))),
                ),
                Transform.translate(
                  offset: const Offset(0.0, -35.0),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        fixedSize: const Size(250, 50),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.orange,
                          ),
                          SizedBox(
                              width:
                                  10), // Adjust spacing between icon and text
                          Text(
                            'Guest User',
                            style: TextStyle(
                              color: Colors.orange,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
