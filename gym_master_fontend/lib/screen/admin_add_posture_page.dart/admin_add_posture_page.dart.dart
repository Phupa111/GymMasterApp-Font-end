import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/equipmentModel.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dioins;

class AdminAddPosturePage extends StatefulWidget {
  const AdminAddPosturePage({super.key, required this.tokenJwt});
  final String tokenJwt;
  @override
  State<AdminAddPosturePage> createState() => _AdminAddPosturePageState();
}

class _AdminAddPosturePageState extends State<AdminAddPosturePage> {
  final _namePost = TextEditingController();
  final _description = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? fileImage;
  List<EquipmentModel> equipmentList = [];
  List<String> targetMuscle = [
    'Chest',
    'Abs',
    'Leg',
    'Back',
    'Trapezius',
    'Shoulders',
    'Neck',
    'Arms'
  ];
  String url = AppConstants.BASE_URL;
  EquipmentModel? selectedEquipment;
  String? selectedMuscle;
  String? tokenJwt;

  @override
  void initState() {
    super.initState();
    tokenJwt = widget.tokenJwt;
    loadEquipment();
  }

  pickWithGallery() async {
    fileImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      log(fileImage!.path);
    });
  }

  void uploadPosture(
      XFile gif, String name, String des, int equipId, String muscle) async {
    final dio = Dio();
    late int mid;

    // ตรวจสอบ muscle และกำหนดค่า mid ตามเงื่อนไข
    if (muscle == 'Chest') {
      mid = 1;
    } else if (muscle == 'Abs') {
      mid = 2;
    } else if (muscle == 'Leg') {
      mid = 3;
    } else if (muscle == 'Back') {
      mid = 4;
    } else if (muscle == 'Trapezius') {
      mid = 5;
    } else if (muscle == 'Shoulders') {
      mid = 6;
    } else if (muscle == 'Neck') {
      mid = 7;
    } else {
      mid = 8;
    }
    try {
      final fileGif = File(gif.path);

      dioins.FormData formData = dioins.FormData.fromMap({
        "name": name,
        "des": des,
        "equipId": equipId,
        "muscle": mid,
        "file": await dioins.MultipartFile.fromFile(
          fileGif.path,
          filename: fileGif.path.split('/').last,
          contentType: MediaType("image", "gif"),
        ),
      });

      final response = await dio.post('$url/exPost/uploadPosture',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
            contentType: 'multipart/form-data',
          ));
      if (response.statusCode == 200) {
        log("upload successfully");
        Get.back(result: true);
      } else {
        log("error upload ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> loadEquipment() async {
    final dio = Dio();
    try {
      final response = await dio.get("$url/equipment/getAllEquipment",
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        setState(() {
          equipmentList =
              jsonData.map((e) => EquipmentModel.fromJson(e)).toList();
        });
      } else {
        log("Failed to load data response code : ${response.statusCode}");
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
          "เพิ่มท่าออกกำลังกาย",
          style: TextStyle(fontFamily: 'Kanit'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: fileImage != null && fileImage!.path.isNotEmpty
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 197, 197, 197),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Image.file(
                        File(fileImage!.path),
                        fit: BoxFit.cover,
                      ))
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 197, 197, 197),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "เพิ่ม GIF ท่า",
                            style:
                                TextStyle(fontFamily: "Kanit", fontSize: 16.0),
                          ),
                          IconButton(
                            onPressed: pickWithGallery,
                            icon: const FaIcon(FontAwesomeIcons.plus),
                          )
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _namePost,
                decoration: InputDecoration(
                  focusColor: const Color(0xFFFFAC41),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.person,
                    color: Color(0xFFFFAC41),
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: const Color(0xFFF1F0F0),
                  hintText: "ชื่อท่า",
                  hintStyle: const TextStyle(
                    fontFamily: 'Kanit',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _description,
                decoration: InputDecoration(
                  focusColor: const Color(0xFFFFAC41),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.t,
                    color: Color(0xFFFFAC41),
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: const Color(0xFFF1F0F0),
                  hintText: "คำอธิบาย",
                  hintStyle: const TextStyle(
                    fontFamily: 'Kanit',
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
            equipmentList.isEmpty
                ? const LinearProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<EquipmentModel>(
                      padding: const EdgeInsets.all(8.0),
                      isExpanded: true,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      hint: const Text('อุปกรณ์ที่ใช้'),
                      value: selectedEquipment,
                      onChanged: (EquipmentModel? newValue) {
                        setState(() {
                          selectedEquipment = newValue;
                        });
                      },
                      items: equipmentList
                          .map<DropdownMenuItem<EquipmentModel>>(
                              (EquipmentModel equipment) {
                        return DropdownMenuItem<EquipmentModel>(
                          value: equipment,
                          child: Text(equipment.name), // แสดงชื่ออุปกรณ์
                        );
                      }).toList(),
                    ),
                  ),
            DropdownButton<String>(
              padding: const EdgeInsets.all(8.0),
              isExpanded: true,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              hint: const Text('กล้ามเนื้อที่ใช้'),
              value: selectedMuscle,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMuscle = newValue;
                });
              },
              items:
                  targetMuscle.map<DropdownMenuItem<String>>((String muscle) {
                return DropdownMenuItem<String>(
                  value: muscle,
                  child: Text(muscle), // แสดงชื่อกล้ามเนื้อแต่ละกลุ่ม
                );
              }).toList(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                if (_description.text.isEmpty ||
                    _namePost.text.isEmpty ||
                    selectedEquipment == null ||
                    selectedMuscle!.isEmpty ||
                    fileImage == null) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    title: "กรุณาใส่ข้อมูลให้ครบ",
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  uploadPosture(fileImage!, _namePost.text, _description.text,
                      selectedEquipment!.eqid, selectedMuscle!);
                }
              },
              child: const Text(
                "เพิ่ม",
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
