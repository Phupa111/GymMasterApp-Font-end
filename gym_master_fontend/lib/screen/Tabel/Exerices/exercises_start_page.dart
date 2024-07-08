import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_master_fontend/model/ExInTabelModel.dart';
import 'package:gym_master_fontend/model/UserEnabelCourseModel.dart';

class ExerciesStart extends StatefulWidget {
  final int tabelID;
  final String tabelName;
  final int dayPerWeek;
  final int times;
  final int uid;

  const ExerciesStart({
    super.key,
    required this.tabelID,
    required this.tabelName,
    required this.dayPerWeek,
    required this.times,
    required this.uid,
  });

  @override
  State<ExerciesStart> createState() => _ExerciesStartState();
}

class _ExerciesStartState extends State<ExerciesStart> {
  List<ExInTabelModel> exPosts = [];
  late UserEnabelCourse userEnabelCourse;
  late Future<void> loadData;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

@override
Widget build(BuildContext context) {
      const Color orangeColors = Colors.orange;
    const Color orangeLightColors = Color(0xFFFFB74D);
  return Scaffold(
    appBar: AppBar(
      backgroundColor: orangeColors,
    ),
 
    body: FutureBuilder(
      future: loadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: Container(
                  height: 200,
                  width: 1500,
                   decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [orangeColors, orangeLightColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight:Radius.circular(50) )),
                child: Stack(
                  children: [
                    Column(
                      children: [Center(
                        child: Text(widget.tabelName),
                      ),

                      Text("Week : ${userEnabelCourse.week}"),
                      Text("Day : ${userEnabelCourse.day}")
                      ],
                      
                    )
                  ],
                ),
                ),
               
              ),
              !isDone
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: exPosts.length,
                        itemBuilder: (context, index) {
                          final exPost = exPosts[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
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
                                        height: 50,
                                        width: 50,
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
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Text('สิ้นสุด'),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    updateDay();
                  },
                  child: Text("เริ่ม"),
                ),
              ),
            ],
          );
        }
      },
    ),
  );
}


  void updateDay() async {
    final dio = Dio();
    try {
      if(userEnabelCourse.day>=widget.dayPerWeek)
      {
        updateWeek();
      }
      else
      {
             final response = await dio.post(
        'http://192.168.2.217:8080/enCouser/updateDay',
        data: {"utid": userEnabelCourse.utid},
      );
   

      if (response.statusCode == 200) {
        log('Day updated successfully: ${response.data}');
        // Optionally, refresh data or update UI
        
      } else {
       log('Error: ${response.statusCode}, ${response.data}');
      }
      }
          setState(() {
              loadData = loadDataAsync();
          });
     
    } catch (e) {
      log('Error updating day: $e');
    }
  }

  void updateWeek() async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://192.168.2.217:8080/enCouser/updateWeek',
        data: {"utid": userEnabelCourse.utid},
      );
      setState(() {
          loadData = loadDataAsync();
      });

      if (response.statusCode == 200) {
        log('Day updated successfully: ${response.data}');
        // Optionally, refresh data or update UI
        
      } else {
       log('Error: ${response.statusCode}, ${response.data}');
      }
    } catch (e) {
      log('Error updating day: $e');
    }
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'http://192.168.2.217:8080/enCouser/getUserEnCouser?uid=${widget.uid}&tid=${widget.tabelID}',
      );
     

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List && data.isNotEmpty && data[0] is Map<String, dynamic>) {
          userEnabelCourse = UserEnabelCourse.fromJson(data[0]);

          if(userEnabelCourse.week > widget.times)
          {
            isDone = true;
          }
       
              final exercisesResponse = await dio.post(
            'http://192.168.2.217:8080/tabel/getExercisesInTabel',
            data: {'tid': widget.tabelID, 'dayNum': userEnabelCourse.day},
          );

          if (exercisesResponse.statusCode == 200) {
            final exerciseData = exercisesResponse.data as List<dynamic>;
            exPosts = exerciseData.map((item) => ExInTabelModel.fromJson(item)).toList();
          } else {
            throw Exception('Failed to load exercises: ${exercisesResponse.statusCode}');
          }
          
        
        } else {
          throw Exception('Invalid data format received');
        }
      } else {
        throw Exception('Failed to load user course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
    setState(() {});
  }
}
