import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/ExPostModel.dart';
import 'package:gym_master_fontend/screen/admin_add_posture_page.dart/admin_add_posture_page.dart.dart';
import 'package:gym_master_fontend/screen/admin_edit_posture_page/admin_edit_posture_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class AdminPosturePage extends StatefulWidget {
  const AdminPosturePage({super.key, required this.tokenJwt});
  final String tokenJwt;

  @override
  State<AdminPosturePage> createState() => _AdminPosturePageState();
}

class _AdminPosturePageState extends State<AdminPosturePage> {
  List<ExPostModel> exPostList = [];
  late Future<void> loadData;
  late String tokenJwt;
  String url = AppConstants.BASE_URL;

  List<ExPostModel> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tokenJwt = widget.tokenJwt;
    loadData = loadDataAsync();
    searchController.addListener(() {
      filterList();
    });
  }

  void filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = exPostList.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.equipment.toLowerCase().contains(query) ||
            item.eid.toString().contains(query);
      }).toList();
    });
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();
    try {
      final response = await dio.get('$url/exPost/getAllExPost',
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        // log(response.data.toString());
        exPostList =
            jsonData.map((item) => ExPostModel.fromJson(item)).toList();
        filteredList = exPostList;
      } else {
        log("error upload ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  void deletePosture(int eid) async {
    final dio = Dio();
    var json = {
      "eid": eid,
    };

    try {
      final response = await dio.post("$url/exPost/delete",
          data: json,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      if (response.statusCode == 200) {
        setState(() {
          loadData = loadDataAsync();
        });
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ท่าออกกำลังกาย",
          style: TextStyle(fontFamily: "Kanit"),
        ),
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
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search exercises...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final data = filteredList[index];
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Image.network(
                                  data.gifImage!,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name,
                                    style: const TextStyle(
                                        fontFamily: "Kanit", fontSize: 16.0),
                                  ),
                                  Text(
                                    "อุปกรณ์ : ${data.equipment}",
                                    style: const TextStyle(
                                        fontFamily: "Kanit", fontSize: 14.0),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final update = await Get.to(
                                            () => AdminEditPosturePage(
                                                eid: data.eid,
                                                gif: data.gifImage!,
                                                name: data.name,
                                                des: data.description,
                                                equipment: data.equipment,
                                                muscle: data.muscle,
                                                tokenJwt: tokenJwt),
                                          );

                                          if (update == true) {
                                            if (mounted) {
                                              setState(() {
                                                loadData = loadDataAsync();
                                              });

                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.success,
                                                title: 'แก้ไขสำเร็จ',
                                                btnOkOnPress: () {},
                                              ).show();
                                            }
                                          }
                                        },
                                        icon:
                                            const FaIcon(FontAwesomeIcons.pen),
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            title: 'ยืนยันการลบท่า',
                                            btnOkOnPress: () {
                                              deletePosture(data.eid);
                                            },
                                            btnCancelOnPress: () {},
                                          ).show();
                                        },
                                        icon: const FaIcon(
                                            FontAwesomeIcons.trash),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final update = await Get.to(
            () => AdminAddPosturePage(tokenJwt: tokenJwt),
          );
          if (mounted) {
            if (update == true) {
              setState(() {
                loadData = loadDataAsync();
              });
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                title: 'เพิ่มท่าสำเร็จ',
                btnOkOnPress: () {},
              ).show();
            }
          }
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
