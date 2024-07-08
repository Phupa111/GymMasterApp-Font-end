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
import 'package:gym_master_fontend/screen/login_page.dart';
import 'package:gym_master_fontend/style/state_color.dart';
import 'package:gym_master_fontend/screen/Tabel/userTabel_page.dart';
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
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    uid = _prefs.getInt("uid");
    log(uid.toString());
    setState(() {});
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
                          items: adminTabels
                              .map((adminTabel) => Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration:
                                            BoxDecoration(color: Colors.orange),
                                        width: 400,
                                        child: Column(
                                          children: [
                                            Text(adminTabel.couserName
                                                .toString()),
                                            // Add more widgets here as needed
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Card(
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 8,
                      child: Container(
                        width: 400,
                        height: 200,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://media.istockphoto.com/id/937415802/photo/time-for-exercising-clock-calendar-and-dumbbell-with-blue-yoga-mat-background.jpg?s=612x612&w=0&k=20&c=nY2FYJ8Q63vENr5zYbTyCpo_PICEMLk9eiBbJ-Qp9-E=",
                            ), // Replace 'assets/background_image.jpg' with your actual image path
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
                                    "ตารางของฉัน",
                                    style: TextStyle(
                                        fontSize: 38,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 5),
                                  ),
                                  Text(
                                    "ตารางของฉัน",
                                    style: TextStyle(
                                      fontSize: 38,
                                      color: Colors.grey[300],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(const UserTabelPage());
                                },
                                child: Text(
                                  "ดูเพิ่มเติม",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFAC41)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
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
          await dio.get('http://192.168.2.182:8080/Tabel/getAdminTabel');
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
