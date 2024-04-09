import 'package:flutter/material.dart';
import 'package:gym_master_fontend/screen/photo_page.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({super.key});

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("static")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PhotoPage()),
                  );
                },
                child: Text(
                  'Photo',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800], fixedSize: Size(250, 50)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
