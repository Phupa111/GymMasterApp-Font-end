import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/tdee_page/sub_page/bulking_tab_page.dart';
import 'package:gym_master_fontend/screen/tdee_page/sub_page/cutting_tab_page.dart';
import 'package:gym_master_fontend/screen/tdee_page/sub_page/maintain_tab_page.dart';
import 'package:gym_master_fontend/style/font_style.dart';

class TdeePage extends StatelessWidget {
  TdeePage({super.key});
  final tdeeTabs = <Tab>[
    const Tab(text: "Cutting"),
    const Tab(text: "Main"),
    const Tab(text: 'Bluking')
  ];

  final tdeeTabsPage = <Widget>[
    const CuttingTabPage(),
    const MaintainTabPage(),
    const BulkingTabPage()
  ];
  @override
  void initState() {}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tdeeTabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: const Color(0xFFFFAC41),
          title: const Text(
            "TDEE",
            style: TextStyle(fontFamily: "Kanit", color: Colors.white),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4.0,
            indicatorColor: Color.fromARGB(255, 164, 79, 233),
            tabs: tdeeTabs,
          ),
          centerTitle: true,
        ),
        body: TabBarView(children: tdeeTabsPage),
      ),
    );
  }
}
