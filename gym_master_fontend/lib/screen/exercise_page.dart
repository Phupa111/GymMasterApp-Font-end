import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/TabelEnModel.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/course_detail_page.dart';
import 'package:gym_master_fontend/screen/Tabel/editTabel_page.dart';
import 'package:gym_master_fontend/screen/Tabel/userTabel_page.dart';

import 'package:gym_master_fontend/services/app_const.dart';
import 'package:gym_master_fontend/widgets/card.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  int? uid;
  int? role;
  String url = AppConstants.BASE_URL;
  late SharedPreferences prefs;
  late String tokenJWT;
  List<TabelEnModel> activeTabels = [];
  late Future<void> loadData;
  @override
  void initState() {
    super.initState();

    loadData = _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt("uid");
    role = prefs.getInt("role");
    tokenJWT = prefs.getString("tokenJwt")!;
    await loadDataAsync();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("คอร์สที่กำลังใช้งาน")),
      body: FutureBuilder<void>(
        future: loadData, // Invoke the future method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return activeTabels.isEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: CardWidget(
                          name: "คอร์สออกกำลังกาย",
                          image:
                              "https://swequity.vn/wp-content/uploads/2019/07/tap-gym-yeu-sinh-ly.jpg",
                          button: ElevatedButton(
                            onPressed: () async {
                              var refresh = await Get.to(() =>
                                  const UserTabelPage(isAdminCouser: true));
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
                          name: "ตารางของฉัน",
                          image:
                              "https://media.istockphoto.com/id/937415802/photo/time-for-exercising-clock-calendar-and-dumbbell-with-blue-yoga-mat-background.jpg?s=612x612&w=0&k=20&c=nY2FYJ8Q63vENr5zYbTyCpo_PICEMLk9eiBbJ-Qp9-E=",
                          button: ElevatedButton(
                            onPressed: () async {
                              var refresh = await Get.to(() =>
                                  const UserTabelPage(isAdminCouser: false));
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
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                    itemCount: activeTabels.length,
                    itemBuilder: (context, index) {
                      final tabel = activeTabels[index];
                      return Card(
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 8,
                        child: InkWell(
                          onTap: () async {
                            var refresh = await Get.to(CourseDetailPage(
                              tabelID: tabel.tid,
                              tabelName: tabel.couserName,
                              dayPerWeek: tabel.dayPerWeek,
                              times: tabel.times,
                              uid: uid ?? 0,
                              time_rest: tabel.timeRest,
                              tokenJWT: tokenJWT,
                            ));
                            if (refresh == true) {
                              setState(() {
                                loadData = loadDataAsync();
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tabel.couserName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Times: ${tabel.times}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Days per Week: ${tabel.dayPerWeek}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 10, 8, 0),
                                  child: LinearPercentIndicator(
                                    width: 300.0,
                                    lineHeight: 14.0,
                                    percent: tabel.count /
                                        (tabel.dayPerWeek * tabel.times),
                                    center: Text(
                                      '${((tabel.count / (tabel.dayPerWeek * tabel.times)) * 100).toInt()} %',
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                    barRadius: const Radius.circular(16),
                                    backgroundColor: Colors.white,
                                    progressColor: Colors.amber[400],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 10, 8, 0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          deleteUserCourse(tabel.tid);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .red, // Button background color
                                        ),
                                        child: const Text("เลิกใช้งาน",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 10, 8, 0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(EditTabelPage(
                                            tabelID: tabel.tid,
                                            tabelName: tabel.couserName,
                                            dayPerWeek: tabel.dayPerWeek,
                                            isUnused: false,
                                            tokenJWT: tokenJWT,
                                            uid: uid,
                                            times: tabel.times,
                                            role: role,
                                          ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .white, // Button background color
                                        ),
                                        child: const Text("แก้ไข",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ));
          }
        },
      ),
    );
  }

  void deleteUserCourse(int tid) async {
    final dio = Dio();
    var regBody = {
      "uid": uid,
      "tid": tid,
    };

    try {
      final response = await dio.post('http://$url/enCouser/deleteUserCourse',
          data: regBody);

      if (response.statusCode == 200) {
        // Course deleted successfully! (Handle success scenario)
        log("Course with ID $tid deleted successfully!");
        setState(() {
          loadData = loadDataAsync(); // Reload the data
        });
      } else {
        // Handle error based on status code
        log("Error deleting course: ${response.statusCode}");
        // You can also check the response body for specific error messages
      }
    } catch (e) {
      // Handle network or other errors
      log("Error deleting course: $e");
    }
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://$url/Tabel/getAllEnnabelUserTabel?uid=$uid',
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJWT',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data as List<dynamic>;
        activeTabels =
            jsonData.map((item) => TabelEnModel.fromJson(item)).toList();
      }
    } catch (e) {
      log("Error enabling course: $e");
    }
  }
}
