import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/profile_page_edit/profile_page_edit.dart';
import 'package:gym_master_fontend/services/user/edit_service.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class SelectGenderRadio extends StatefulWidget {
  const SelectGenderRadio(
      {super.key,
      required this.uid,
      required this.gender,
      required this.tokenJWT});
  final int uid;
  final int gender;
  final String tokenJWT;
  @override
  State<SelectGenderRadio> createState() => _SelectGenderRadioState();
}

class _SelectGenderRadioState extends State<SelectGenderRadio> {
  List<int> _gender = [1, 2];
  late int currentGender;
  late int uid_u;
  late String tokenJwt;

  Future<void> updateGender(int uid, int gender) async {
    const String ip = AppConstants.BASE_URL;
    final dio = Dio();
    var json = {
      "uid": uid,
      "gender": gender,
    };
    try {
      final response = await dio.post("http://$ip/user/update/gender",
          data: json,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));

      log(response.data.toString());
      if (mounted) {
        Get.back(result: currentGender);
      }
    } catch (e) {
      throw Exception("Failed to load data");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentGender = widget.gender;
    uid_u = widget.uid;
    tokenJwt = widget.tokenJWT;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 240,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      "เพศ",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ],
              ),
              RadioListTile<int>(
                title: const Text(
                  "ชาย(Male)",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Kanit'),
                ),
                value: _gender[0],
                groupValue: currentGender,
                onChanged: (int? value) {
                  setState(() {
                    currentGender = value!;
                    log(currentGender.toString());
                  });
                },
              ),
              RadioListTile<int>(
                title: const Text(
                  "หญิง(Female)",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Kanit'),
                ),
                value: _gender[1],
                groupValue: currentGender,
                onChanged: (int? value) {
                  setState(() {
                    currentGender = value!;
                    log(currentGender.toString());
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "ยกเลิก",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Kanit',
                              color: Colors.grey),
                        )),
                    TextButton(
                      onPressed: () {
                        updateGender(uid_u, currentGender);
                      },
                      child: const Text(
                        "ตกลง",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
