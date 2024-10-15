import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class AdminEditEquipmentPage extends StatefulWidget {
  const AdminEditEquipmentPage(
      {super.key,
      required this.tokenJwt,
      required this.name,
      required this.eqid});
  final String tokenJwt;
  final String name;
  final int eqid;

  @override
  State<AdminEditEquipmentPage> createState() => _AdminEditEquipmentPageState();
}

class _AdminEditEquipmentPageState extends State<AdminEditEquipmentPage> {
  final _nameController = TextEditingController();
  String? tokenJwt;
  String url = AppConstants.BASE_URL;

  @override
  void initState() {
    super.initState();
    tokenJwt = widget.tokenJwt;
  }

  void updateEquipment(int eqid, String name) async {
    final dio = Dio();
    var json = {
      "eqid": eqid,
      "name": name,
    };
    try {
      final response = await dio.post("$url/equipment/update",
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
        Get.back(result: true);
      } else {
        log("error Code: ${response.statusCode}");
        Get.back(result: false);
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'อุปกรณ์',
          style: TextStyle(fontFamily: 'Kanit'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "จาก ${widget.name} เป็น",
              style: const TextStyle(fontFamily: 'Kanit', fontSize: 18.0),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          const FaIcon(FontAwesomeIcons.arrowDown),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อ',
                labelStyle: TextStyle(
                  fontFamily: 'Kanit',
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              if (_nameController.text.isEmpty) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  title: 'กรุณาใส่ข้อมูลให้ครบ',
                  btnOkOnPress: () {},
                ).show();
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  title: 'ยืนยันการแก้ไข',
                  btnOkOnPress: () {
                    updateEquipment(widget.eqid, _nameController.text);
                  },
                  btnCancelOnPress: () {},
                ).show();
              }
            },
            child: const Text(
              "ยืนยัน",
              style: TextStyle(
                  fontFamily: 'Kanit', fontSize: 18.0, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
