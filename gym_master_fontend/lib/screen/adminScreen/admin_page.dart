import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/Tabel/course_view_page.dart';
import 'package:gym_master_fontend/screen/Tabel/userTabel_page.dart';
import 'package:gym_master_fontend/screen/adminScreen/admin_add_page.dart';
import 'package:gym_master_fontend/screen/adminScreen/user_list/user_list_page.dart';
import 'package:gym_master_fontend/screen/profile_page_edit/profile_page_edit.dart';

import 'package:gym_master_fontend/widgets/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();

    _initializePreferences();
  }

  late SharedPreferences prefs;
  int? uid;
  int? role;
  late String tokenJWT;

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt("uid");
    role = prefs.getInt("role");
    tokenJWT = prefs.getString("tokenJwt")!;
    bool isMustChang = prefs.getBool("isMustChangPass")!;
    setState(() {
      if (isMustChang) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          title: "กรุณาเปลี่ยนรหัสผ่าน",
          btnOkOnPress: () async {
            Get.to(ProfilePageEdit(
              uid: uid!,
              role: role!,
              tokenJwt: tokenJWT,
            ));
          },
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adminpage"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: CardWidget(
                name: "ดูผู้ใช้",
                image:
                    "https://account.bangkoklife.com/BlaAccountRegister/img/icon-03.png",
                button: ElevatedButton(
                  onPressed: () {
                    Get.to(const UaserListPage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFAC41),
                  ),
                  child: const Text(
                    "ดูเพิ่มเติม",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: CardWidget(
                name: "คอร์สออกกำลังกาย",
                image:
                    "https://swequity.vn/wp-content/uploads/2019/07/tap-gym-yeu-sinh-ly.jpg",
                button: ElevatedButton(
                  onPressed: () {
                    Get.to(CourseView(
                      uid: uid!,
                      isAdminCouser: true,
                      isEnnabel: false,
                      tokenJWT: tokenJWT,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFAC41),
                  ),
                  child: const Text(
                    "ดูเพิ่มเติม",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: role == 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: CardWidget(
                  name: "เพิ่ม Admin",
                  image:
                      "https://cdn-icons-png.flaticon.com/512/2304/2304226.png",
                  button: ElevatedButton(
                    onPressed: () {
                      Get.to(const AddAdminPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAC41),
                    ),
                    child: const Text(
                      "ดูเพิ่มเติม",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.dumbbell,
                            color: Colors.white,
                          ),
                          const Text(
                            "เพิ่มอุปกรณ์",
                            style: TextStyle(
                                fontFamily: 'Kanit',
                                color: Colors.white,
                                fontSize: 18.0),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "เพิ่ม",
                              style: TextStyle(fontFamily: 'Kanit'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.person,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          const Text(
                            "เพิ่มท่าออกกำลังกาย",
                            style: TextStyle(
                                fontFamily: 'Kanit',
                                color: Colors.white,
                                fontSize: 18.0),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "เพิ่ม",
                              style: TextStyle(fontFamily: 'Kanit'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
