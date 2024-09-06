import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gym_master_fontend/screen/Tabel/course_view_page.dart';
import 'package:gym_master_fontend/screen/Tabel/createTabel_page.dart';

import 'package:gym_master_fontend/services/app_const.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserTabelPage extends StatefulWidget {
  final bool isAdminCouser;
  const UserTabelPage({super.key, required this.isAdminCouser});

  @override
  State<UserTabelPage> createState() => _UserTabelPageState();
}

class _UserTabelPageState extends State<UserTabelPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late SharedPreferences prefs;
  int? uid;
  int? role;
  late String tokenJWT;
  String url = AppConstants.BASE_URL;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getInt("uid");
    role = prefs.getInt("role");
    tokenJWT = prefs.getString("tokenJwt")!;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdminCouser ? "คอร์สออกกำลังกาย" : "ตารางของฉัน"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "ไม่ได้ใช้งาน"),
            Tab(text: "กำลังใช้งาน"),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: true);
          },
        ),
      ),
      body: uid == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                CourseView(
                  uid: uid!,
                  isAdminCouser: widget.isAdminCouser,
                  isEnnabel: false,
                  tokenJWT: tokenJWT,
                ),
                CourseView(
                    uid: uid!,
                    isAdminCouser: widget.isAdminCouser,
                    isEnnabel: true,
                    tokenJWT: tokenJWT),
              ],
            ),
    );
  }
}
