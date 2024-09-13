import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/adminScreen/user_list/user_list_page.dart';

import 'package:gym_master_fontend/widgets/card.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adminpage"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: CardWidget(
                name: "ดูผู้ใช้",
                image:
                    "https://account.bangkoklife.com/BlaAccountRegister/img/icon-03.png",
                button: ElevatedButton(
                  onPressed: () {
                    Get.to(const UaserListPage());
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
            )
          ],
        ),
      ),
    );
  }
}
