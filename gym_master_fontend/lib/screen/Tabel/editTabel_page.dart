import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/ExPostModel.dart';
import 'package:gym_master_fontend/screen/Tabel/exercises_page.dart';

class EditTabelPage extends StatefulWidget {
  final int tabelID;
  final String tabelName;
  final int dayPerWeek;

  const EditTabelPage({
    super.key,
    required this.tabelID,
    required this.tabelName,
    required this.dayPerWeek,
  });

  @override
  State<EditTabelPage> createState() => _EditTabelPageState();
}

class _EditTabelPageState extends State<EditTabelPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<List<ExPostModel>> exPosts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.dayPerWeek, vsync: this);
    fetchExercisesForAllDays();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchExercisesForAllDays() async {
    final dio = Dio();
    for (int day = 1; day <= widget.dayPerWeek; day++) {
      try {
        final response = await dio.post(
          'http://192.168.1.101:8080/tabel/getExercisesInTabel',
          data: {'tid': widget.tabelID, 'dayNum': day},
        );
        final jsonData = response.data as List<dynamic>;
        exPosts.add(jsonData.map((item) => ExPostModel.fromJson(item)).toList());
      } catch (e) {
        print('Error fetching exercises for day $day: $e');
        exPosts.add([]); // Add an empty list in case of error
      }
    }
    setState(() {});
  }

  List<Widget> _generateTabs() {
    return List<Widget>.generate(widget.dayPerWeek, (index) {
      return Tab(text: 'Day ${index + 1}');
    });
  }

  List<Widget> _generateTabViews() {
    return List<Widget>.generate(widget.dayPerWeek, (index) {
      final dayExercises = exPosts.length > index ? exPosts[index] : [];
      return ListView.builder(
        itemCount: dayExercises.length,
        itemBuilder: (context, i) {
          final exPost = dayExercises[i];
          return Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    height: 150,
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFFFAC41)),
      borderRadius: const BorderRadius.all(Radius.circular(30)),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              exPost.gifImage ,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(exPost.name),
              Text(exPost.description),
            ],
          ),
        ),
      ],
    ),
  ),
);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tabelName),
        bottom: TabBar(
          controller: _tabController,
          tabs: _generateTabs(),
        ),
      ),
      body: exPosts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: _generateTabViews(),
            ),
                 floatingActionButton: FloatingActionButton(
        onPressed: () {
      Get.to(ExerciesePage());
        },
        backgroundColor: const Color(
            0xFFFFAC41), // Change the background color to your desired color
        foregroundColor: Colors
            .white, // Change the foreground color (icon color) to your desired color
        elevation: 4, // Change the elevation if needed
        tooltip: 'เพิ่มข้อมูล', // Add a tooltip for accessibility
        child: Icon(Icons.add), // Change the icon to your desired icon
      ),
    );
  }
}
