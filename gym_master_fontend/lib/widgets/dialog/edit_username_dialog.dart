import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class EditUsernameDialog extends StatefulWidget {
  const EditUsernameDialog({super.key, required this.uid});
  final int uid;
  @override
  State<EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<EditUsernameDialog> {
  final _usernameController = TextEditingController();
  final _fromkey = GlobalKey<FormState>();
  late int uid;
  int usernamecheckStatus = 0;

  void checkUsername(String username, int uid) async {
    final dioInstance = Dio();
    final dateNow = DateTime.now();
    const String url = AppConstants.BASE_URL;
    // log("${dateNow.toString().split(" ")[0]}_$uid");
    try {
      var response =
          await dioInstance.get('http://$url/user/selectFromEmail/$username');
      if (response.data.isEmpty) {
        var json = {
          "uid": uid,
          "username": username,
        };
        final responseChangeUsername = await dioInstance.post(
          "http://$url/user/update/username",
          data: json,
        );
        log(responseChangeUsername.data.toString());

        Get.back(result: username);
      } else {
        if (response.data.isNotEmpty) {
          // ignore: use_build_context_synchronously
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: "ชื่อผู้ใช้ซ้ำ",
            btnOkOnPress: () {},
          ).show();
          log("has data$usernamecheckStatus");
        }
      }
    } catch (e) {
      log("Error: $e");
      // Handle Dio exceptions or network errors here
      // Show a snackbar or toast message indicating network error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fromkey,
      child: Dialog(
        child: SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      "เปลี่ยนชื่อผู้ใช้",
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Kanit'),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _usernameController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาใส่ชื่อผู้ใช้";
                    } else if (value.length < 6) {
                      return 'ชื่อผู้ใช้ต้องมีมากกว่า 6 ตัวอักษร';
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
                            if (_fromkey.currentState?.validate() ?? false) {
                              checkUsername(_usernameController.text, uid);
                            }
                          },
                          child: const Text(
                            "ตกลง",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.bold),
                          )),
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
