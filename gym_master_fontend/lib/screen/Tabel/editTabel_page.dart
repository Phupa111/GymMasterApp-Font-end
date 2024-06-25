import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/ExInTabelModel.dart';
import 'package:gym_master_fontend/screen/Tabel/Exerices/exercises_page.dart';

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
  List<List<ExInTabelModel>> exPosts = [];
  int dayNum = 1;

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
          'http://192.168.2.37:8080/tabel/getExercisesInTabel',
          data: {'tid': widget.tabelID, 'dayNum': day},
        );
        final jsonData = response.data as List<dynamic>;
        exPosts.add(jsonData.map((item) => ExInTabelModel.fromJson(item)).toList());
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
                        exPost.gifImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          );
                        },
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
                        Text('Sets: ${exPost.exInTabelModelSet}'),
                        Text('Reps: ${exPost.rep}'),
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
          Get.to(() => ExerciesePage(
                tabelID: widget.tabelID,
                dayNum: _tabController.index + 1, // Pass the current tab index + 1 for day number
              ));
        },
        backgroundColor: const Color(0xFFFFAC41),
        foregroundColor: Colors.white,
        elevation: 4,
        tooltip: 'เพิ่มข้อมูล',
        child: Icon(Icons.add),
      ),
    );
  }
}
