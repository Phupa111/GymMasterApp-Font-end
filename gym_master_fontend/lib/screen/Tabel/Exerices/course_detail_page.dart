import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/UserEnabelCourseModel.dart';
import 'package:gym_master_fontend/model/weekDiffModel.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/exercises_start_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CourseDetailPage extends StatefulWidget {
  final int tabelID;
  final String tabelName;
  final int dayPerWeek;
  final int times;
  final int uid;
  final int time_rest;
  final String url = AppConstants.BASE_URL;

  const CourseDetailPage({
    super.key,
    required this.tabelID,
    required this.tabelName,
    required this.dayPerWeek,
    required this.times,
    required this.uid,
    required this.time_rest,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  List<UserEnabelCourse> userEnabelCourse = [];
  List<UserEnabelCourse> userNotSuccesCourse = [];
  List<UserEnabelCourse> succesUserEn = [];

  late Future<void> loadData;
  WeeksDiffModel? weeksDiffModel;
  String url = AppConstants.BASE_URL;
  int day = 0;
  int week_count = 1;
  late int allExcount;

  @override
  void initState() {
    super.initState();
    allExcount = widget.times * widget.dayPerWeek;
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();
    try {
      final weekResponse = await dio.get(
        'http://$url/enCouser/getWeek?uid=${widget.uid}&tid=${widget.tabelID}&week=1&day=1',
      );
      if (weekResponse.statusCode == 200) {
        weeksDiffModel = WeeksDiffModel.fromJson(weekResponse.data[0]);
        week_count += weeksDiffModel!.weeksDiff;
        log("week count $week_count");

        final response = await dio.get(
          'http://$url/enCouser/getIsNotSuccesUserEnCouserbyWeek?uid=${widget.uid}&tid=${widget.tabelID}&week=$week_count',
        );
        userEnabelCourse = (response.data as List)
            .map((json) => UserEnabelCourse.fromJson(json))
            .toList();

        final userSuccessEnRes = await dio.get(
          'http://$url/enCouser/getSuccesUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}',
        );

        succesUserEn = (userSuccessEnRes.data as List)
            .map((json) => UserEnabelCourse.fromJson(json))
            .toList();
        if (week_count > widget.times) {
          if (succesUserEn.length != allExcount) {
            final responseNotSucces = await dio.get(
                'http://$url/enCouser/getNotSuccesUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}');
            userNotSuccesCourse = (responseNotSucces.data as List)
                .map((json) => UserEnabelCourse.fromJson(json))
                .toList();

            if (userNotSuccesCourse.isNotEmpty) {
              final respones = await dio.get(
                'http://$url/enCouser/getFixUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}',
              );

              userEnabelCourse = (respones.data as List)
                  .map((json) => UserEnabelCourse.fromJson(json))
                  .toList();

              if (userEnabelCourse.isEmpty) {
                updateWeekStart(userNotSuccesCourse);
              }

              if (userEnabelCourse.isNotEmpty) {
                final weekResponse = await dio.get(
                  'http://$url/enCouser/getWeek?uid=${widget.uid}&tid=${widget.tabelID}&week=${userEnabelCourse[0].week}&day=${userEnabelCourse[0].day}',
                );
                if (weekResponse.statusCode == 200) {
                  WeeksDiffModel weeksDiffModel =
                      WeeksDiffModel.fromJson(weekResponse.data[0]);
                  int weekCount = 1;
                  weekCount += weeksDiffModel!.weeksDiff;
                  log("week_diff : ${weekCount}");
                  if (weekCount > 1) {
                    updateWeekStart(userNotSuccesCourse);
                  }
                }
              }
            }
          }
        }

        setState(() {
          if (userEnabelCourse.isNotEmpty) {
            day = userEnabelCourse[0].day;
            log("Current day: $day");
          }
          log("Success courses count: ${succesUserEn.length}");
        });
      }
    } catch (e) {
     log('Error loading data: $e');
    }
  }

  void updateWeekStart(List<UserEnabelCourse> userNotSuccesCourse) async {
    final dio = Dio();

    int iterations = widget.dayPerWeek < userNotSuccesCourse.length
        ? widget.dayPerWeek
        : userNotSuccesCourse.length;

    for (int i = 0; i < iterations; i++) {
      var regUpdateWeekBody = {
        "uid": widget.uid,
        "tid": widget.tabelID,
        "week": userNotSuccesCourse[i].week,
        "day": userNotSuccesCourse[i].day,
      };

      final dio = Dio();

      try {
        final response = await dio.post(
          'http://$url/enCouser/updateWeekStartDate',
          data: regUpdateWeekBody,
        );
        if (response.statusCode == 200) {
          log("Week start date updated successfully for week: ${userNotSuccesCourse[i].week}, day: ${userNotSuccesCourse[i].day}");
        } else {
          log("Failed to update week start date: ${response.statusCode}");
        }
      } catch (e) {
        log("Error updating week start date: $e");
      }
    }
    final respones = await dio.get(
      'http://$url/enCouser/getFixUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}',
    );
    setState(() {
      userEnabelCourse = (respones.data as List)
          .map((json) => UserEnabelCourse.fromJson(json))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
         leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Get.back(result: true);
    },
  ),
      ),
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return week_count <= widget.times
                ? Column(
                    children: [
                      header(),
                      allExcount != succesUserEn.length
                          ? SingleChildScrollView(
                              child: Column(
                                children:
                                    List.generate(widget.times, (weekIndex) {
                                  int currentWeek = weekIndex + 1;
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Week $currentWeek'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                            widget.dayPerWeek, (dayIndex) {
                                          int currentDay = dayIndex + 1;
                                          bool isButtonEnabled =
                                              userEnabelCourse.any((course) =>
                                                  currentWeek == week_count &&
                                                  currentDay == day &&
                                                  course.isSuccess == 0);
                                          bool isSuccessButton =
                                              succesUserEn.any((course) =>
                                                  course.week == currentWeek &&
                                                  course.day == currentDay &&
                                                  course.isSuccess == 1);

                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: isButtonEnabled
                                                ? ElevatedButton(
                                                    onPressed: isButtonEnabled
                                                        ? () async {
                                                            var refresh =
                                                                await Get.to(
                                                                    ExerciesStart(
                                                              tabelID: widget
                                                                  .tabelID,
                                                              tabelName: widget
                                                                  .tabelName,
                                                              week: currentWeek,
                                                              day: currentDay,
                                                              uid: widget.uid,
                                                              time_rest: widget
                                                                  .time_rest,
                                                            ));
                                                            if (refresh ==
                                                                true) {
                                                              setState(() {
                                                                loadData =
                                                                    loadDataAsync();
                                                              });
                                                            }
                                                          }
                                                        : null,
                                                    style: isButtonEnabled
                                                        ? ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFFFFAC41),
                                                            shape:
                                                                const CircleBorder())
                                                        : null,
                                                    child: Text(
                                                      '$currentDay',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ), // Default disabled style
                                                  )
                                                : isSuccessButton
                                                    ? ElevatedButton(
                                                        onPressed: () {},
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFFFFAC41),
                                                            shape:
                                                                const CircleBorder()),
                                                        child: const Icon(
                                                          Icons
                                                              .check_circle_outline_outlined,
                                                          color: Colors.white,
                                                        )

                                                        // Default disabled style
                                                        )
                                                    : ElevatedButton(
                                                        onPressed: null,
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFFFFAC41),
                                                            shape:
                                                                const CircleBorder()),
                                                        child:
                                                            Text('$currentDay')

                                                        // Default disabled style
                                                        ),
                                          );
                                        }),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            )
                          : const Column(
                              children: [Text("คอรส สิ้นสุด")],
                            ),
                    ],
                  )
                : Column(
                    children: [
                      header(),
                      Expanded(
                        child: allExcount != succesUserEn.length
                            ? ListView.builder(
                                itemCount: userEnabelCourse.length,
                                itemBuilder: (context, index) {
                                  final userEn = userEnabelCourse[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      elevation: 8,
                                      child: InkWell(
                                        onTap: () async {
                                          if (index == 0) {
                                            var refresh = await Get.to(
                                              ExerciesStart(
                                                tabelID: widget.tabelID,
                                                tabelName: widget.tabelName,
                                                week: userEn.week,
                                                day: userEn.day,
                                                uid: widget.uid,
                                                time_rest: widget.time_rest,
                                              ),
                                            );
                                            if (refresh == true) {
                                              setState(() {
                                                loadData = loadDataAsync();
                                              });
                                            }
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Week: ${userEn.week}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                'Day: ${userEn.day}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              // Add other details about `userEn` here if needed
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                               
                                },
                              )
                            : const Column(
                                children: [
                                  Text(
                                    "คอร์สสิ้นสุด",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],                                                                                    
                              ),
                      ),
                      ElevatedButton(onPressed: (){deleteUserCourse();}, child: Text("ยกเลิก"))
                    ],
                  );
          }
        },
      ),
    );
  }

  Widget header() {
    double progress = succesUserEn.length / allExcount;
    String progressText = '${(progress * 100).toInt()} %';

    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: Container(
        height: 100,
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
            Center(
              child: Text(
                widget.tabelName,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
                height:
                    8), // Adding some space between text and the progress bar
            Center(
              child: LinearPercentIndicator(
                width: 350.0,
                lineHeight: 14.0,
                percent: progress,
                center: Text(
                  progressText,
                  style: const TextStyle(fontSize: 12.0),
                ),
                barRadius: const Radius.circular(16),
                backgroundColor: Colors.white,
                progressColor: Colors.amber[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

    void deleteUserCourse() async {
    final dio = Dio();
    var regBody = {
      "uid": widget.uid,
      "tid": widget.tabelID,
    };

    try {
      final response = await dio.post(
          'http://${url}/enCouser/deleteUserCourse',
          data: regBody);

      if (response.statusCode == 200) {
        // Course deleted successfully! (Handle success scenario)
        log("Course with ID ${widget.tabelID} deleted successfully!");
         Get.back(result: true);
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

}
