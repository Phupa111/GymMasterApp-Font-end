import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_master_fontend/model/TabelModel.dart';

class AdminTabelPage extends StatefulWidget {
  const AdminTabelPage({Key? key}) : super(key: key);

  @override
  State<AdminTabelPage> createState() => _AdminTabelPageState();
}

class _AdminTabelPageState extends State<AdminTabelPage> {
  List<TabelModel> adminTabels = [];
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
        title: const Text("คอร์สทั้งหมด"),
      ),
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data loaded successfully, display the content
            return ListView.builder(
              itemCount: adminTabels.length,
              itemBuilder: (context, index) {
                final adminTabel = adminTabels[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                      onTap: () {
        
      },
                    child: Card(
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.amber,
                            width: 2.0), // Customize the color and width as needed
                        borderRadius: BorderRadius.circular(
                            10.0), // Customize the border radius as needed
                      ),
                      child: ListTile(
                        title: Text(adminTabel.couserName.toString()),
                        // Add more content here as needed
                      ),
                      
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
          await dio.get('http://192.168.1.101:8080/Tabel/getAdminTabel');
      final jsonData =
          response.data as List<dynamic>; // Assuming the response is a list
      adminTabels = jsonData.map((item) => TabelModel.fromJson(item)).toList();
      log(adminTabels.length.toString());
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception('Error fetching data');
    }
  }
}
