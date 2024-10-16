import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:gym_master_fontend/model/equipmentModel.dart';
import 'package:gym_master_fontend/screen/admin_add_equipment_page/admin_add_equipment_page.dart';
import 'package:gym_master_fontend/screen/admin_edit_equipment_page/admin_edit_equipment_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class AdminEquipmentPage extends StatefulWidget {
  const AdminEquipmentPage({super.key, required this.tokenJwt});
  final String tokenJwt;

  @override
  State<AdminEquipmentPage> createState() => _AdminEquipmentPageState();
}

class _AdminEquipmentPageState extends State<AdminEquipmentPage> {
  final searchController = TextEditingController();
  List<EquipmentModel> equipmentList = [];
  List<EquipmentModel> filteredList = [];
  String? tokenJwt;
  String url = AppConstants.BASE_URL;

  @override
  void initState() {
    super.initState();
    tokenJwt = widget.tokenJwt;
    searchController.addListener(() {
      filterList();
    });
    loadEquipment();
  }

  void filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = equipmentList.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.eqid.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void deleteEquipment(int eqid) async {
    final dio = Dio();
    var json = {
      "eqid": eqid,
    };
    try {
      final response = await dio.post("$url/equipment/delete",
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
          loadEquipment();
        });
      } else {
        log("Error code: ${response.statusCode}");
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
          filteredList = equipmentList;
        });
      } else {
        log("Failed to load data");
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
        centerTitle: true,
        title: const Text(
          'อุปกรณ์',
          style: TextStyle(fontFamily: 'Kanit'),
        ),
      ),
      body: equipmentList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาอุปกรณ์...',
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
                      final equipment = filteredList[index];
                      return Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              final update = await Get.to(
                                () => AdminEditEquipmentPage(
                                  tokenJwt: tokenJwt!,
                                  name: equipment.name,
                                  eqid: equipment.eqid,
                                ),
                              );

                              if (update == true) {
                                setState(() {
                                  loadEquipment();
                                });
                                if (mounted) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    title: 'แก้ไขสำเร็จ',
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              }
                            },
                            leading: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                  fontSize: 18.0, fontFamily: "Kanit"),
                            ),
                            title: Text(
                              equipment.name,
                              style: const TextStyle(
                                  fontSize: 18.0, fontFamily: "Kanit"),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    title: 'ยืนยันการลบ',
                                    btnOkOnPress: () {
                                      deleteEquipment(equipment.eqid);
                                    },
                                    btnCancelOnPress: () {},
                                  ).show();
                                },
                                icon: const FaIcon(FontAwesomeIcons.trash)),
                          ),
                          const Divider()
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final update = await Get.to(
            () => AdminAddEquipmentPage(tokenJwt: tokenJwt!),
          );
          if (mounted) {
            if (update == true) {
              setState(() {
                loadEquipment();
              });
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                title: 'เพิ่มอุปกรณ์สำเร็จ',
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
