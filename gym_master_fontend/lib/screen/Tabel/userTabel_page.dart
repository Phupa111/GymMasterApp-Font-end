import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/TabelModel.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/screen/Tabel/createTabel_page.dart';
import 'package:gym_master_fontend/screen/Tabel/editTabel_page.dart';
import 'package:gym_master_fontend/screen/Tabel/exercises_page.dart';

class UserTabelPage extends StatefulWidget {
  const UserTabelPage({Key? key}) : super(key: key);

  @override
  State<UserTabelPage> createState() => _UserTabelPageState();
}

class _UserTabelPageState extends State<UserTabelPage> {
  List<TabelModel> userTabels = [];
  late Future<void> loadData;
  GetStorage gs = GetStorage();
  late UserModel userModel = gs.read('userModel');

    @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ตารางของฉัน"),
      ),
      body:FutureBuilder(
         future: loadData,
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else{
       return ListView.builder(
            itemCount: userTabels.length,
            itemBuilder: (context, index) {
              final tabel = userTabels[index];
              return Card(
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tabel.couserName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Times: ${tabel.times}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Days per Week: ${tabel.dayPerWeek}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              
                      Row(
                        
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8,10,8,0),
                            child: ElevatedButton(onPressed: (){}, child: Text("ใช้งาน", style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightGreen, // Button background color
                                ),),
                          ),
                               
                               Padding(
                                 padding: const EdgeInsets.fromLTRB(8,10,8,0),
                                 child: ElevatedButton(onPressed: (){
                                  Get.to(EditTabelPage(tabelID: tabel.tid,tabelName: tabel.couserName,dayPerWeek: tabel.dayPerWeek,));
                                 }, child: Text("แก้ไข", style: TextStyle(color: Colors.orange),),style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // Button background color
                                                               ),),
                               ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const CreateTabelPage());
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
  Future<void> loadDataAsync() async {
    final dio = Dio();
    log(userModel.user.uid.toString());
    var regBody = {
      "uid":userModel.user.uid
    };
    try {
      final response =
          await dio.post('http://192.168.1.101:8080/tabel/getUserTabel',data: regBody);
      final jsonData =
          response.data as List<dynamic>; // Assuming the response is a list
      userTabels = jsonData.map((item) => TabelModel.fromJson(item)).toList();
      log(userTabels.length.toString());
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception('Error fetching data');
    }
  }

}
