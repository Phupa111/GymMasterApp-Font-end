import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddEquipmentPage extends StatefulWidget {
  const AdminAddEquipmentPage({super.key, required this.tokenJwt});
  final String tokenJwt;

  @override
  State<AdminAddEquipmentPage> createState() => _AdminAddEquipmentPageState();
}

class _AdminAddEquipmentPageState extends State<AdminAddEquipmentPage> {
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? fileImage;
  String url = AppConstants.BASE_URL;

  pickWithGallery() async {
    fileImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      log(fileImage!.path);
    });
    Get.back();
  }

  pickWithCamera() async {
    fileImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (fileImage != null) {
        log(fileImage!.path);
      }
    });
    Get.back();
  }

  void addEquipment(String name, String tokenJwt) async {
    final dio = Dio();
    var json = {"name": name};
    try {
      final response = await dio.post("$url/equipment/addEquipment",
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
          backgroundColor: Colors.orange,
          title: const Text(
            "เพิ่มอุปกรณ์",
            style: TextStyle(fontFamily: "Kanit"),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                focusColor: const Color(0xFFFFAC41),
                prefixIcon: const Icon(
                  FontAwesomeIcons.toolbox,
                  color: Color(0xFFFFAC41),
                ),
                contentPadding: const EdgeInsets.all(15.0),
                filled: true,
                fillColor: const Color(0xFFF1F0F0),
                hintText: "ชื่ออุปกรณ์",
                hintStyle: const TextStyle(
                  fontFamily: 'Kanit',
                  color: Color(0xFFFFAC41),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
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
                  title: "กรุณาใส่ข้อมูลให้ครบ",
                  btnOkOnPress: () {},
                ).show();
              } else {
                addEquipment(_nameController.text, widget.tokenJwt);
              }
            },
            child: const Text(
              "เพิ่ม",
              style: TextStyle(
                  fontFamily: "Kanit", color: Colors.white, fontSize: 18.0),
            ),
          )
        ],
      ),
    );
  }
}
