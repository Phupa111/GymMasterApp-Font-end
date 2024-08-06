import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/Tabel/userTabel_page.dart';

class CardWidget extends StatelessWidget {
  final String name;
  final String image;
  final bool isAdminCousr;

  const CardWidget({
    super.key,
    required this.name,
    required this.image,
    required this.isAdminCousr,
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
            image: NetworkImage(
              image,
            ),
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(UserTabelPage(isAdminCouser: isAdminCousr));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAC41),
                ),
                child: const Text(
                  "ดูเพิ่มเติม",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
