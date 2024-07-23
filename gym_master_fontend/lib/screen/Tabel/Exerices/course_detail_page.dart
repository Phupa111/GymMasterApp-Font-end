import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/UserEnabelCourseModel.dart';
import 'package:gym_master_fontend/model/weekDiffModel.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/exercises_start_page.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CourseDetailPage extends StatefulWidget {
  final int tabelID;
  final String tabelName;
  final int dayPerWeek;
  final int times;
  final int uid;
  final int time_rest;

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
  List<UserEnabelCourse> succesUserEn = [];
  late Future<void> loadData;
  WeeksDiffModel? weeksDiffModel;
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
        'http://192.168.2.151:8080/enCouser/getWeek?uid=${widget.uid}&tid=${widget.tabelID}',
      );
      if (weekResponse.statusCode == 200) {
        weeksDiffModel = WeeksDiffModel.fromJson(weekResponse.data[0]);
        week_count += weeksDiffModel!.weeksDiff;
        log("week count $week_count");

        final response = await dio.get(
          week_count > widget.times
              ? 'http://192.168.2.151:8080/enCouser/getNotSuccesUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}'
              : 'http://192.168.2.151:8080/enCouser/getIsNotSuccesUserEnCouserbyWeek?uid=${widget.uid}&tid=${widget.tabelID}&week=$week_count',
        );

        final userSuccessEnRes = await dio.get(
          'http://192.168.2.151:8080/enCouser/getSuccesUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}',
        );

        setState(() {
          userEnabelCourse = (response.data as List)
              .map((json) => UserEnabelCourse.fromJson(json))
              .toList();

          succesUserEn = (userSuccessEnRes.data as List)
              .map((json) => UserEnabelCourse.fromJson(json))
              .toList();

          if (userEnabelCourse.isNotEmpty) {
            day = userEnabelCourse[0].day;
            log("Current day: $day");
          }
          log("Success courses count: ${succesUserEn.length}");
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     backgroundColor: Colors.orange,
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
                           Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.orange,Color(0xFFFFB74D)],
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
                            style: const TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ), 
                        Center(
                          child: LinearPercentIndicator(
                                          width: 350.0,
                                          lineHeight: 14.0,
                                          percent: succesUserEn.length/allExcount,
                                          center: Text(
                                           '${((succesUserEn.length/allExcount)*100).toInt()} %',
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
                ),
                
                   allExcount != succesUserEn.length? SingleChildScrollView(
                        child: Column(
                          children: List.generate(widget.times, (weekIndex) {
                            int currentWeek = weekIndex + 1;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Week $currentWeek'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(widget.dayPerWeek, (dayIndex) {
                                    int currentDay = dayIndex + 1;
                                    bool isButtonEnabled = userEnabelCourse.any((course) =>
                                        currentWeek == week_count &&
                                        currentDay == day &&
                                        course.isSuccess == 0);
                                    bool isSuccessButton = succesUserEn.any((course) =>
                                        course.week == currentWeek && course.day == currentDay && course.isSuccess ==1);
                    
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:isButtonEnabled ? ElevatedButton(
                                        onPressed: isButtonEnabled
                                            ? () async {
                                                var refresh = await Get.to(() => ExerciesStart(
                                                      tabelID: widget.tabelID,
                                                      tabelName: widget.tabelName,
                                                      week: currentWeek,
                                                      day: currentDay,
                                                      uid: widget.uid,
                                                      time_rest: widget.time_rest,
                                                    ));
                                                if (refresh == true) {
                                                  setState(() {
                                                    loadData = loadDataAsync();
                                                  
                                                  });
                                                }
                                              }
                                            : null,
                                        style: isButtonEnabled
                                            ? ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFFFAC41),
                                                shape:  const CircleBorder()
                                              )
                                    
                      
                                                : null,
                                        child: Text('$currentDay',style:const TextStyle(color: Colors.white),), // Default disabled style
                                      ) : isSuccessButton ? ElevatedButton(
                                        onPressed: 
                                            () {}
                                           ,
                                        style:
                                            ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFFFAC41),
                                                shape:  const CircleBorder()
                                              ),
                                        child: const Icon(Icons.check_circle_outline_outlined,color:Colors.white,)
                      
                                                // Default disabled style
                                      ): ElevatedButton(
                                        onPressed: 
                                             null,
                                        style:
                                             ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFFFAC41),
                                                shape:  const CircleBorder()
                                              ),
                                        child: Text('$currentDay')
                      
                                                // Default disabled style
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          }),
                        ),
                      ): Column(
                      children: [
                        Text("คอรส สิ้นสุด")
                      ],
                      ),
                  ],
                )
                : Column(
                    children: [
                            Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.orange,Color(0xFFFFB74D)],
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
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                       allExcount != succesUserEn.length ? Text("ซ่อม") : Text(""),
                      Expanded(
                        child: allExcount != succesUserEn.length ? ListView.builder(
                          itemCount: userEnabelCourse.length,
                          itemBuilder: (context, index) {
                            final userEn = userEnabelCourse[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFFFAC41)),
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Week: ${userEn.week} Day: ${userEn.day}"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ):Column(
                      children: [
                        Text("คอรส สิ้นสุด")
                      ],
                      ),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}
