import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/ExInTabelModel.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/exercises_page.dart';

import 'package:gym_master_fontend/services/app_const.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EditTabelPage extends StatefulWidget {
  final int tabelID;
  final String tabelName;
  final int dayPerWeek;
  final int? uid;
  final int times;
  final bool isUnused;
  final String tokenJWT;

  const EditTabelPage({
    super.key,
    required this.tabelID,
    required this.tabelName,
    required this.dayPerWeek,
    required this.isUnused,
    required this.tokenJWT,
    required this.uid,
    required this.times,
  });

  @override
  State<EditTabelPage> createState() => _EditTabelPageState();
}

class _EditTabelPageState extends State<EditTabelPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<List<ExInTabelModel>> exPosts = [];
  int dayNum = 1;
  GetStorage gs = GetStorage();
  late UserModel userModel = gs.read('userModel');
  late SharedPreferences prefs;
  late Future<void> loadData;
  late Future<void> genload;

  String url = AppConstants.BASE_URL;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.dayPerWeek, vsync: this);
    loadData = fetchExercisesForAllDays();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchExercisesForAllDays() async {
    final dio = Dio();
    for (int day = 1; day <= widget.dayPerWeek; day++) {
      try {
        final response = await dio.post(
          'http://$url/tabel/getExercisesInTabel',
          data: {'tid': widget.tabelID, 'dayNum': day},
          options: Options(
            headers: {
              'Authorization': 'Bearer ${widget.tokenJWT}',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ),
        );
        final jsonData = response.data as List<dynamic>;
        exPosts.add(
            jsonData.map((item) => ExInTabelModel.fromJson(item)).toList());
      } catch (e) {
        log('Error fetching exercises for day $day: $e');
        exPosts.add([]); // Add an empty list in case of error
      }
    }
    setState(() {});
  }

  List<Widget> _generateTabs() {
    return List<Widget>.generate(widget.dayPerWeek, (index) {
      return Tab(text: 'Day ${index + 1}');
    });
  }

  List<Widget> _generateTabViews() {
    return List<Widget>.generate(widget.dayPerWeek, (index) {
      final dayExercises = exPosts.length > index ? exPosts[index] : [];
      return FutureBuilder<void>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: dayExercises.length,
                itemBuilder: (context, i) {
                  final exPost = dayExercises[i];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFFAC41)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                exPost.gifImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(exPost.name),
                                Text('Sets: ${exPost.exInTabelModelSet}'),
                                Text('Reps: ${exPost.rep}'),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !widget.isUnused,
                            child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("ลบคอร์สออกกำลังกาย"),
                                        content: const Text(
                                            "ท่านต้องการลบคคอร์สออกกำลงกายหรือไม่"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text("ยกเลิก"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Add your delete logic here
                                              deleteExInCouser(exPost.cpid);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("ยืนยัน"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  size: 30,
                                  color: Color.fromARGB(255, 243, 16, 0),
                                )),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          });
    });
  }

  void deleteExInCouser(int cpid) async {
    final dio = Dio();
    var regBody = {"cpid": cpid};

    try {
      final String endpoint = 'http://$url/tabel/deleteExInCouser';

      final response = await dio.delete(
        endpoint,
        queryParameters: regBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.tokenJWT}',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200) {
        log('Exercise deleted successfully');
        // Reload the data after deletion
        setState(() {
          // Clear the existing data
          exPosts.clear();
          // Re-fetch the data
          loadData = fetchExercisesForAllDays();
        });
      } else {
        log('Failed to delete exercise: ${response.data}');
      }
    } catch (e) {
      log('Error: $e');
    }
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
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.tabelName),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: _generateTabs(),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: _generateTabViews(),
                    ),
                  ),
                  if (widget.isUnused)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          enabelUserCourse(widget.tabelID);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.lightGreen, // Button background color
                        ),
                        child: const Text("ใช้งาน",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                ],
              ),
              floatingActionButton: !widget.isUnused
                  ? FloatingActionButton(
                      onPressed: () async {
                        var refresh = await Get.to(() => ExerciesePage(
                              tabelID: widget.tabelID,
                              dayNum: _tabController.index + 1,
                              tokenJWT: widget
                                  .tokenJWT, // Pass the current tab index + 1 for day number
                            ));
                        if (refresh == true) {
                          setState(() {
                            exPosts.clear();
                            loadData = fetchExercisesForAllDays();
                          });
                        }
                      },
                      backgroundColor: const Color(0xFFFFAC41),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      tooltip: 'เพิ่มข้อมูล',
                      child: const Icon(Icons.add),
                    )
                  : null,
            );
          }
        });
  }

  void enabelUserCourse(int tid) async {
    final dio = Dio();

    for (int i = 1; i <= widget.times; i++) {
      for (int j = 1; j <= widget.dayPerWeek; j++) {
        var regBody = {
          "uid": widget.uid,
          "tid": tid,
          "week": i,
          "day": j,
        };

        try {
          final response = await dio.post(
            'http://$url/enCouser/EnabelCouser',
            data: regBody,
            options: Options(
              headers: {
                'Authorization': 'Bearer ${widget.tokenJWT}',
              },
              validateStatus: (status) {
                return status! < 500; // Accept status codes less than 500
              },
            ),
          );

          if (response.statusCode == 200) {
            // Course enabled successfully! (Handle success scenario)
            log("Course with ID $tid enabled successfully!");
            if (i == 1 && j == 1) {
              updateWeekStart(tid);
            }
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
    Get.back(result: true);
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
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.tokenJWT}',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
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
}
