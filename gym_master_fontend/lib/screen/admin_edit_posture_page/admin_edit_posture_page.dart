import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/equipmentModel.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dioins;

class AdminEditPosturePage extends StatefulWidget {
  const AdminEditPosturePage(
      {super.key,
      required this.gif,
      required this.name,
      required this.des,
      required this.equipment,
      required this.muscle,
      required this.eid,
      required this.tokenJwt});
  final int eid;
  final String gif;
  final String name;
  final String des;
  final String equipment;
  final String muscle;
  final String tokenJwt;

  @override
  State<AdminEditPosturePage> createState() => _AdminEditPosturePageState();
}

class _AdminEditPosturePageState extends State<AdminEditPosturePage> {
  String? selectedEquipment;
  String? selectedMuscle;
  String? tokenJwt;

  int? nameLength;
  int? desLength;
  String? equipCheck;
  String? muscleCheck;

  final _nameController = TextEditingController();
  final _desController = TextEditingController();
  List<EquipmentModel> equipmentList = [];

  final ImagePicker _picker = ImagePicker();
  XFile? fileImage;

  String url = AppConstants.BASE_URL;

  List<String> muscleOptions = [
    'Chest',
    'Abs',
    'Leg',
    'Back',
    'Trapezius',
    'Shoulders',
    'Neck',
    'Arms'
  ];

  String _getMuscleFromNumber(String muscleNumber) {
    switch (muscleNumber) {
      case '1':
        return 'Chest';
      case '2':
        return 'Abs';
      case '3':
        return 'Leg';
      case '4':
        return 'Back';
      case '5':
        return 'Trapezius';
      case '6':
        return 'Shoulders';
      case '7':
        return 'Neck';
      case '8':
        return 'Arms';
      default:
        return 'Unknown'; // Default case if number doesn't match
    }
  }

  pickWithGallery() async {
    fileImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      log(fileImage!.path);
    });
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
        log("Failed to load data");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  int? findEquipmentId(
      String? selectedEquipment, List<EquipmentModel> equipmentList) {
    // ตรวจสอบว่ามี selectedEquipment หรือไม่ และ equipmentList ไม่ว่าง
    if (selectedEquipment == null || equipmentList.isEmpty) {
      return null;
    }

    try {
      // ใช้ firstWhere เพื่อหา equipment ที่มี name ตรงกับ selectedEquipment
      EquipmentModel matchingEquipment = equipmentList.firstWhere(
        (equipment) => equipment.name == selectedEquipment,
        orElse: () => EquipmentModel(
            eqid: 0, name: ''), // ถ้าไม่เจอจะ return อันที่ไม่มีค่า
      );

      // ถ้าพบชื่ออุปกรณ์ ให้ return eqid
      return matchingEquipment.eqid != 0 ? matchingEquipment.eqid : null;
    } catch (e) {
      // ถ้ามีข้อผิดพลาด ให้ return null
      return null;
    }
  }

  void editPosture(XFile? gif, String name, String des, int equipId,
      String muscle, int eid) async {
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
      dioins.FormData formData = dioins.FormData.fromMap({
        "eid": eid,
        "name": name,
        "des": des,
        "equipId": equipId,
        "muscle": mid,
      });

      if (gif != null) {
        final fileGif = File(gif.path);
        formData.files.add(MapEntry(
          "file",
          await dioins.MultipartFile.fromFile(
            fileGif.path,
            filename: fileGif.path.split('/').last,
            contentType: MediaType("image", "gif"),
          ),
        ));
      }

      final response = await dio.post('$url/exPost/edit',
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

  @override
  void initState() {
    super.initState();
    selectedEquipment = widget.equipment;
    selectedMuscle = _getMuscleFromNumber(widget.muscle);
    tokenJwt = widget.tokenJwt;

    _nameController.text = widget.name;
    _desController.text = widget.des;

    nameLength = widget.name.length;
    desLength = widget.des.length;

    equipCheck = widget.equipment;
    muscleCheck = _getMuscleFromNumber(widget.muscle);
    loadEquipment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขท่า'),
      ),
      body: SingleChildScrollView(
        child: equipmentList.isEmpty
            ? const Center(
                child: CircularProgressIndicator()) // Show loading spinner
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    fileImage != null && fileImage!.path.isNotEmpty
                        ? Image.file(
                            File(fileImage!.path),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.gif,
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange),
                      onPressed: pickWithGallery,
                      child: const Text(
                        "เปลี่ยนรูป",
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TextFormField for Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อ',
                        labelStyle: TextStyle(
                          fontFamily: 'Kanit',
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TextFormField for Description
                    TextFormField(
                      controller: _desController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'คำอธิบาย',
                        labelStyle: TextStyle(
                          fontFamily: 'Kanit',
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // DropdownButton for Equipment
                    DropdownButtonFormField<String>(
                      value: selectedEquipment,
                      decoration: const InputDecoration(
                        labelText: 'Equipment',
                        labelStyle: TextStyle(
                          fontFamily: 'Kanit',
                        ),
                        border: OutlineInputBorder(),
                      ),
                      items: equipmentList
                          .map<DropdownMenuItem<String>>(
                              (EquipmentModel equipment) =>
                                  DropdownMenuItem<String>(
                                    value: equipment.name,
                                    child: Text(equipment.name),
                                  ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedEquipment = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // DropdownButton for Muscle Group
                    DropdownButtonFormField<String>(
                      value: selectedMuscle,
                      decoration: const InputDecoration(
                        labelText: 'กล้ามเนื้อ',
                        labelStyle: TextStyle(
                          fontFamily: 'Kanit',
                        ),
                        border: OutlineInputBorder(),
                      ),
                      items: muscleOptions
                          .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMuscle = newValue;
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange),
                      onPressed: () {
                        if (nameLength == _nameController.text.length &&
                            desLength == _desController.text.length &&
                            equipCheck == selectedEquipment &&
                            muscleCheck == selectedMuscle &&
                            fileImage == null) {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  title: 'ไม่มีการเปลี่ยนเแปลงข้อมูล',
                                  btnOkOnPress: () {})
                              .show();
                        } else {
                          final equipid =
                              findEquipmentId(selectedEquipment, equipmentList);
                          editPosture(
                              fileImage,
                              _nameController.text,
                              _desController.text,
                              equipid!,
                              selectedMuscle!,
                              widget.eid);
                        }
                      },
                      child: const Text(
                        "ยืนยันการแก้ไข",
                        style: TextStyle(
                            fontFamily: 'Kanit',
                            color: Colors.white,
                            fontSize: 18.0),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
