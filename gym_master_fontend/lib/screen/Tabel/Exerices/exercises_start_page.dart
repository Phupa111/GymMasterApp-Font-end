import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/ExInTabelModel.dart';
import 'package:gym_master_fontend/model/UserEnabelCourseModel.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/start_exercies_page.dart';
import 'package:gym_master_fontend/screen/Tabel/userTabel_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class ExerciesStart extends StatefulWidget {
  final int tabelID;
  final String tabelName;
  final int week;
  final int dayPerWeek;
  final int times;
  final int day;
  final int uid;
  final int time_rest;
  final String tokenJWT;

  const ExerciesStart({
    super.key,
    required this.tabelID,
    required this.tabelName,
    required this.uid,
    required this.week,
    required this.day,
    required this.time_rest,
    required this.tokenJWT,
    required this.dayPerWeek,
    required this.times,
  });

  @override
  State<ExerciesStart> createState() => _ExerciesStartState();
}

class _ExerciesStartState extends State<ExerciesStart> {
  List<ExInTabelModel> exPosts = [];
  late Future<void> loadData;
  bool isDone = false;
  List<UserEnabelCourse> userEnabelCourse = [];
  int currentIndex = 0;
  String url = AppConstants.BASE_URL;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    const Color orangeColors = Colors.orange;
    const Color orangeLightColors = Color(0xFFFFB74D);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColors,
      ),
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [orangeColors, orangeLightColors],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            widget.tabelName,
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Week ${widget.week} Day ${widget.day}",
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                !isDone
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: exPosts.length,
                          itemBuilder: (context, index) {
                            final exPost = exPosts[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFFFAC41)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          exPost.gifImage,
                                          height: 50,
                                          width: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                              child: Text(exPost.name,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          Flexible(
                                              child: Text(
                                                  'Sets: ${exPost.exInTabelModelSet}',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          Flexible(
                                              child: Text('Reps: ${exPost.rep}',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text('สิ้นสุด'),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: !isDone
                        ? () async {
                            var refresh = await Get.to(() => StartExPage(
                                  exPosts: exPosts,
                                  tabelID: widget.tabelID,
                                  tabelName: widget.tabelName,
                                  uid: widget.uid,
                                  week: widget.week,
                                  day: widget.day,
                                  time_rest: widget.time_rest,
                                  tokenJWT: widget.tokenJWT,
                                  dayPerWeek: widget.dayPerWeek,
                                  times: widget.times,
                                ));
                            if (refresh == true) {}
                          }
                        : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAC41),
                      fixedSize: const Size(300, 50),
                    ),
                    child: Text(
                      !isDone ? "เริ่ม" : "สิ้นสุด",
                      style: const TextStyle(
                          fontFamily: 'Kanit', color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();
    try {
      // final response = await dio.get(
      //   'http://${url}/enCouser/getAllUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}',
      // );
      // final userEnabelCourseData = response.data as List<dynamic>;
      // if (userEnabelCourseData.isNotEmpty) {
      //   userEnabelCourse =  userEnabelCourse = (response.data as List)
      //       .map((json) => UserEnabelCourse.fromJson(json))
      //       .toList();
      // if (userEnabelCourse.week > widget.times) {
      // setState(() {
      //   isDone = true;
      // });
      //} else {
      final exercisesResponse =
          await dio.post('http://${url}/tabel/getExercisesInTabel',
              data: {'tid': widget.tabelID, 'dayNum': widget.day},
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${widget.tokenJWT}',
                },
                validateStatus: (status) {
                  return status! < 500; // Accept status codes less than 500
                },
              ));
      if (exercisesResponse.statusCode == 200) {
        final exerciseData = exercisesResponse.data as List<dynamic>;
        setState(() {
          exPosts = exerciseData
              .map((item) => ExInTabelModel.fromJson(item))
              .toList();
        });
      } else {
        throw Exception(
            'Failed to load exercises: ${exercisesResponse.statusCode}');
      }
      //}
      // } else {
      //   throw Exception('Invalid data format received');
      // }
    } catch (e) {
      print('Error loading data: $e');
    }
  }
}
