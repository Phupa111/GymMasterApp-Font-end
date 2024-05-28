import 'dart:developer';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:provider/provider.dart';

class CreateTabelPage extends StatefulWidget {
  const CreateTabelPage({super.key});

  @override
  State<CreateTabelPage> createState() => _CreateTabelPageState();
}

class _CreateTabelPageState extends State<CreateTabelPage> {

   GetStorage gs = GetStorage();
  late UserModel userModel = gs.read('userModel');
  var _couserName = TextEditingController();
  var _times = TextEditingController();
  var _dayPerWeek =TextEditingController();

void createTabel() async {
  log(userModel.user.uid.toString());
  log(_couserName.text);
  var regBody = {
    "uid":userModel.user.uid , // Assuming userModel is defined somewhere in your code
    "couserName": _couserName.text, // Corrected variable name
    "times": int.parse(_times.text),
    "gender": 0,
    "level": 0,
    "description": "",
    "isCreatedByAdmin": 0, // Corrected variable name
    "dayPerWeek": int.parse(_dayPerWeek.text),
  };

  try {
    // Create a Dio instance
    final dio = Dio();

    // Make a POST request
    final response = await dio.post(
      'http://192.168.1.127:8080/tabel/CreatTabel', // Corrected URL
      data: regBody,
    );

   if(response.statusCode == 200)
   {
    log("Success");
   }
    // Handle the response here (e.g., check response.statusCode)
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error creating table: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(  // Center the whole content vertically and horizontally
          child: Column(
            
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 150),
                child: Text("สร้างตาราง",style: TextStyle(color: Color(0xFFFFAC41),fontSize: 50,fontFamily: 'Kanit'),),
              ),
              Padding( 
                padding: const EdgeInsets.only(top: 40),
                child: Form(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(decoration: InputDecoration(
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
                                hintText: "ชื่อตาราง",
                                hintStyle: const TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Color(0xFFFFAC41),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .transparent), // Change border color on focus
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              controller: _couserName,),
                  ),
                               Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(decoration: InputDecoration(
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
                                hintText: "ระยะเวลา (สัปดาห์)",
                                hintStyle: const TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Color(0xFFFFAC41),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .transparent), // Change border color on focus
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                
                              ),
                                  keyboardType: TextInputType.number,
                             controller: _times,    
                              ),
                              
                  ),
                               Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(decoration: InputDecoration(
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
                                hintText: "จำนวนวันที่ออกกกำลังกาย",
                                hintStyle: const TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Color(0xFFFFAC41),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .transparent), // Change border color on focus
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              controller: _dayPerWeek,
                                   onTap: () {
                                       showCupertinoModalPopup(
  context: context,
  builder: (BuildContext context) => SizedBox(
    height: 250,
    child: CupertinoPicker(
      backgroundColor: Colors.white,
      itemExtent: 32.0, // Adjusted item extent to a more suitable value for better visibility
      scrollController: FixedExtentScrollController(initialItem: 0), // Initial item is 0 which corresponds to 1 in the list
      onSelectedItemChanged: (value) {
        setState(() {
          // Handle the selected value here
          _dayPerWeek.text = value.toString();
        });
      },
      children: List.generate(
        7,
        (index) => Center(child: Text('${index + 1} วัน')), // Adjusted to display 1-7
      ),
    ),
  ),
);

                                                       
                                                           },
                              ),
                  )
                ],)),
              ),
SizedBox(
  width: 250, // Set the desired width
  child: ElevatedButton(
    onPressed: () {
      // Button action
      createTabel() ;
    },
    child: const Text(
      "ตกลง",
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFAC41), // Button background color
    ),
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
