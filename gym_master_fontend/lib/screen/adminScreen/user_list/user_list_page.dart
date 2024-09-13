import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/adminScreen/user_list/user_list_view.dart';

class UaserListPage extends StatefulWidget {
  const UaserListPage({super.key});

  @override
  State<UaserListPage> createState() => _UaserListPageState();
}

class _UaserListPageState extends State<UaserListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('ผู้ใช้'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "เปิดใช้งาน"),
            Tab(text: "ปิดใช้งาน"),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: true);
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          UesrListViewPage(
            isEnnabelUser: true,
          ),
          UesrListViewPage(
            isEnnabelUser: false,
          )
        ],
      ),
    );
  }
}
