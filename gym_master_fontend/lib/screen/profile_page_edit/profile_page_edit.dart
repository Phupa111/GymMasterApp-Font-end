// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http_parser/http_parser.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/UserProfileEditModel.dart';
import 'package:gym_master_fontend/services/user/edit_service.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:gym_master_fontend/widgets/dialog/edit_height_dialog.dart';
import 'package:gym_master_fontend/widgets/dialog/edit_password_dialog.dart';
import 'package:gym_master_fontend/widgets/dialog/edit_username_dialog.dart';
import 'package:gym_master_fontend/widgets/dialog/edit_weight_dialog.dart';
import 'package:gym_master_fontend/widgets/select_gender_radio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageEdit extends StatefulWidget {
  const ProfilePageEdit({super.key, required this.uid, required this.role});
  final int uid;
  final int role;
  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  final List<int> _gender = [1, 2];
  late int currentGender;
  final String url = AppConstants.BASE_URL;

  late int usernamecheckStatus = 0;
  late int uid;
  SharedPreferences? prefs;
  late String? tokenJWT;

  late Future<List<UserProfileEditModel>> profileAsync;
  //imagePicker
  final ImagePicker _picker = ImagePicker();
  XFile? fileImage;

  pickWithGallery() async {
    fileImage = await _picker.pickImage(source: ImageSource.gallery);
    updateProfilePic();
    setState(() {
      log(fileImage!.path);
    });
    Get.back();
  }

  pickWithCamera() async {
    fileImage = await _picker.pickImage(source: ImageSource.camera);
    updateProfilePic();
    setState(() {
      if (fileImage != null) {
        log(fileImage!.path);
      }
    });
    Get.back();
  }

  void updateProfilePic() async {
    final dioInstance = dio.Dio();
    final dateNow = DateTime.now();
    log("${dateNow.toString().split(" ")[0]}_$uid");
    try {
      dio.FormData formData = dio.FormData.fromMap({
        "uid": "$uid",
        "file": await dio.MultipartFile.fromFile(
          fileImage!.path,
          filename: dateNow.toString().split(" ")[0] + uid.toString(),
          contentType: MediaType(
            "image",
            "jpg",
          ),
        )
      });

      final response = await dioInstance.post("$url/photo/uploadImage",
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJWT',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      log(response.data.toString());
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

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    tokenJWT = prefs!.getString("tokenJwt");
  }

  void updatePictureProfile(XFile image) async {
    String filePath = image.path;
    String fileName = "$uid";
  }

  @override
  void initState() {
    uid = widget.uid;
    _initializePreferences();
    super.initState();
    currentGender = _gender[0];
    profileAsync = EditService().getProfileEdit(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(result: "refresh");
          },
          icon: const FaIcon(
            FontAwesomeIcons.angleLeft,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        title: const Text(
          "แก้ไขโปรไฟล์",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<UserProfileEditModel>>(
        future: profileAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("snapshot error ${snapshot.error.toString()}"),
            );
          } else {
            final userData = snapshot.data!;
            return ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(300.0),
                          child: fileImage != null && fileImage!.path.isNotEmpty
                              ? Image.file(
                                  File(fileImage!.path),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : userData[index].profilePic.isNotEmpty
                                  ? Image.network(
                                      userData[index].profilePic,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.account_circle,
                                      size: 150,
                                      color: Colors.orange,
                                    ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _pickImage(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        child: const Text(
                          "เปลี่ยนรูป",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.role == 1,
                        child: ListTile(
                          leading: const FaIcon(FontAwesomeIcons.venusMars),
                          onTap: () async {
                            final updategender = await showDialog(
                                context: context,
                                builder: (context) => SelectGenderRadio(
                                      uid: uid,
                                      gender: userData[index].gender,
                                      tokenJWT: tokenJWT!,
                                    ));

                            if (updategender != null) {
                              setState(() {
                                userData[index].gender = updategender;
                              });
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: "แก้ไขสำเร็จ",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          title: const Text(
                            "เพศ",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          trailing: userData[index].gender == 1
                              ? const Text(
                                  "ชาย",
                                  style: TextStyle(
                                      fontSize: 18.0, fontFamily: 'Kanit'),
                                )
                              : const Text(
                                  "หญิง",
                                  style: TextStyle(
                                      fontSize: 18.0, fontFamily: 'Kanit'),
                                ),
                        ),
                      ),
                      lineDivider(),
                      ListTile(
                        title: const Text(
                          "ชื่อผู้ใช้",
                          style: TextStyle(fontSize: 14.0, fontFamily: 'Kanit'),
                        ),
                        leading: const FaIcon(Icons.person),
                        onTap: () async {
                          final updateUser =
                              await Get.dialog(EditUsernameDialog(
                            uid: uid,
                            tokenJWT: tokenJWT!,
                          ));

                          if (updateUser != null) {
                            setState(() {
                              userData[index].username = updateUser;
                            });
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              title: "แก้ไขสำเร็จ",
                              btnOkOnPress: () {},
                            ).show();
                          }
                        },
                        trailing: Text(
                          userData[index].username,
                          style: const TextStyle(
                              fontSize: 18.0, fontFamily: 'Kanit'),
                        ),
                      ),
                      lineDivider(),
                      ListTile(
                        title: const Text(
                          "รหัสผ่าน",
                          style: TextStyle(fontSize: 14.0, fontFamily: 'Kanit'),
                        ),
                        leading: const FaIcon(Icons.key),
                        onTap: () async {
                          final updatePassword =
                              await Get.dialog(EditPasswordDialog(
                            uid: uid,
                            tokenJWT: tokenJWT!,
                          ));

                          if (updatePassword != null) {
                            if (updatePassword == 1) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: "รหัสผ่านซ้ำ",
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              if (widget.role == 3) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool("isMustChangPass",
                                    false); // Correct way to use SharedPreferences
                              }

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: "แก้ไขสำเร็จ",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          }
                        },
                      ),
                      Visibility(
                          visible: widget.role == 1, child: lineDivider()),
                      Visibility(
                        visible: widget.role == 1,
                        child: ListTile(
                          title: const Text(
                            "ส่วนสูง (ซม.)",
                            style:
                                TextStyle(fontSize: 14.0, fontFamily: 'Kanit'),
                          ),
                          leading: const FaIcon(Icons.accessibility),
                          onTap: () async {
                            final updateHeight =
                                await Get.dialog(EditHeightDialog(
                              uid: uid,
                              tokenJWT: tokenJWT!,
                            ));
                            if (updateHeight != null) {
                              if (updateHeight != 0) {
                                setState(() {
                                  userData[index].height = updateHeight;
                                });
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  title: "แก้ไขสำเร็จ",
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            }
                          },
                          trailing: Text(
                            userData[index].height.toString(),
                            style: const TextStyle(
                                fontSize: 18.0, fontFamily: 'Kanit'),
                          ),
                        ),
                      ),
                      lineDivider(),
                      Visibility(
                        visible: widget.role == 1,
                        child: ListTile(
                          title: const Text(
                            "น้ำหนัก (กก.)",
                            style:
                                TextStyle(fontSize: 14.0, fontFamily: 'Kanit'),
                          ),
                          leading: const FaIcon(Icons.scale),
                          onTap: () async {
                            final updateWeight = await Get.dialog(
                              EditWeightDialog(
                                uid: uid,
                                tokenJWT: tokenJWT!,
                              ),
                            );

                            if (updateWeight != null) {
                              setState(() {
                                userData[index].weight =
                                    updateWeight.toString();
                              });
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: "แก้ไขสำเร็จ",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          trailing: Text(
                            userData[index].weight,
                            style: const TextStyle(
                                fontSize: 18.0, fontFamily: 'Kanit'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget lineDivider() {
    return const Divider(
      thickness: 1.5,
    );
  }

  Widget _pickImage() {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 254, 252),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 40,
              onPressed: pickWithCamera,
              icon: const FaIcon(
                FontAwesomeIcons.camera,
                color: Colors.orange,
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              iconSize: 40,
              onPressed: pickWithGallery,
              icon: const FaIcon(
                FontAwesomeIcons.images,
                color: Colors.orange,
              ),
            )
          ],
        )),
      ),
    );
  }
}
