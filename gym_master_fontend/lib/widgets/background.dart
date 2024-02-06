import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [Colors.black, Colors.black12],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).createShader(bounds);
      },
      blendMode: BlendMode.darken,
      child: Container(
        width: 455,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: NetworkImage(
            "https://www.fitness-world.in/wp-content/uploads/2022/01/5-Reasons-Why-Your-Residential-Building-Needs-a-Professional-Gym-Banner-1200x620.jpg",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          alignment: FractionalOffset(0.4, 0.5),
        )),
      ),
    );
  }
}
