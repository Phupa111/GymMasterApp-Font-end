import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/TabelEnModel.dart';
import 'package:gym_master_fontend/model/TabelModel.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/Course_detail_page.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/exercises_start_page.dart';
import 'package:gym_master_fontend/screen/Tabel/createTabel_page.dart';
import 'package:gym_master_fontend/screen/Tabel/editTabel_page.dart';
import 'package:gym_master_fontend/screen/hom_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:gym_master_fontend/widgets/menu_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTabelPage extends StatefulWidget {
  const UserTabelPage({Key? key}) : super(key: key);

  @override
  State<UserTabelPage> createState() => _UserTabelPageState();
}

class _UserTabelPageState extends State<UserTabelPage>
    with TickerProviderStateMixin {
  List<TabelModel> unusedTabels = [];
  List<TabelEnModel> activeTabels = [];
  late Future<void> loadData;

  late final TabController _tabController;
  late SharedPreferences prefs;
  int? uid;
  int? role;
    String url = AppConstants.BASE_URL;
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
    _tabController = TabController(length: 2, vsync: this);
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt("uid");
    role = prefs.getInt("role");
    setState(() {
      loadData = loadDataAsync();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return role != 0
        ? Scaffold(
            appBar: AppBar(
              title: const Text("ตารางของฉัน"),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "ไม่ได้ใช้งาน"),
                  Tab(text: "กำลังใช้งาน"),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.to(MenuNavBar());
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
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      buildListView(unusedTabels, true),
                      buildEnListView(activeTabels, false),
                    ],
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                var refresh = await Get.to(const CreateTabelPage());
                if (refresh == true) {
                  setState(() {
                    loadData = loadDataAsync();
                  });
                }
              },
              backgroundColor: const Color(
                  0xFFFFAC41), // Change the background color to your desired color
              foregroundColor: Colors
                  .white, // Change the foreground color (icon color) to your desired color
              elevation: 4, // Change the elevation if needed
              tooltip: 'เพิ่มข้อมูล', // Add a tooltip for accessibility
              child:
                  const Icon(Icons.add), // Change the icon to your desired icon
            ),
          )
        : Scaffold(
            appBar: AppBar(),
            body: Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAC41),
                  fixedSize: const Size(300, 50),
                ),
                child: const Text("Login",
                    style: TextStyle(fontFamily: 'Kanit', color: Colors.white)),
              ),
            ),
          );
  }

  Widget buildListView(List<TabelModel> tabels, bool isUnused) {
    return ListView.builder(
      itemCount: tabels.length,
      itemBuilder: (context, index) {
        final tabel = tabels[index];
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
                  isUnused: isUnused,
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
                              enabelUserCourse(
                                  tabel.tid, tabel.times, tabel.dayPerWeek);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.lightGreen, // Button background color
                            ),
                            child: const Text("ใช้งาน",
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
    );
  }

   Widget buildEnListView(List<TabelEnModel> tabels, bool isUnused) {
    return ListView.builder(
      itemCount: tabels.length,
      itemBuilder: (context, index) {
        final tabel = tabels[index];
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
                    uid: uid ?? 0,time_rest: tabel.timeRest,));
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
    );
  }



  void enabelUserCourse(int tid, int times, int dayPerWeek) async {
    final dio = Dio();

    for (int i = 1; i <= times; i++) {
      for (int j = 1; j <= dayPerWeek; j++) {
        var regBody = {
          "uid": uid,
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
      "uid": uid, // Use widget.uid for the current user ID
      "tid": tid,
      "week": 1,
      "day": 1
    };
    final dio = Dio();

    try {
      final response = await dio.post(
        'http://${url}/enCouser/updateWeekStartDate',
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
      "uid": uid,
      "tid": tid,
    };

    try {
      final response = await dio.post(
          'http://${url}/enCouser/deleteUserCourse',
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
    log(uid.toString());
    var regBody = {
      "uid": uid,
    };
    try {
      final unusedResponse = await dio.post(
          'http://${url}/tabel/getUnUesUserTabel',
          data: regBody);
      final unusedJsonData = unusedResponse.data
          as List<dynamic>; // Assuming the response is a list
      unusedTabels =
          unusedJsonData.map((item) => TabelModel.fromJson(item)).toList();
      log(unusedTabels.length.toString());

      final activeResponse = await dio.post(
          'http://${url}/tabel/getEnnabelUserTabel',
          data: regBody);
      final activeJsonData = activeResponse.data
          as List<dynamic>; // Assuming the response is a list
      activeTabels =
          activeJsonData.map((item) => TabelEnModel.fromJson(item)).toList();
      log(activeTabels.length.toString());
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception('Error fetching data');
    }
  }
}
