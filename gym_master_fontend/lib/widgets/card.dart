import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardWidget extends StatelessWidget {
  final String name;
  final String image;

  final Widget button;

  const CardWidget({
    super.key,
    required this.name,
    required this.image,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurpleAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 8,
      child: Container(
        width: 400,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Stack(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 38,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 5,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 38,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: button,
            ),
          ],
        ),
      ),
    );
  }
}
