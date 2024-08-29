import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/tdeeModel.dart';
import 'package:gym_master_fontend/screen/tdee_page/sub_page/bulking_tab_page.dart';
import 'package:gym_master_fontend/screen/tdee_page/sub_page/cutting_tab_page.dart';
import 'package:gym_master_fontend/screen/tdee_page/sub_page/maintain_tab_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:gym_master_fontend/style/font_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TdeePage extends StatefulWidget {
  TdeePage({super.key});

  @override
  State<TdeePage> createState() => _TdeePageState();
}

class _TdeePageState extends State<TdeePage> {
  late SharedPreferences _prefs;
  int? uid;
  List<TdeeModel> tdee = [];
  late Future<void> loadData;
  late String tokenJWT;

  final tdeeTabs = <Tab>[
    const Tab(text: "Cutting"),
    const Tab(text: "Main"),
    const Tab(text: 'Bluking')
  ];

  @override
  void initState() {
    _initializePreferences();
    loadData = loadDataTdee();
    log(uid.toString());
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    uid = _prefs.getInt("uid");
    tokenJWT = _prefs.getString("tokenJwt")!;
    setState(() {
      loadData = loadDataTdee();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tdeeTabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: const Color(0xFFFFAC41),
          title: const Text(
            "TDEE",
            style: TextStyle(fontFamily: "Kanit", color: Colors.white),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4.0,
            indicatorColor: Color.fromARGB(255, 164, 79, 233),
            tabs: tdeeTabs,
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<void>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return TabBarView(children: [
                CuttingTabPage(
                  tdeeData: tdee,
                ),
                MaintainTabPage(
                  tdeeData: tdee,
                ),
                BulkingTabPage(
                  tdeeData: tdee,
                )
              ]);
            }
          },
        ),
      ),
    );
  }

  Future<void> loadDataTdee() async {
    final dio = Dio();
    String url = AppConstants.BASE_URL;
    log(uid.toString());

    var userData = {
      "uid": uid,
    };
    try {
      final response = await dio.post("http://$url/calculate/getDayOfExercise",
          data: userData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJWT',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      final List<dynamic> tdeeJsonData = response.data;
      tdee = tdeeJsonData.map((item) => TdeeModel.fromJson(item)).toList();
      log(tdeeJsonData.length.toString());
      log(tdee.length.toString());
    } catch (error) {
      log('Error fecthing Data $error');
    }
  }
}
