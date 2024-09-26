import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/ProgressCompareLatestModel.dart';
import 'package:gym_master_fontend/model/ProgressCompareModel.dart';
import 'package:gym_master_fontend/screen/showImageScreen/show_image_screen.dart';
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
  late Future<List<ProgressCompareLatestModel>> latestProgressImage;
  late Future<List<ProgressCompareModel>> beforeProgressImage;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    tokenJwt = widget.tokenJwt;
    latestProgressImage = PhotoService().getLatestProgress(uid!, tokenJwt!);
    beforeProgressImage = PhotoService().getBeforeProgress(uid!, tokenJwt!);
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt("uid");
    tokenJwt = prefs.getString("tokenJwt");
    log("show compare $uid");
    log("show compare $tokenJwt");
    if (uid != null) {
      loadData();
    } else {}
    setState(() {});
  }

  Future<void> loadData() async {
    latestProgressImage = PhotoService().getLatestProgress(uid!, tokenJwt!);
    beforeProgressImage = PhotoService().getBeforeProgress(uid!, tokenJwt!);
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
              FutureBuilder<List<ProgressCompareModel>>(
                future: beforeProgressImage,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'คุณยังไม่ได้ถ่ายรูปหรือเลือกรูป',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 20.0,
                      ),
                    ));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final image = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: SizedBox(
                          width: 100.0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            child: Image.network(
                              image.picture,
                              height: MediaQuery.of(context).size.height * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
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
              FutureBuilder<List<ProgressCompareLatestModel>>(
                future: latestProgressImage,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'คุณยังไม่ได้ถ่ายรูป',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 20.0,
                      ),
                    ));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final image = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: SizedBox(
                          width: 100.0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            child: Image.network(
                              image.picture,
                              height: MediaQuery.of(context).size.height * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
