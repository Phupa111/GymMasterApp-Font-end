import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final ImagePicker _picker = ImagePicker();
  File? file;
  XFile? camera;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImageList = <XFile>[];
  bool uploading = false;
  // File? uploadimage;

  pickCamera() async {
    camera = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (camera != null) {}
    });
  }

  pickGallery() async {
    camera = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (camera != null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo')),
      body: const Column(
        children: [],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: FloatingActionButton(
              onPressed: pickCamera,
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
              ),
              backgroundColor: Colors.orange,
            ),
          ),
          SizedBox(width: 16),
          ClipOval(
            child: FloatingActionButton(
              onPressed: pickGallery,
              child: Icon(
                Icons.photo_library,
                color: Colors.white,
              ),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
