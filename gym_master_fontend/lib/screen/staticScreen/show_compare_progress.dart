import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/ProgressCompareLatestModel.dart';
import 'package:gym_master_fontend/model/ProgressCompareModel.dart';
import 'package:gym_master_fontend/screen/showImageScreen/show_image_screen.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:gym_master_fontend/services/photo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCompareProgress extends StatefulWidget {
  const ShowCompareProgress(
      {super.key, required this.uid, required this.tokenJwt});
  final int uid;
  final String tokenJwt;

  @override
  State<ShowCompareProgress> createState() => _ShowCompareProgressState();
}

class _ShowCompareProgressState extends State<ShowCompareProgress> {
  int? uid;
  String? tokenJwt;
  late SharedPreferences prefs;
  late List<ProgressCompareLatestModel> latestProgressImage;
  late List<ProgressCompareModel> beforeProgressImage;
  late Future<void> progressLoadData;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    tokenJwt = widget.tokenJwt;
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt("uid");
    tokenJwt = prefs.getString("tokenJwt");
    log("show compare $uid");
    log("show compare $tokenJwt");
    if (uid != null) {
      progressLoadData = loadData();
    } else {}
    setState(() {});
  }

  Future<void> loadData() async {
    // latestProgressImage = PhotoService().getLatestProgress(uid!, tokenJwt!);
    // beforeProgressImage = PhotoService().getBeforeProgress(uid!, tokenJwt!);
    final dio = Dio();
    const String url = AppConstants.BASE_URL;
    try {
      final response = await dio.get(
        '$url/progress/getBeforeProgress/$uid',
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJwt',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      final response1 = await dio.get(
        '$url/progress/getLatestProgress/$uid',
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJwt',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        beforeProgressImage =
            data.map((e) => ProgressCompareModel.fromJson(e)).toList();
      } else {
        beforeProgressImage = [];
      }

      if (response1.statusCode == 200) {
        // ตรวจสอบข้อมูลที่ได้รับว่าเป็น List หรือไม่
        if (response1.data is List) {
          final List<dynamic> data = response1.data;
          latestProgressImage =
              data.map((e) => ProgressCompareLatestModel.fromJson(e)).toList();
        } else {
          // ถ้าไม่ใช่ List ให้แสดง Error ขึ้นมา
          throw Exception(
              'Expected a List but got ${response1.data.runtimeType}');
        }
      } else {
        latestProgressImage = [];
      }
    } catch (e) {
      throw Exception('Failed to get before image Progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              SizedBox(
                width: 200.0,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () async {
                    final update = await Get.to(() => ShowImageScreen(
                          uid: uid!,
                          tokenJwt: tokenJwt!,
                        ));
                    if (update == 1) {
                      setState(() {
                        loadData();
                      });
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.image,
                        color: Colors.white,
                      ),
                      Text(
                        "ดูรูป",
                        style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 18.0,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future: loadData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    if (beforeProgressImage.isEmpty) {
                      return const Center(
                          child: Text(
                        'คุณยังไม่ได้ถ่ายรูปหรือเลือกรูป',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 20.0,
                        ),
                      ));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.red,
                        elevation: 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            beforeProgressImage.isEmpty
                                ? const Center(
                                    child: Text(
                                    'คุณยังไม่ได้ถ่ายรูปหรือเลือกรูป',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 20.0,
                                    ),
                                  ))
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Before",
                                            style: TextStyle(
                                              fontFamily: 'Kanit',
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                          child: Image.network(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              beforeProgressImage[0].picture,
                                              fit: BoxFit.cover),
                                        ),
                                      ],
                                    ),
                                  ),
                            latestProgressImage.isEmpty
                                ? const Center(
                                    child: Text(
                                    'คุณยังไม่ได้ถ่ายรูป',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 20.0,
                                    ),
                                  ))
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "After",
                                            style: TextStyle(
                                              fontFamily: 'Kanit',
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                          child: Image.network(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              latestProgressImage[0].picture,
                                              fit: BoxFit.cover),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
