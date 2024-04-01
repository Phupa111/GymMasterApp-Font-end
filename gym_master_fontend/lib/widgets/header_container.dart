import 'package:flutter/material.dart';

class HeaderContainer extends StatelessWidget {
  final String pageName;
  final VoidCallback? onBackButtonPressed; // Callback for back button

  HeaderContainer({Key? key, required this.pageName, this.onBackButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color orangeColors = Colors.orange;
    const Color orangeLightColors = Color(0xFFFFB74D);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [orangeColors, orangeLightColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          // Back Button
          if (onBackButtonPressed != null)
            Positioned(
              top: 40, // Adjust the position as needed
              left: 20, // Adjust the position as needed
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBackButtonPressed,
              ),
            ),
          Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                pageName,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/gym.png",
                  height: 200,
                  width: 100,
                ),
                Transform.translate(
                    offset: const Offset(0, -40),
                    child: const Text(
                      "Gym Master",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
