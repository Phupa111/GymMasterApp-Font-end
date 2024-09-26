// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/EquimentModel.dart';
import 'package:gym_master_fontend/model/ExPostModel.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class ExerciesePage extends StatefulWidget {
  final int tabelID;
  final int dayNum;
  final String tokenJWT;
  const ExerciesePage(
      {super.key,
      required this.tabelID,
      required this.dayNum,
      required this.tokenJWT});

  @override
  State<ExerciesePage> createState() => _ExerciesePageState();
}

class _ExerciesePageState extends State<ExerciesePage> {
  List<ExPostModel> exPosts = [];
  late Future<void> loadData;
  List<EqiumentModel> eqiuments = [];
  final _setContron = TextEditingController();
  final _repContron = TextEditingController();
  String url = AppConstants.BASE_URL;
  final TextEditingController searchController = TextEditingController();
  String equipmentValue = '';
  String muscleValue = '';
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Future<dynamic> showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("คัดกรอง"),
              ),
              const Text('กล้ามเนื้อ'),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMuscelButton('', 'ทั้งหมด'),
                      _buildMuscelButton('1', 'chest'),
                      _buildMuscelButton('2', 'abs'),
                      _buildMuscelButton('3', 'leg'),
                      _buildMuscelButton('4', 'back'),
                      _buildMuscelButton('5', 'Trapezius'),
                      _buildMuscelButton('6', 'Shoulders'),
                      _buildMuscelButton('7', 'neck'),
                      _buildMuscelButton('8', 'arms'),
                    ],
                  ),
                ),
              ),
              const Text('อุปกรณ์'),
              Center(child: _buildEquipmentButton()),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    loadData = loadDataAsync();
                    Navigator.pop(context);
                  });
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFFFAC41)),
                ),
                child: const Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadEqiument() async {
    final dio = Dio();
    try {
      final String endpoint = 'http://$url/exPost/getEqiumentList';

      final response = await dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.tokenJWT}',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data as List<dynamic>;
        setState(() {
          eqiuments =
              jsonData.map((item) => EqiumentModel.fromJson(item)).toList();
        });
      } else {
        // Handle cases where the status code is not 200 (OK)
        log('Error: Failed to load equipment, status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Failed to load equipment. Please try again later.")),
        );
      }
    } catch (e) {
      log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("An error occurred. Please try again later.")),
      );
    }
  }

  Widget _buildEquipmentButton() {
    return FutureBuilder<void>(
      future: loadEqiument(), // Load equipment asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return SizedBox(
            height: 60, // Set a fixed height for the container
            child: Row(
              children: [
                FilledButton(
                  onPressed: () {
                    setState(() {
                      equipmentValue = '';
                      Navigator.pop(context);
                      showBottomSheet(context);
                      log(equipmentValue);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      equipmentValue == ''
                          ? const Color(0xFFFFAC41)
                          : Colors.white,
                    ),
                  ),
                  child: Text(
                    "ทั้งหมด",
                    style: TextStyle(
                      color: equipmentValue == ''
                          ? Colors.white
                          : const Color(0xFFFFAC41),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Horizontal scrolling
                    itemCount: eqiuments.length, // Number of items in the list
                    itemBuilder: (context, index) {
                      final equipment = eqiuments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              equipmentValue = (index + 1).toString();
                              Navigator.pop(context);
                              showBottomSheet(context);
                              log(equipmentValue);
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              equipmentValue == (index + 1).toString()
                                  ? const Color(0xFFFFAC41)
                                  : Colors.white,
                            ),
                          ),
                          child: Text(
                            equipment.name,
                            style: TextStyle(
                              color: equipmentValue == (index + 1).toString()
                                  ? Colors.white
                                  : const Color(0xFFFFAC41),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMuscelButton(String value, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(
        onPressed: () {
          setState(() {
            muscleValue = value;
            Navigator.pop(context);
            showBottomSheet(context);
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            muscleValue == value ? const Color(0xFFFFAC41) : Colors.white,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                muscleValue == value ? Colors.white : const Color(0xFFFFAC41),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ท่าออกกำลังกาย"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: true);
          },
        ),
      ),
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.8, // Adjust the width as needed
                      child: SearchBar(
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 12.0)),
                        controller: searchController,
                        onTap: () {},
                        onChanged: (value) {
                          if (searchController.text.isEmpty) {
                            exPosts.clear();
                            setState(() {
                              loadData = loadDataAsync();
                            });
                          }
                        },
                        onSubmitted: (value) {
                          setState(() {
                            loadData = loadDataAsync();
                          });
                        },
                        leading: const Icon(Icons.search),
                        trailing: <Widget>[
                          Tooltip(
                            message: 'Filter',
                            child: IconButton(
                              onPressed: () {
                                showBottomSheet(context);
                              },
                              icon: const Icon(Icons.filter_alt_sharp),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
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
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              exPost.name,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              exPost.equipment,
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
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFFFFAC41)),
                                          ),
                                          child: const Icon(Icons.add)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
            width: MediaQuery.of(context).size.width *
                0.8, // Set the width to 80% of the screen width
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Adjust the size based on the content
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
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: _setContron,
                      readOnly: true,
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 250,
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 32.0,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: 0),
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      _setContron.text = (value + 1).toString();
                                    });
                                  },
                                  children: List.generate(
                                    10,
                                    (index) =>
                                        Center(child: Text('${index + 1} set')),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_setContron.text.isEmpty) {
                                    _setContron.text = "1";
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('ตกลง'),
                              ),
                            ],
                          ),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาใส่จำนวน sets';
                        }
                        return null;
                      },
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
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: _repContron,
                      readOnly: true,
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 250,
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 32.0,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: 0),
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      _repContron.text = (value + 6).toString();
                                    });
                                  },
                                  children: List.generate(
                                    10,
                                    (index) => Center(
                                        child: Text('${index + 6} reps')),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_repContron.text.isEmpty) {
                                    _repContron.text = "6";
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('ตกลง'),
                              ),
                            ],
                          ),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาใส่จำนวน reps';
                        }
                        return null;
                      },
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

                if (_formKey.currentState?.validate() ?? false) {
                  await addExPost(eid);
                  setState(() {
                    loadData = loadDataAsync();
                  });
                  Navigator.of(context).pop();
                }
                // Refresh the data and close the popup
                // Close the popup
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFFAC41), // Button background color
              ),
              child: const Text(
                "ตกลง",
                style: TextStyle(color: Colors.white),
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
        'http://$url/tabel/addExPosttoTabel',
        data: regBody, // Pass regBody directly
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.tokenJWT}',
          },
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
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
      final response = await dio.get(
          'http://$url/exPost/getExPosts?tid=${widget.tabelID}&dayNum=${widget.dayNum}&nameFilter=${searchController.text}&equipmentFilter=$equipmentValue&muscleFilter=$muscleValue',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${widget.tokenJWT}',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      final jsonData =
          response.data as List<dynamic>; // Assuming the response is a list
      exPosts = jsonData.map((item) => ExPostModel.fromJson(item)).toList();
    } catch (e) {
      log('Error loading data: $e');
      throw Exception('Error loading data');
    }
  }
}
