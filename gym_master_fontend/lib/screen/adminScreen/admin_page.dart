import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            )
          ],
        ),
      ),
    );
  }
}
