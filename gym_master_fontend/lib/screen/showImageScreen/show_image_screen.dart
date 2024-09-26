import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/model/PhotoProgressModel.dart';
import 'package:gym_master_fontend/screen/confirm_image_screen/confirm_image_screen.dart';
import 'package:gym_master_fontend/services/photo_service.dart';
import 'package:gym_master_fontend/widgets/dialog/show_detail_image_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ShowImageScreen extends StatefulWidget {
  const ShowImageScreen({super.key, required this.uid, required this.tokenJwt});

  final int uid;
  final String tokenJwt;
  @override
  State<ShowImageScreen> createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? fileImage;
  int? uid;
  String? tokenJwt;

  late Future<List<PhotoProgressModel>> photoAsync;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    tokenJwt = widget.tokenJwt;
    photoAsync = PhotoService().getPhotoPregress(uid!, tokenJwt!);
  }

  pickWithGallery() async {
    fileImage = await _picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return; // Check if the widget is still in the tree
    setState(() {
      log(fileImage!.path);
    });

    if (fileImage != null) {
      final checkInsertByGallery = await Get.to(() => ConfirmImageScreen(
            imagePath: fileImage!,
            uid: uid!,
            tokenJwt: tokenJwt!,
          ));
      if (checkInsertByGallery == 1 && mounted) {
        setState(() {
          photoAsync = PhotoService().getPhotoPregress(uid!, tokenJwt!);
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "เพิ่มรูปสำเร็จ",
          btnOkOnPress: () {},
        ).show();
      } else if (checkInsertByGallery == 0 && mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "เพิ่มรูปไม่สำเร็จ",
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }

  pickWithCamera() async {
    fileImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (fileImage != null) {
        log(fileImage!.path);
      }
    });

    if (fileImage != null) {
      final checkInsertByCamera = await Get.to(() => ConfirmImageScreen(
            imagePath: fileImage!,
            uid: uid!,
            tokenJwt: tokenJwt!,
          ));
      if (checkInsertByCamera == 1 && mounted) {
        setState(() {
          photoAsync = PhotoService().getPhotoPregress(uid!, tokenJwt!);
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "เพิ่มรูปสำเร็จ",
          btnOkOnPress: () {},
        ).show();
      } else if (checkInsertByCamera == 0 && mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "เพิ่มรูปไม่สำเร็จ",
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }

  Widget pickImageDialog() {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 254, 252),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 40,
              onPressed: pickWithCamera,
              icon: const FaIcon(
                FontAwesomeIcons.camera,
                color: Colors.orange,
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              iconSize: 40,
              onPressed: pickWithGallery,
              icon: const FaIcon(
                FontAwesomeIcons.images,
                color: Colors.orange,
              ),
            )
          ],
        )),
      ),
    );
  }

  Map<String, List<PhotoProgressModel>> groupByMonthYear(
      List<PhotoProgressModel> progressList) {
    Map<String, List<PhotoProgressModel>> groupedData = {};

    for (var progress in progressList) {
      DateTime dateTime = DateTime.parse(
          progress.dataProgress); // แปลง dataProgress เป็น DateTime
      String monthYear =
          "${DateFormat('MMMM').format(dateTime)} ${dateTime.year}";

      if (!groupedData.containsKey(monthYear)) {
        groupedData[monthYear] = [];
      }

      groupedData[monthYear]!.add(progress);
    }

    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(result: 1);
          },
          icon: const FaIcon(
            FontAwesomeIcons.angleLeft,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: const Text(
          "Gallery",
          style: TextStyle(fontFamily: 'Kanit', color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<PhotoProgressModel>>(
          future: photoAsync,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                'ไม่มีรูปกดเพื่อถ่าย',
                style: TextStyle(fontFamily: 'Kanit'),
              )); // If no data
            } else {
              final data = snapshot.data!;
              log("show image : $data");
              final groupedData = groupByMonthYear(data);
              return ListView.builder(
                itemCount: groupedData.keys.length, // จำนวนกลุ่มเดือนและปี
                itemBuilder: (context, index) {
                  String monthYear = groupedData.keys.elementAt(index);
                  log(monthYear);
                  List<PhotoProgressModel> monthlyProgress =
                      groupedData[monthYear]!.reversed.toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          monthYear, // แสดงเดือนและปี
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit'),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap:
                            true, // ต้องการเพื่อไม่ให้ ListView conflict กับ GridView
                        physics:
                            const NeverScrollableScrollPhysics(), // ปิดการเลื่อน GridView
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // จำนวนคอลัมน์
                        ),
                        itemCount: monthlyProgress.length,
                        itemBuilder: (context, index) {
                          final progress = monthlyProgress[index];
                          final currentContext = context;
                          return GestureDetector(
                            onTap: () async {
                              final update = await Get.to(
                                () => ShowDetailImageDialog(
                                  pid: progress.pid,
                                  picture: progress.picture,
                                  dateprogress: progress.dataProgress,
                                  tokenJwt: tokenJwt!,
                                  uid: uid!,
                                ),
                                fullscreenDialog: true,
                                transition: Transition.downToUp,
                              );

                              if (mounted && update != null) {
                                if (update == 1) {
                                  setState(() {
                                    photoAsync = PhotoService()
                                        .getPhotoPregress(uid!, tokenJwt!);
                                  });
                                } else if (update == 0) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    title: "เกิดข้อผิดพลาด",
                                    desc: "ไม่สามารถลบรูปได้",
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              }
                            },
                            child: Card(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(progress.picture),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(pickImageDialog());
        },
        splashColor: Colors.white,
        child: const FaIcon(FontAwesomeIcons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
