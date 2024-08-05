import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/TabelModel.dart'; // Add import for TabelModel
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/Tabel/adminTabel_page.dart';
import 'package:gym_master_fontend/screen/adminScreen/admin_page.dart';
import 'package:gym_master_fontend/screen/login_page.dart';
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

    _initializePreferences();
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
        // leading: role == 0?
        automaticallyImplyLeading: role != 0 ? false : true,
      ),
      body: FutureBuilder<void>(
        future: null,
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: CardWidget(
                        name: "คอร์สออกกำลังกาย",
                        image:
                            "https://swequity.vn/wp-content/uploads/2019/07/tap-gym-yeu-sinh-ly.jpg",
                        isAdminCousr: true),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: CardWidget(
                          name: "ตารางของฉัน",
                          image:
                              "https://media.istockphoto.com/id/937415802/photo/time-for-exercising-clock-calendar-and-dumbbell-with-blue-yoga-mat-background.jpg?s=612x612&w=0&k=20&c=nY2FYJ8Q63vENr5zYbTyCpo_PICEMLk9eiBbJ-Qp9-E=",
                          isAdminCousr: false))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
