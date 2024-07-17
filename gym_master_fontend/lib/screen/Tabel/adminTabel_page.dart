import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gym_master_fontend/model/TabelModel.dart';
import 'package:gym_master_fontend/widgets/menu_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminTabelPage extends StatefulWidget {
  const AdminTabelPage({Key? key}) : super(key: key);

  @override
  State<AdminTabelPage> createState() => _AdminTabelPageState();
}

class _AdminTabelPageState extends State<AdminTabelPage> with TickerProviderStateMixin {
  List<TabelModel> adminUnUsedTabels = [];
  List<TabelModel> adminActiveTabels = [];
  late Future<void> loadData;

  late TabController _tabController;
  late SharedPreferences prefs;
  int? uid;
  int? role;

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
    log(uid.toString());
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
    return Scaffold(
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
            return  role !=0?   TabBarView(
              controller: _tabController,
              children: [
                buildListView(adminUnUsedTabels, true),
                buildListView(adminActiveTabels, false),
              ],
            ): buildListView(adminUnUsedTabels, true);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFFFAC41),
        foregroundColor: Colors.white,
        elevation: 4,
        tooltip: 'เพิ่มข้อมูล',
        child: const Icon(Icons.add),
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
              if (isUnused) {
                // Action for unused item
              } else {
                // Action for active item
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
                  Row(
                    children: [
                      if (isUnused)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Action for use button
                              enabelUserCourse(tabel.tid);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen,
                            ),
                            child: const Text(
                              "ใช้งาน",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              deleteUserCourse(tabel.tid);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              "เลิกใช้งาน",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                 
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
   void enabelUserCourse(int tid) async {
    final dio = Dio();
    var regBody = {
      "uid": uid,
      "tid": tid,
      "week": 1,
      "day": 1,
    };

    try {
      final response = await dio.post(
          'http://192.168.2.221:8080/enCouser/EnabelCouser',
          data: regBody);

      if (response.statusCode == 200) {
        // Course enabled successfully! (Handle success scenario)
        log("Course with ID $tid enabled successfully!");
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
    void deleteUserCourse(int tid) async {
    final dio = Dio();
    var regBody = {
      "uid": uid,
      "tid": tid,
    };

    try {
      final response = await dio.post(
          'http://192.168.2.221:8080/enCouser/deleteUserCourse',
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
      final unusedResponse = await dio.get('http://192.168.2.221:8080/Tabel/getAdminTabel');
      final unusedJsonData = unusedResponse.data as List<dynamic>;
      adminUnUsedTabels = unusedJsonData.map((item) => TabelModel.fromJson(item)).toList();
      log(adminUnUsedTabels.length.toString());

      final activeResponse = await dio.post(
        'http://192.168.2.221:8080/tabel/getEnnabelAdminTabel',
        data: regBody,
      );
      final activeJsonData = activeResponse.data as List<dynamic>;
      adminActiveTabels = activeJsonData.map((item) => TabelModel.fromJson(item)).toList();
      log(adminActiveTabels.length.toString());
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception('Error fetching data');
    }
  }
}
