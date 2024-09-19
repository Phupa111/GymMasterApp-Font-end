import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/services/photo_service.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmImageScreen extends StatefulWidget {
  const ConfirmImageScreen(
      {super.key,
      required this.imagePath,
      required this.uid,
      required this.tokenJwt});
  final XFile imagePath;
  final int uid;
  final String tokenJwt;

  @override
  State<ConfirmImageScreen> createState() => _ConfirmImageScreenState();
}

class _ConfirmImageScreenState extends State<ConfirmImageScreen> {
  late XFile imageFile;
  late int uid;
  late String tokenJwt;
  final _weightCovtroller = TextEditingController();
  late int status;

  @override
  void initState() {
    super.initState();
    imageFile = widget.imagePath;
    uid = widget.uid;
    tokenJwt = widget.tokenJwt;
  }

  Future<void> insertPicture(
      int uid, XFile imagePath, String weight, String tokenJwt) async {
    if (weight.isEmpty) {
      weight = "0";
    }
    status =
        await PhotoService().insertProgress(uid, imagePath, weight, tokenJwt);
    if (status == 1) {
      Get.back(result: 1);
    } else {
      Get.back(result: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "รูปภาพ",
          style: TextStyle(
            fontFamily: 'Kanit',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      child: Image.file(
                        height: 300.0,
                        File(imageFile.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "น้ำหนัก",
                      style: TextStyle(fontFamily: "Kanit"),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _weightCovtroller,
                        decoration: const InputDecoration(
                          hintText: "(ไม่จำเป็นต้องใส่)",
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text(
                              "กก.",
                              style: TextStyle(fontFamily: "Kanit"),
                            ),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.]'),
                          ), // อนุญาตเฉพาะตัวเลขและจุดทศนิยม
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        padding:
                            const EdgeInsets.all(16), // ปรับระยะห่างรอบๆ ไอคอน
                        constraints: const BoxConstraints(
                          minWidth: 60, // ความกว้างขั้นต่ำ
                          minHeight: 60, // ความสูงขั้นต่ำ
                        ),
                        style: IconButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 208, 208, 208)),
                        onPressed: () {
                          Get.back();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.x,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        padding:
                            const EdgeInsets.all(16), // ปรับระยะห่างรอบๆ ไอคอน
                        constraints: const BoxConstraints(
                          minWidth: 60, // ความกว้างขั้นต่ำ
                          minHeight: 60, // ความสูงขั้นต่ำ
                        ),
                        style: IconButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 107, 248, 114)),
                        onPressed: () {
                          insertPicture(uid, imageFile,
                              _weightCovtroller.text.toString(), tokenJwt);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
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
