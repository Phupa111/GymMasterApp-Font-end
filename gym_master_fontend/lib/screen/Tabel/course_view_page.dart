import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/TabelEnModel.dart';
import 'package:gym_master_fontend/model/TabelModel.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/course_detail_page.dart';
import 'package:gym_master_fontend/screen/Tabel/editTabel_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CourseView extends StatefulWidget {
  final int? uid;
  final bool isAdminCouser;
  final bool isEnnabel;
  const CourseView({super.key, required this.uid, required this.isAdminCouser, required this.isEnnabel});

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  String url = AppConstants.BASE_URL;
  List<TabelModel> unusedTabels = [];
  List<TabelEnModel> activeTabels = [];
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync(); // Initialize the Future
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            children: [
              widget.isAdminCouser && !widget.isEnnabel
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              // Logic for filtering or refreshing data can be added here
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text("ทั้งหมด"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Logic for filtering by male
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text("ชาย"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Logic for filtering by female
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text("หญิง"),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(), // Return an empty widget if not an admin course
           !widget.isEnnabel?   Expanded(
                child: ListView.builder(
                  itemCount: unusedTabels.length,
                  itemBuilder: (context, index) {
                    final tabel = unusedTabels[index];
                    return Card(
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 8,
                      child: InkWell(
                        onTap: () {
                          Get.to(EditTabelPage(
                            tabelID: tabel.tid,
                            tabelName: tabel.couserName,
                            dayPerWeek: tabel.dayPerWeek,
                            isUnused: true,
                          ));
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
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                         enabelUserCourse(tabel.tid, tabel.times, tabel.dayPerWeek);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightGreen,
                                      ),
                                      child: const Text(
                                        "ใช้งาน",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(EditTabelPage(
                                          tabelID: tabel.tid,
                                          tabelName: tabel.couserName,
                                          dayPerWeek: tabel.dayPerWeek,
                                          isUnused: widget.isEnnabel,
                                        ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        "แก้ไข",
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ):Expanded(child: ListView.builder(
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
                    uid: widget.uid ?? 0,time_rest: tabel.timeRest,));
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
                 
                    Padding(padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        
                    child:  LinearPercentIndicator(
                                          width: 300.0,
                                          lineHeight: 14.0,
                                          percent: tabel.count/(tabel.dayPerWeek*tabel.times),
                                          center: Text(
                                           '${((tabel.count/(tabel.dayPerWeek*tabel.times))*100).toInt()} %',
                                            style: const TextStyle(fontSize: 12.0),
                                          ),
                                         
                                          barRadius: const Radius.circular(16),
                                          backgroundColor: Colors.white,
                                          progressColor: Colors.amber[400],
                                        ),),
                
                  Row(
                    children: [
          
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              deleteUserCourse(tabel.tid);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Button background color
                            ),
                            child: const Text("เลิกใช้งาน",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(EditTabelPage(
                              tabelID: tabel.tid,
                              tabelName: tabel.couserName,
                              dayPerWeek: tabel.dayPerWeek,
                              isUnused: false,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white, // Button background color
                          ),
                          child: const Text("แก้ไข",
                              style: TextStyle(color: Colors.orange)),
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
    ))
            ],
          );
        }
      },
    );
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();
    log(widget.uid.toString());
    var regBody = {
      "uid": widget.uid,
    };
    try {
      if(!widget.isEnnabel)
      {
              final String endpoint = widget.isAdminCouser
          ? 'http://$url/Tabel/getAdminTabel'
          : 'http://$url/tabel/getUnUesUserTabel';

      final  response = widget.isAdminCouser
          ? await dio.get(endpoint)
          : await dio.post(endpoint, data: regBody);

      final List<dynamic> jsonData = response.data as List<dynamic>;
        unusedTabels = jsonData.map((item) => TabelModel.fromJson(item)).toList();
      }
      else
      {
               final String endpoint = widget.isAdminCouser
          ? 'http://$url/tabel/getEnnabelAdminTabel'
          : 'http://$url/tabel/getEnnabelUserTabel';

      final  response = await dio.post(endpoint, data: regBody);
         final List<dynamic> jsonData = response.data as List<dynamic>;
        activeTabels= jsonData.map((item) => TabelEnModel.fromJson(item)).toList();
      }
  
      setState(() {
      
      });
      log(unusedTabels.length.toString());
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception('Error fetching data');
    }
  }

    void enabelUserCourse(int tid, int times, int dayPerWeek) async {
    final dio = Dio();

    for (int i = 1; i <= times; i++) {
      for (int j = 1; j <= dayPerWeek; j++) {
        var regBody = {
          "uid": widget.uid,
          "tid": tid,
          "week": i,
          "day": j,
        };

        try {
          final response = await dio.post(
            'http://${url}/enCouser/EnabelCouser',
            data: regBody,
          );

          if (response.statusCode == 200) {
            // Course enabled successfully! (Handle success scenario)
            log("Course with ID $tid enabled successfully!");
            if (i == 1 && j == 1) {
              updateWeekStart(tid);
            }
            setState(() {
              loadData = loadDataAsync(); // Reload the data
            });
          } else {
            // Handle error based on status code
            log("Error enabling course: ${response.statusCode}");
            // You can also check the response body for specific error messages
          }
        } catch (e) {
          // Handle network or other errors
          log("Error enabling course: $e");
        }
      }
    }
  }

  void updateWeekStart(int tid) async {
    var regUpdateWeekBody = {
      "uid": widget.uid, // Use widget.uid for the current user ID
      "tid": tid,
      "week": 1,
      "day": 1
    };
    final dio = Dio();

    try {
      final response = await dio.post(
        'http://$url/enCouser/updateWeekStartDate',
        data: regUpdateWeekBody,
      );
      if (response.statusCode == 200) {
        log("Week start date updated successfully");
      } else {
        log("Failed to update week start date: ${response.statusCode}");
      }
    } catch (e) {
      log("Error updating week start date: $e");
    }
  }

    void deleteUserCourse(int tid) async {
    final dio = Dio();
    var regBody = {
      "uid": widget.uid,
      "tid": tid,
    };

    try {
      final response = await dio.post(
          'http://$url/enCouser/deleteUserCourse',
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
}
