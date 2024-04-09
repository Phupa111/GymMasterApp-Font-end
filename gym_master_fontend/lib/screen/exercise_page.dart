import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/screen/tdee_page/tdee_page.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("exercise")),
      body: Container(
        child: Center(
          child: FilledButton(
            onPressed: () {
              Get.to(() => TdeePage());
            },
            child: Text("TDEE Page"),
          ),
        ),
      ),
    );
  }
}
