import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/services/user/edit_service.dart';

class EditPasswordDialog extends StatefulWidget {
  const EditPasswordDialog({super.key, required this.uid});
  final int uid;

  @override
  State<EditPasswordDialog> createState() => _EditPasswordDialogState();
}

class _EditPasswordDialogState extends State<EditPasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late int uid;
  late int status = 0;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
  }

  void checkAndUpdatePassword(int uid, String password) async {
    try {
      status = await EditService().updatePassword(uid, password);
      log("status : $status");
      if (status == 1) {
        Get.back(result: 1);
      } else {
        Get.back(result: 0);
      }
    } catch (e) {
      log('Failed to update password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Dialog(
        child: SizedBox(
          height: 300,
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      "เปลี่ยนรหัสผ่าน",
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Kanit'),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "รหัสผ่าน"),
                  controller: _passwordController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณารหัสผ่าน";
                    }
                    if (RegExp(r'[ก-๙]').hasMatch(value)) {
                      return 'ชื่อผู้ใช้ห้ามมีตัวอักษรภาษาไทย';
                    }
                    if (value.length < 6) {
                      return "รหัสผ่านต้องยาวมากกว่า 6 ตัว";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "ยืนยันรหัสผ่าน"),
                  controller: _confirmPasswordController,
                  maxLines: 1,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณายืนยันรหัสผ่าน";
                    }
                    if (value != _passwordController.text) {
                      return "รหัสผ่านไม่ตรงกัน";
                    }
                    return null;
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
                          if (_formkey.currentState!.validate()) {
                            checkAndUpdatePassword(
                                uid, _passwordController.text);
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
