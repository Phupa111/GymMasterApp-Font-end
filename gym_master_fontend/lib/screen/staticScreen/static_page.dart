import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/WeigthModel.dart';

import 'package:gym_master_fontend/screen/photo_page.dart';
import 'package:gym_master_fontend/screen/showImageScreen/show_image_screen.dart';
import 'package:gym_master_fontend/screen/staticScreen/lineChart_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticPage extends StatefulWidget {
  final int? day_suscess;
  const StaticPage({super.key, required this.day_suscess});

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  late Future<void> loadData;
  List<WeightModel> weights = [];

  late SharedPreferences prefs;
  int? uid;
  String url = AppConstants.BASE_URL;
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt("uid");
    if (uid != null) {
    } else {
      // Handle the case where UID is not set
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found')),
      );
    }
    setState(() {});
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Color(0xFFFFB74D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text("จำนวนวันที่ออกกำลังกาย",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text("${widget.day_suscess}",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(
                height:
                    8), // Adding some space between text and the progress bar
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Static"),
          backgroundColor: Colors.orange,
        ),
        body: uid == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    header(),
                    const LineChartPage(),
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                          onPressed: () async {
                            String? token = prefs.getString("tokenJwt");
                            Get.to(() => ShowImageScreen(
                                  uid: uid!,
                                  tokenJwt: token!,
                                ));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.image),
                              Text(
                                "ดูรูป",
                                style: TextStyle(
                                    fontFamily: 'Kanit', fontSize: 18.0),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ));
  }
}
