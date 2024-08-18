import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_master_fontend/model/WeigthModel.dart';

import 'package:gym_master_fontend/screen/photo_page.dart';
import 'package:gym_master_fontend/screen/staticScreen/lineChart_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Static"),
          backgroundColor: Colors.orange,
        ),
        body: uid == null
            ? const Center(child: CircularProgressIndicator())
            : const SingleChildScrollView(
                child: Column(
                  children: [LineChartPage()],
                ),
              ));
  }
}
