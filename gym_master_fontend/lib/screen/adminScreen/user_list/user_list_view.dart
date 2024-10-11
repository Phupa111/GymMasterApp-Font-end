import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/model/UsersModels.dart';
import 'package:gym_master_fontend/screen/admin_edit_page/admin_edit_page.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UesrListViewPage extends StatefulWidget {
  final bool isEnnabelUser;
  const UesrListViewPage({super.key, required this.isEnnabelUser});

  @override
  State<UesrListViewPage> createState() => _UesrListViewPageState();
}

class _UesrListViewPageState extends State<UesrListViewPage> {
  String url = AppConstants.BASE_URL;
  List<UsersModels> enanbelingUser = [];

  late Future<void> loadData;
  late SharedPreferences prefs;
  late String tokenJWT;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = Future.value(); // Initialize with an empty future
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    tokenJWT = prefs.getString("tokenJwt")!;

    setState(() {
      loadData = loadDataAsync();
    });
  }

  void deleteUser(int uid) async {
    final dio = Dio();
    var json = {
      "uid": uid,
    };
    try {
      final response = await dio.post('$url/admin/delete',
          data: json,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJWT',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));

      if (response.statusCode == 200) {
        setState(() {
          loadData = loadDataAsync();
        });
      } else {
        log("error status Code delete user: ${response.statusCode}");
      }
    } catch (e) {
      log("Error to delete user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SearchBar(
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 12.0)),
                        controller: searchController,
                        onTap: () {},
                        onChanged: (value) {
                          if (searchController.text.isEmpty) {
                            setState(() {});
                          }
                        },
                        onSubmitted: (value) {
                          log(value);
                          setState(() {
                            loadData = loadDataAsync();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: enanbelingUser.isNotEmpty
                      ? ListView.builder(
                          itemCount: enanbelingUser.length,
                          itemBuilder: (context, index) {
                            final user = enanbelingUser[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 8,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 12.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        user.username,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          widget.isEnnabelUser
                                              ? ElevatedButton.icon(
                                                  onPressed: () {
                                                    disbelUser(user.uid, 1);
                                                  },
                                                  icon: const Icon(
                                                    Icons.block,
                                                    size:
                                                        18, // Adjust icon size
                                                  ),
                                                  label: const Text(
                                                    "Disbel",
                                                    style: TextStyle(
                                                        fontSize:
                                                            14), // Adjust text size
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    minimumSize: const Size(100,
                                                        40), // Set minimum button size (width, height)
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12.0,
                                                        horizontal:
                                                            16.0), // Adjust padding
                                                  ),
                                                )
                                              : ElevatedButton.icon(
                                                  onPressed: () {
                                                    disbelUser(user.uid, 0);
                                                  },
                                                  icon: const Icon(
                                                    Icons.person,
                                                    size:
                                                        18, // Adjust icon size
                                                  ),
                                                  label: const Text(
                                                    "Enabel",
                                                    style: TextStyle(
                                                        fontSize:
                                                            14), // Adjust text size
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    minimumSize: const Size(100,
                                                        40), // Set minimum button size (width, height)
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12.0,
                                                        horizontal:
                                                            16.0), // Adjust padding
                                                  ),
                                                ),
                                          const SizedBox(width: 8),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              // Handle Edit action
                                              Get.to(() => AdminEditPage(
                                                    uid: user.uid,
                                                    tokenJwt: tokenJWT,
                                                  ));
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18, // Adjust icon size
                                            ),
                                            label: const Text(
                                              "แก้ไข",
                                              style: TextStyle(
                                                  fontSize:
                                                      14), // Adjust text size
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(100,
                                                  40), // Set minimum button size (width, height)
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 12.0,
                                                  horizontal:
                                                      16.0), // Adjust padding
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                title: "ยืนยันการลบผู้ใช้",
                                                btnOkOnPress: () {
                                                  deleteUser(user.uid);
                                                },
                                              ).show();
                                            },
                                            icon: const FaIcon(
                                              FontAwesomeIcons.trash,
                                              color: Colors.red,
                                            ),
                                            label: const Text(
                                              "ลบ",
                                              style: TextStyle(
                                                fontFamily: 'Kanit',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("No users found")),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void disbelUser(int uid, int isDisbel) async {
    final dio = Dio();
    log(uid.toString());
    var regBody = {"isDisbel": isDisbel, "uid": uid};

    try {
      final String endpoint = '$url/user/disableUser';
      final response = await dio.post(
        endpoint,
        data: regBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenJWT',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          loadData = loadDataAsync();
        });
      } else {
        log('Failed to disable user: ${response.statusCode}');
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();

    try {
      if (widget.isEnnabelUser) {
        final String endpoint =
            '$url/user/getAllUsers?isDisble=0&search=${searchController.text}';

        final response = await dio.get(
          endpoint,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJWT',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ),
        );

        final List<dynamic> jsonData = response.data as List<dynamic>;
        enanbelingUser =
            jsonData.map((item) => UsersModels.fromJson(item)).toList();
      } else {
        final String endpoint =
            '$url/user/getAllUsers?isDisble=1&search=${searchController.text}';

        final response = await dio.get(
          endpoint,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJWT',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ),
        );

        final List<dynamic> jsonData = response.data as List<dynamic>;
        enanbelingUser =
            jsonData.map((item) => UsersModels.fromJson(item)).toList();
      }
    } catch (e) {
      // Handle error
    }
  }
}
