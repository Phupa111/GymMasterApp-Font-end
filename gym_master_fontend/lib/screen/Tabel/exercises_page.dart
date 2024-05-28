import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_master_fontend/model/ExPostModel.dart';

class ExerciesePage extends StatefulWidget {
  const ExerciesePage({Key? key}) : super(key: key);

  @override
  State<ExerciesePage> createState() => _ExerciesePageState();
}

class _ExerciesePageState extends State<ExerciesePage> {
  List<ExPostModel> exPosts = [];
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ท่าออกกำลังกาย"),
      ),
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: exPosts.length,
              itemBuilder: (context, index) {
                final exPost = exPosts[index];
                // Build your list item using exPost data
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
              exPost.gifImage.toString(),
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
          }
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    final dio = Dio();

    try {
      final response =
          await dio.get('http://192.168.1.127:8080/exPost/getExPost');
      final jsonData =
          response.data as List<dynamic>; // Assuming the response is a list
      exPosts = jsonData.map((item) => ExPostModel.fromJson(item)).toList();
    } catch (e) {
      print('Error loading data: $e');
      throw Exception('Error loading data');
    }
  }
}
