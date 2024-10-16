import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/UserProfileEditModel.dart';
import 'package:gym_master_fontend/services/user/edit_service.dart';
import 'package:gym_master_fontend/widgets/dialog/edit_height_dialog.dart';
import 'package:gym_master_fontend/widgets/dialog/edit_password_dialog.dart';
import 'package:gym_master_fontend/widgets/dialog/edit_username_dialog.dart';
import 'package:gym_master_fontend/widgets/dialog/edit_weight_dialog.dart';
import 'package:gym_master_fontend/widgets/select_gender_radio.dart';

class AdminEditPage extends StatefulWidget {
  const AdminEditPage({super.key, required this.uid, required this.tokenJwt});
  final int uid;
  final String tokenJwt;

  @override
  State<AdminEditPage> createState() => _AdminEditPageState();
}

class _AdminEditPageState extends State<AdminEditPage> {
  late int uid;
  late String tokenJwt;
  late Future<List<UserProfileEditModel>> profileAsync;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    tokenJwt = widget.tokenJwt;
    profileAsync = EditService().getProfileEdit(uid, tokenJwt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          uid.toString(),
          style: const TextStyle(fontFamily: 'Kanit', fontSize: 20.0),
        ),
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
                    children: [
                      ListTile(
                        leading: const FaIcon(FontAwesomeIcons.userLarge),
                        title: const Text(
                          "ชื่อผู้ใช้: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onTap: () async {
                          final updateUser =
                              await Get.dialog(EditUsernameDialog(
                            uid: uid,
                            tokenJWT: tokenJwt,
                          ));

                          if (updateUser != null) {
                            setState(() {
                              userData[index].username = updateUser;
                            });
                            if (mounted) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: "แก้ไขสำเร็จ",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          }
                        },
                        trailing: Text(userData[index].username,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Kanit',
                            )),
                      ),
                      const Divider(
                        thickness: 2.0,
                      ),
                      ListTile(
                        leading: const FaIcon(FontAwesomeIcons.venusMars),
                        onTap: () async {
                          final updategender = await showDialog(
                              context: context,
                              builder: (context) => SelectGenderRadio(
                                    uid: uid,
                                    gender: userData[index].gender,
                                    tokenJWT: tokenJwt,
                                  ));

                          if (updategender != null) {
                            setState(() {
                              userData[index].gender = updategender;
                            });
                            if (mounted) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: "แก้ไขสำเร็จ",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          }
                        },
                        title: const Text(
                          "เพศ",
                          style: TextStyle(
                            fontSize: 18,
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
                      const Divider(
                        thickness: 2.0,
                      ),
                      ListTile(
                        title: const Text(
                          "รหัสผ่าน",
                          style: TextStyle(fontSize: 18.0, fontFamily: 'Kanit'),
                        ),
                        leading: const FaIcon(Icons.key),
                        onTap: () async {
                          final updatePassword =
                              await Get.dialog(EditPasswordDialog(
                            uid: uid,
                            tokenJWT: tokenJwt,
                          ));

                          if (updatePassword != null) {
                            if (updatePassword == 1) {
                              // ignore: use_build_context_synchronously
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: "รหัสผ่านซ้ำ",
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              // ignore: use_build_context_synchronously
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
                      const Divider(
                        thickness: 2.0,
                      ),
                      ListTile(
                        title: const Text(
                          "ส่วนสูง (ซม.)",
                          style: TextStyle(fontSize: 18.0, fontFamily: 'Kanit'),
                        ),
                        leading: const FaIcon(Icons.accessibility),
                        onTap: () async {
                          final updateHeight =
                              await Get.dialog(EditHeightDialog(
                            uid: uid,
                            tokenJWT: tokenJwt,
                          ));
                          if (updateHeight != null) {
                            if (updateHeight != 0) {
                              setState(() {
                                userData[index].height = updateHeight;
                              });
                              // ignore: use_build_context_synchronously
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
                      const Divider(
                        thickness: 2.0,
                      ),
                      ListTile(
                        title: const Text(
                          "น้ำหนัก (กก.)",
                          style: TextStyle(fontSize: 14.0, fontFamily: 'Kanit'),
                        ),
                        leading: const FaIcon(Icons.scale),
                        onTap: () async {
                          final updateWeight = await Get.dialog(
                            EditWeightDialog(
                              uid: uid,
                              tokenJWT: tokenJwt,
                            ),
                          );

                          if (updateWeight != null) {
                            setState(() {
                              userData[index].weight = updateWeight.toString();
                            });
                            // ignore: use_build_context_synchronously
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
}
