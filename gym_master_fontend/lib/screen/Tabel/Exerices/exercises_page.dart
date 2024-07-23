import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/ExPostModel.dart';

class ExerciesePage extends StatefulWidget {
  final int tabelID;
  final int dayNum;
  const ExerciesePage({Key? key, required this.tabelID, required this.dayNum})
      : super(key: key);

  @override
  State<ExerciesePage> createState() => _ExerciesePageState();
}

class _ExerciesePageState extends State<ExerciesePage> {
  List<ExPostModel> exPosts = [];
  late Future<void> loadData;
  var _setContron = TextEditingController();
  var _repContron = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TID ${widget.tabelID} DayNum ${widget.dayNum}"),
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
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        exPost.name,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      openDialog(exPost.eid);
                                    },
                                    child: const Icon(Icons.add),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFFFFAC41)),
                                    )),
                              ],
                            ),
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

Future openDialog(int eid) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('เพิ่มท่า'),
    content: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the screen width
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust the size based on the content
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: const Color(0xFFF1F0F0),
                  border: InputBorder.none,
                  hintText: "จำนวน set",
                  hintStyle: const TextStyle(
                    fontFamily: 'Kanit',
                    color: Color(0xFFFFAC41),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                     inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: _setContron,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: const Color(0xFFF1F0F0),
                  border: InputBorder.none,
                  hintText: "จำนวน ครั้ง (rep)",
                  hintStyle: const TextStyle(
                    fontFamily: 'Kanit',
                    color: Color(0xFFFFAC41),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller:_repContron,
              ),
            ),
          ],
        ),
      ),
    ),
actions: [
  ElevatedButton(
    onPressed: () async {
      // Call the addExPost function and wait for it to complete
      await addExPost(eid);
      
      // Refresh the data and close the popup
      setState(() {
        loadData = loadDataAsync();
      });
      Navigator.of(context).pop(); // Close the popup
    },
    child: const Text(
      "ตกลง",
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFAC41), // Button background color
    ),
  ),
],

  ),
);

Future<void> addExPost(int eid) async {
  final dio = Dio();
  var regBody = {
    "tid": widget.tabelID,
    "eid": eid,
    "dayNum": widget.dayNum,
    "set": int.parse(_setContron.text),
    "rep": int.parse(_repContron.text)
  };

  try {
    final response = await dio.post(
      'http://192.168.2.151:8080/tabel/addExPosttoTabel',
      data: regBody, // Pass regBody directly
    );

    if (response.statusCode == 200) {
      // Handle success
      log('Exercise post added successfully');
 
    } else {
      // Handle other status codes
      log('Failed to add exercise post: ${response.statusCode}');
    }
  } catch (e) {
    // Handle error
    log('Error adding exercise post: $e');
  }
}


  Future<void> loadDataAsync() async {
    final dio = Dio();

    try {
      final response =
          await dio.get('http://192.168.2.151:8080/exPost/getExPost?tid=${widget.tabelID}&dayNum=${widget.dayNum}');
      final jsonData =
          response.data as List<dynamic>; // Assuming the response is a list
      exPosts = jsonData.map((item) => ExPostModel.fromJson(item)).toList();
    } catch (e) {
      print('Error loading data: $e');
      throw Exception('Error loading data');
    }
  }
}
