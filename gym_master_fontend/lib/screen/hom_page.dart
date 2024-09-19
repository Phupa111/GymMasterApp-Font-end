import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/TabelModel.dart'; // Add import for TabelModel
import 'package:gym_master_fontend/model/UserModel.dart';

import 'package:gym_master_fontend/screen/adminScreen/admin_page.dart';
import 'package:gym_master_fontend/screen/login_page.dart';
import 'package:gym_master_fontend/screen/tdee_page/tdee_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:gym_master_fontend/style/state_color.dart';
import 'package:gym_master_fontend/screen/Tabel/userTabel_page.dart';
import 'package:gym_master_fontend/widgets/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  int? uid = 0;
  HomePage({Key? key, this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TabelModel> adminTabels = [];

  late Future<void> loadData;

  late SharedPreferences _prefs;
  int? uid;
  int? role;
  String url = AppConstants.BASE_URL;

  @override
  void initState() {
    super.initState();
    loadData = _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    uid = _prefs.getInt("uid");
    role = _prefs.getInt('role');
    log(uid.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: role != 0,
      ),
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: CardWidget(
                      name: "คอร์สออกกำลังกาย",
                      image:
                          "https://swequity.vn/wp-content/uploads/2019/07/tap-gym-yeu-sinh-ly.jpg",
                      button: ElevatedButton(
                        onPressed: () {
                          Get.to(
                              () => const UserTabelPage(isAdminCouser: true));
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: CardWidget(
                      name: "ตารางของฉัน",
                      image:
                          "https://media.istockphoto.com/id/937415802/photo/time-for-exercising-clock-calendar-and-dumbbell-with-blue-yoga-mat-background.jpg?s=612x612&w=0&k=20&c=nY2FYJ8Q63vENr5zYbTyCpo_PICEMLk9eiBbJ-Qp9-E=",
                      button: ElevatedButton(
                        onPressed: () async {
                          var refresh = await Get.to(
                              () => const UserTabelPage(isAdminCouser: false));
                          if (refresh == true) {
                            setState(() {
                              loadData = _initializePreferences();
                            });
                          }
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: CardWidget(
                      name: "ดูค่า TDEE",
                      image:
                          "https://www.eatingwell.com/thmb/m5xUzIOmhWSoXZnY-oZcO9SdArQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/article_291139_the-top-10-healthiest-foods-for-kids_-02-4b745e57928c4786a61b47d8ba920058.jpg",
                      button: ElevatedButton(
                        onPressed: () {
                          Get.to(() => TdeePage());
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
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
