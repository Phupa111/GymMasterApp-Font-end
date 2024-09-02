import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/services/user/edit_service.dart';

class EditHeightDialog extends StatefulWidget {
  const EditHeightDialog({super.key, required this.uid});
  final int uid;

  @override
  State<EditHeightDialog> createState() => _EditHeightDialogState();
}

class _EditHeightDialogState extends State<EditHeightDialog> {
  final _heightController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  late int uid;
  late int status = 0;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
  }

  void updateHeight(int uid, int height) async {
    try {
      status = await EditService().updateHeight(uid, height);
      log("status : $status");
      if (status == 1) {
        Get.back(result: height);
      } else {
        Get.back(result: 0);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            height: 180.0,
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      "ส่วนสูง",
                      style: TextStyle(fontFamily: 'Kanit', fontSize: 24.0),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "ซม.",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Kanit',
                              color: Color.fromARGB(255, 72, 54, 31)),
                        ),
                      ),
                    ),
                    readOnly: true,
                    controller: _heightController,
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => SizedBox(
                          height: 250,
                          child: CupertinoPicker(
                            backgroundColor: Colors.white,
                            itemExtent: 30,
                            scrollController: FixedExtentScrollController(
                                initialItem:
                                    20), // ตั้งค่าค่าเริ่มต้นเป็น 120 เพื่อแสดงค่าส่วนสูงที่ 120 (เช่น 120 ซม)
                            onSelectedItemChanged: (value) {
                              setState(() {
                                _heightController.text =
                                    (value + 100).toString();
                              });
                            },
                            children: List.generate(
                              151, // จำนวนไอเทมที่ต้องการแสดง (0-150)
                              (index) => Center(
                                  child: Text(
                                      '${index + 100} ซม.')), // เริ่มต้นที่ 100 เพื่อแสดงช่วง 100-250 ซม
                            ),
                          ),
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณาใส่ส่วนสูง";
                      }
                      return null;
                    },
                  ),
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
                          if (_formkey.currentState!.validate()) {
                            updateHeight(
                                uid, int.parse(_heightController.text));
                          }
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
      ),
    );
  }
}
