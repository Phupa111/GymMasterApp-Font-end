import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/TabelModel.dart'; // Add import for TabelModel
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/Tabel/adminTabel_page.dart';
import 'package:gym_master_fontend/screen/login_page.dart';

class HomePage extends StatefulWidget {
  int? uid = 0;
  HomePage({Key? key, this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TabelModel> adminTabels = [];

  late Future<void> loadData;
  GetStorage gs = GetStorage();
  late UserModel userModel = gs.read('userModel');

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Training Course",
                                style: TextStyle(fontSize: 16)),
                            TextButton(
                                onPressed: () {
                                  Get.to(const AdminTabelPage());
                                },
                                child: const Text(
                                  "ดูเพิ่มเติม",
                                  style: TextStyle(
                                    color: Color(0xFFFFAC41),
                                  ),
                                ))
                          ],
                        ),
        CarouselSlider(
  items: adminTabels.map((adminTabel) => Padding(
    padding: const EdgeInsets.all(12.0),
    child: InkWell(
      onTap: () {
        
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.orange),
        width: 400,
        child: Column(
          children: [
            Text(adminTabel.couserName.toString()),
            // Add more widgets here as needed
          ],
        ),
      ),
    ),
  )).toList(),
  options: CarouselOptions(
    height: 200,
    autoPlay: true,
    enlargeCenterPage: true,
    aspectRatio: 16 / 9,
    autoPlayCurve: Curves.fastOutSlowIn,
    enableInfiniteScroll: true,
    viewportFraction: 0.8,
  ),
),

                      ],
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

  Future<void> loadDataAsync() async {
    final dio = Dio();

    try {
      final response =
          await dio.get('http://192.168.1.111:8080/Tabel/getAdminTabel');
      final jsonData =
          response.data as List<dynamic>; // Assuming the response is a list
      adminTabels = jsonData.map((item) => TabelModel.fromJson(item)).toList();
      log(adminTabels.length.toString());
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception('Error fetching data');
    }
  }
}
