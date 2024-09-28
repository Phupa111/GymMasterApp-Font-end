import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTabelPage extends StatefulWidget {
  final int? role;
  const CreateTabelPage({super.key, required this.role});

  @override
  State<CreateTabelPage> createState() => _CreateTabelPageState();
}

class _CreateTabelPageState extends State<CreateTabelPage> {
  final TextEditingController _couserName = TextEditingController();
  final TextEditingController _times = TextEditingController();
  final TextEditingController _dayPerWeek = TextEditingController();
  final TextEditingController _timeRest = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _discription = TextEditingController();
  final TextEditingController _level = TextEditingController();
  late SharedPreferences prefs;
  String url = AppConstants.BASE_URL;
  late String tokenJWT;
  final _formKey = GlobalKey<FormState>();
  int? uid = 0;
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();

    tokenJWT = prefs.getString("tokenJwt")!;
    uid = prefs.getInt("uid");
    setState(() {});
  }

  void createTabel() async {
    log(uid.toString());
    log(_couserName.text);
    var regBodyAdmin = {
      "uid": uid,
      "couserName": _couserName.text,
      "times": int.parse(_times.text),
      "gender": _gender.text.isEmpty ? 0 : int.parse(_gender.text),
      "level": _level.text.isEmpty ? 0 : int.parse(_level.text),
      "description": _discription.text,
      "isCreateByAdmin": widget.role == 2 ? 1 : 0,
      "dayPerWeek": int.parse(_dayPerWeek.text),
      "time_rest": int.parse(_timeRest.text)
    };

    try {
      final dio = Dio();
      final response = await dio.post(
        '$url/tabel/CreatTabel',
        data: regBodyAdmin,
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJWT',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Success");
      }
      log('Response status: ${response.statusCode}');
      log('Response data: ${response.data}');
    } catch (e) {
      log('Error creating table: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5),
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
                padding: const EdgeInsets.only(top: 10),
                child: Form(
                  key: _formKey, // Add a GlobalKey to the form for validation
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Field for Table Name
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
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          controller: _couserName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณาใส่ชื่อตาราง';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Field for Duration (Weeks)
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
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 32.0,
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: 0),
                                      onSelectedItemChanged: (value) {
                                        setState(() {
                                          _times.text = (value + 1).toString();
                                        });
                                      },
                                      children: List.generate(
                                        53,
                                        (index) => Center(
                                            child:
                                                Text('${index + 1} สัปดาห์')),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_dayPerWeek.text.isEmpty) {
                                        _times.text = "1";
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text('ตกลง'),
                                  ),
                                ],
                              ),
                            );
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _times,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณาใส่ระยะเวลา';
                            }
                            return null;
                          },
                        ),
                      ),

                      Visibility(
                        visible: widget.role == 2,
                        child: Padding(
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
                              hintText: "เพศ",
                              hintStyle: const TextStyle(
                                fontFamily: 'Kanit',
                                color: Color(0xFFFFAC41),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            controller: _gender,
                            readOnly: true,
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: CupertinoPicker(
                                        backgroundColor: Colors.white,
                                        itemExtent: 32.0,
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem: 0),
                                        onSelectedItemChanged: (value) {
                                          setState(() {
                                            _gender.text =
                                                (value + 1).toString();
                                            log(_gender.text);
                                          });
                                        },
                                        children: List.generate(
                                          2,
                                          (index) => Center(
                                            child: Text(index == 0
                                                ? ' 1 ชาย'
                                                : ' 2 หญิง'), // Use ternary directly for the text
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_gender.text.isEmpty) {
                                          _gender.text = "1";
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text('ตกลง'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณาเลือกเพศ';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      Visibility(
                        visible: widget.role == 2,
                        child: Padding(
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
                              hintText: "ความยาก",
                              hintStyle: const TextStyle(
                                fontFamily: 'Kanit',
                                color: Color(0xFFFFAC41),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            controller: _level,
                            readOnly: true,
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: CupertinoPicker(
                                        backgroundColor: Colors.white,
                                        itemExtent: 32.0,
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem: 0),
                                        onSelectedItemChanged: (value) {
                                          setState(() {
                                            _level.text =
                                                (value + 1).toString();
                                          });
                                        },
                                        children: List.generate(
                                          3,
                                          (index) => Center(
                                            child: Text(
                                              index == 0
                                                  ? '1 Beginner'
                                                  : index == 1
                                                      ? '2 Intermediate'
                                                      : '3 Advanced', // Nested ternary operators for 3 conditions
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_level.text.isEmpty) {
                                          _level.text = "1";
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text('ตกลง'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณาเลือกความยาก';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      // Field for Days Per Week

                      Visibility(
                        visible: widget.role == 2,
                        child: Padding(
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
                              hintText: "คำอธิบายคอร์ส",
                              hintStyle: const TextStyle(
                                fontFamily: 'Kanit',
                                color: Color(0xFFFFAC41),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            controller: _discription,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณาใส่คำอธิบายคอร์ส';
                              }
                              return null;
                            },
                          ),
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
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          controller: _dayPerWeek,
                          readOnly: true,
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 32.0,
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: 0),
                                      onSelectedItemChanged: (value) {
                                        setState(() {
                                          _dayPerWeek.text =
                                              (value + 1).toString();
                                        });
                                      },
                                      children: List.generate(
                                        7,
                                        (index) => Center(
                                            child: Text('${index + 1} วัน')),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_dayPerWeek.text.isEmpty) {
                                        _dayPerWeek.text = "1";
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text('ตกลง'),
                                  ),
                                ],
                              ),
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณาเลือกจำนวนวันที่ออกกกำลังกาย';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Field for Rest Time
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
                            hintText: "ระยะเวลาพัก",
                            hintStyle: const TextStyle(
                              fontFamily: 'Kanit',
                              color: Color(0xFFFFAC41),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          controller: _timeRest,
                          readOnly: true,
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 32.0,
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: 0),
                                      onSelectedItemChanged: (value) {
                                        setState(() {
                                          _timeRest.text =
                                              (value + 30).toString();
                                        });
                                      },
                                      children: List.generate(
                                        91,
                                        (index) => Center(
                                            child:
                                                Text('${index + 30} วินาที')),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_timeRest.text.isEmpty) {
                                        _timeRest.text = "30";
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text('ตกลง'),
                                  ),
                                ],
                              ),
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณาเลือกระยะเวลาพัก';
                            }
                            return null;
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
                    if (_formKey.currentState?.validate() ?? false) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("ยืนยันการสร้างตาราง"),
                            content: const Text(
                                "ท่านต้องการสร้างตารางออกกำลังกายหรือไม่"),
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
                                  // Add your create table logic here
                                  createTabel();
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Get.back(
                                      result:
                                          true); // If using GetX, navigate back
                                },
                                child: const Text("ยืนยัน"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFAC41),
                  ),
                  child: const Text(
                    "ตกลง",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
