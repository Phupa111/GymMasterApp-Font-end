import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_master_fontend/model/ProfileModel.dart';
import 'package:gym_master_fontend/screen/login_page.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/profile_page_edit/profile_page_edit.dart';
import 'package:gym_master_fontend/services/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  auth.User? currentUser;
  SharedPreferences? prefs;

  int? uid;
  late Future<void> userProfileData;
  List<ProfileModel> profileData = [];
  String? tokenJWT;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    userProfileData = loadProfile();
    auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((auth.User? updatedUser) {
      setState(() {
        currentUser = updatedUser;
      });
    });
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs?.getInt("uid");
    tokenJWT = prefs?.getString("tokenJwt");
    setState(() {
      userProfileData = loadProfile();
    });
  }

  Future<void> loadProfile() async {
    final dio = Dio();
    const String url = AppConstants.BASE_URL;
    log("uid = $uid");
    var userData = {
      "uid": uid,
    };
    try {
      final response = await dio.post("$url/calculate/getDataUserAndBodyFat",
          data: userData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJWT',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      print(response.data);
      final List<dynamic> profileJson = response.data;
      profileData = profileJson.map((e) => ProfileModel.fromJson(e)).toList();
      // log("datajson list = ${profileJson.length}");
      // log(profileJson.toString());
    } catch (error) {
      // log("fetching data Error : $error 1");
      throw Exception("Failed to load data1S");
    }
  }

  void logOut() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      if (prefs != null) {
        await prefs!.remove('uid');
        await prefs!.remove('role');
        await prefs!.remove('username');
        await prefs!.remove('isDisbel');
        await prefs!.remove('tokenJwt');
      }
      Get.to(const LoginPage());
    } catch (e) {
      // Handle sign-out errors
      log("Error signing out: $e");
    }
  }

  Future<void> _refresh() async {
    setState(() {
      userProfileData = loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: currentUser != null ? false : true,
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder(
            future: userProfileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("snapshot Error: ${snapshot.error}"),
                );
              } else {
                return ListView.builder(
                  itemCount: profileData.length,
                  itemBuilder: (context, index) {
                    final profile = profileData[index];
                    log("is profile pic empty: ${profile.detail[index].profilePic.isEmpty}");
                    return Stack(
                      children: [
                        Container(
                          height: 270,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60.0),
                              bottomRight: Radius.circular(60.0),
                            ),
                            color: Colors.orange,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.15,
                              right: MediaQuery.of(context).size.width * 0.15),
                          child: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(300.0),
                                  child:
                                      profile.detail[index].profilePic.isEmpty
                                          ? const Icon(
                                              Icons.account_circle,
                                              size: 150,
                                              color: Colors.white,
                                            )
                                          : Image.network(
                                              profile.detail[index].profilePic,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            )),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      profile.detail[index].username,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          final updatePage = await Get.to(
                                              () => ProfilePageEdit(uid: uid!));

                                          if (updatePage == "refresh") {
                                            setState(() {
                                              userProfileData = loadProfile();
                                            });
                                          }
                                        },
                                        icon: const FaIcon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Container(
                                  height: 100.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 5),
                                          color:
                                              Color.fromARGB(96, 141, 139, 139),
                                          blurRadius: 5),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              profile.bmr,
                                              style: const TextStyle(
                                                color: Colors.orange,
                                                fontSize: 28,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const Text(
                                              "BMR",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              profile.bmi,
                                              style: const TextStyle(
                                                color: Colors.orange,
                                                fontSize: 28,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const Text(
                                              "BMI",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Kanit',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15.0,
                                ),
                                child: ListTile(
                                  leading: const FaIcon(
                                      FontAwesomeIcons.envelope,
                                      size: 25.0),
                                  title: Text(
                                    profile.detail[index].email,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: const FaIcon(
                                    FontAwesomeIcons.weightScale,
                                    size: 25.0),
                                title: Text(
                                  "${profile.detail[index].weight} กก.",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: const FaIcon(FontAwesomeIcons.person,
                                    size: 25.0),
                                title: Text(
                                  "${profile.detail[index].height} ซม.",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Column(
                                      children: [
                                        FaIcon(FontAwesomeIcons.universalAccess,
                                            size: 25.0),
                                        Text(
                                          "Body Fat",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Container(
                                        width: 80,
                                        decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0))),
                                        child: Center(
                                          child: Text(
                                            "${profile.bodyFat} %",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: logOut,
                                  child: const Text("Log out"))
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
