import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/ExInTabelModel.dart';
import 'package:gym_master_fontend/model/UserEnabelCourseModel.dart';

class StartExPage extends StatefulWidget {
  final List<ExInTabelModel> exPosts; // Add 'final' to make it immutable
  final int tabelID;
  final String tabelName;

  final int uid;
  final int week;
  final int day;
  final int time_rest;

  const StartExPage({
    super.key,
    required this.exPosts,
    required this.tabelID,
    required this.tabelName,
    required this.uid,
    required this.week,
    required this.day, required this.time_rest,
  });

  @override
  State<StartExPage> createState() => _StartExPageState();
}

class _StartExPageState extends State<StartExPage> {
  int currentIndex = 0;
  int currentSet = 0;
  int seconds = 0;
  bool isTimer = false;
  Timer? timer;

  void nextExercise() {
    setState(() {
      if (currentSet < widget.exPosts[currentIndex].exInTabelModelSet - 1) {
        currentSet++;
      } else {
        currentIndex++;
        currentSet = 0;
      }
    });
    startTimer();
  }

  void startTimer() {
    setState(() {
      isTimer = true;
    });
    timer?.cancel();
    seconds = widget.time_rest;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        setState(() {
          isTimer = false;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentIndex < widget.exPosts.length)
            if (isTimer)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        "พักระหว่าง Set ",
                        style: TextStyle(fontFamily: 'Kanit', fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(fit: StackFit.expand, children: [
                            CircularProgressIndicator(
                              value: seconds / widget.time_rest,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              strokeWidth: 12,
                              backgroundColor: Colors.orange,
                            ),
                            Center(
                              child: Text(
                                "$seconds",
                                style: const TextStyle(
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 80),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isTimer = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFAC41),
                          fixedSize: const Size(300, 50),
                        ),
                        child: const Text('ต่อไป',
                            style: TextStyle(
                                fontFamily: 'Kanit', color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFFAC41)),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: currentSet <
                          widget.exPosts[currentIndex].exInTabelModelSet
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(widget.exPosts[currentIndex].name),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    widget.exPosts[currentIndex].gifImage,
                                    height: 500,
                                    width: 500,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Text(' set ที่: ${currentSet + 1}'),
                              Text(
                                  'จำนวนครั้ง: ${widget.exPosts[currentIndex].rep}'),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: nextExercise,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFAC41),
                                    fixedSize: const Size(300, 50),
                                  ),
                                  child: const Text('ต่อไป',
                                      style: TextStyle(
                                          fontFamily: 'Kanit',
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(child: Text('No more sets!')),
                ),
              )
          else
            Column(
              children: [
                const Center(
                  child: Text('No more exercises!'),
                ),
                ElevatedButton(
                    onPressed: () {
                      updateIsSucces();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAC41),
                      fixedSize: const Size(300, 50),
                    ),
                    child: const Text("เสร็จสิ้น",
                        style: TextStyle(
                            fontFamily: 'Kanit', color: Colors.white)))
              ],
            ),
        ],
      ),
    );
  }

  void updateIsSucces() async {
    final dio = Dio();
    var regBody = {
      "uid": widget.uid,
      "tid": widget.tabelID,
      "week": widget.week,
      "day": widget.day,
    };

    log("uid ${widget.uid}, tid ${widget.tabelID}");

    try {
      final response = await dio.post(
        'http://192.168.2.151:8080/enCouser/updateIsSuccess',
        data: regBody,
      );

      if (response.statusCode == 200) {
        log("Sucees");
        Get.back(result: true);
      } else {
        log("Error enabling course: ${response.statusCode}");
      }
    } catch (e) {
      log("Error enabling course: $e");
    }
  }

  // void updateDay() async {
  //   final dio = Dio();
  //   try {
  //     if (widget.userEnabelCourse.day >= widget.dayPerWeek) {
  //       updateWeek();
  //     } else {
  //       final response = await dio.post(
  //         'http://192.168.2.151:8080/enCouser/updateDay',
  //         data: {"utid": widget.userEnabelCourse.utid},
  //       );

  //       if (response.statusCode == 200) {
  //         log('Day updated successfully: ${response.data}');
  //         // Optionally, refresh data or update UI
  //         Get.back(result: true);
  //       } else {
  //         log('Error: ${response.statusCode}, ${response.data}');
  //       }
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     log('Error updating day: $e');
  //   }
  // }

  // void updateWeek() async {
  //   final dio = Dio();
  //   try {
  //     final response = await dio.post(
  //       'http://192.168.2.151:8080/enCouser/updateWeek',
  //       data: {"utid": widget.userEnabelCourse.utid},
  //     );

  //     if (response.statusCode == 200) {
  //       log('Day updated successfully: ${response.data}');
  //       // Optionally, refresh data or update UI
  //       Get.back(result: true);
  //     } else {
  //       log('Error: ${response.statusCode}, ${response.data}');
  //     }
  //   } catch (e) {
  //     log('Error updating day: $e');
  //   }
  // }
}
