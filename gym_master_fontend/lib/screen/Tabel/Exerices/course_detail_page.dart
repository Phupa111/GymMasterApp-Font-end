import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_master_fontend/model/UserEnabelCourseModel.dart';
import 'package:gym_master_fontend/model/weekDiffModel.dart';

class CourseDetailPage extends StatefulWidget {
  final int tabelID;
  final String tabelName;
  final int dayPerWeek;
  final int times;
  final int uid;

  const CourseDetailPage({
    super.key,
    required this.tabelID,
    required this.tabelName,
    required this.dayPerWeek,
    required this.times,
    required this.uid,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  List<UserEnabelCourse> userEnabelCourse = [];
  late Future<void> loadData;
  late WeeksDiffModel weeksDiffModel;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'http://192.168.2.221:8080/enCouser/getAllUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}',
      );
       
       final weekrespones = await dio.get(
        'http://192.168.2.221:8080/enCouser/getWeek?uid=${widget.uid}&tid=${widget.tabelID}',
      );
      // Assuming the response data is a list of JSON objects
      setState(() {
        userEnabelCourse = (response.data as List)
            .map((json) => UserEnabelCourse.fromJson(json))
            .toList();
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tabelName),
      ),
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (int i = 1; i <= widget.times; i++)
                    Column(
                      children: [
                        Text('Week $i'),
                        Row(
                          children: [
                            for (int j = 1; j <= widget.dayPerWeek; j++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle button press logic here
                                  },
                                  child: Text("$j"),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
