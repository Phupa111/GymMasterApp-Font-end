import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/Tabel/userTabel_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTabelPage extends StatefulWidget {
  const CreateTabelPage({super.key});

  @override
  State<CreateTabelPage> createState() => _CreateTabelPageState();
}

class _CreateTabelPageState extends State<CreateTabelPage> {
  final TextEditingController _couserName = TextEditingController();
  final TextEditingController _times = TextEditingController();
  final TextEditingController _dayPerWeek = TextEditingController();
  late SharedPreferences prefs;

  int? uid = 0;
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();


    uid = prefs.getInt("uid");
    setState(() {
      
    });
  }

  void createTabel() async {
    log(uid.toString());
    log(_couserName.text);
    var regBody = {
      "uid": uid,
      "couserName": _couserName.text,
      "times": int.parse(_times.text),
      "gender": 0,
      "level": 0,
      "description": "",
      "isCreatedByAdmin": 0,
      "dayPerWeek": int.parse(_dayPerWeek.text),
    };

    try {
      final dio = Dio();
      final response = await dio.post(
        'http://192.168.2.221:8080/tabel/CreatTabel',
        data: regBody,
      );

      if (response.statusCode == 200) {
        log("Success");
      }
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } catch (e) {
      print('Error creating table: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 150),
                child: Text(
                  "สร้างตาราง",
                  style: TextStyle(
                    color: Color(0xFFFFAC41),
                    fontSize: 50,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: const Color(0xFFF1F0F0),
                            border: InputBorder.none,
                            hintText: "ชื่อตาราง",
                            hintStyle: const TextStyle(
                              fontFamily: 'Kanit',
                              color: Color(0xFFFFAC41),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          controller: _couserName,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: const Color(0xFFF1F0F0),
                            border: InputBorder.none,
                            hintText: "ระยะเวลา (สัปดาห์)",
                            hintStyle: const TextStyle(
                              fontFamily: 'Kanit',
                              color: Color(0xFFFFAC41),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _times,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: const Color(0xFFF1F0F0),
                            border: InputBorder.none,
                            hintText: "จำนวนวันที่ออกกกำลังกาย",
                            hintStyle: const TextStyle(
                              fontFamily: 'Kanit',
                              color: Color(0xFFFFAC41),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          controller: _dayPerWeek,
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => SizedBox(
                                height: 250,
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 32.0,
                                  scrollController: FixedExtentScrollController(initialItem: 0),
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      _dayPerWeek.text = (value + 1).toString();
                                    });
                                  },
                                  children: List.generate(
                                    7,
                                    (index) => Center(child: Text('${index + 1} วัน')),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    createTabel();
                  Get.back(result: true);
                  },
                  child: const Text(
                    "ตกลง",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFAC41),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
