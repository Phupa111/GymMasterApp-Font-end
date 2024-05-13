import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/Tabel/createTabel_page.dart';
import 'package:gym_master_fontend/screen/Tabel/exercises_page.dart';

class UserTabelPage extends StatefulWidget {
  const UserTabelPage({Key? key}) : super(key: key);

  @override
  State<UserTabelPage> createState() => _UserTabelPageState();
}

class _UserTabelPageState extends State<UserTabelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ตารางของฉัน"),
      ),
      body: const SingleChildScrollView(
        // Add your content here
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const CreateTabelPage());
        },
        backgroundColor: const Color(0xFFFFAC41), // Change the background color to your desired color
        foregroundColor: Colors.white, // Change the foreground color (icon color) to your desired color
        elevation: 4, // Change the elevation if needed
        tooltip: 'เพิ่มข้อมูล', // Add a tooltip for accessibility
        child: Icon(Icons.add), // Change the icon to your desired icon
      ),
    );
  }
}
