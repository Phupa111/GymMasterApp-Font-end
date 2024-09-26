import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gym_master_fontend/services/photo_service.dart';
import 'package:intl/intl.dart';

class ShowDetailImageDialog extends StatefulWidget {
  const ShowDetailImageDialog(
      {super.key,
      required this.pid,
      required this.picture,
      required this.dateprogress,
      required this.tokenJwt,
      required this.uid});
  final int pid;
  final String picture;
  final String dateprogress;
  final String tokenJwt;
  final int uid;

  @override
  State<ShowDetailImageDialog> createState() => _ShowDetailImageDialogState();
}

class _ShowDetailImageDialogState extends State<ShowDetailImageDialog> {
  late int pid;
  late int uid;
  late String picture;
  late String date;
  late String formatDate;
  late String formatTime;
  late String tokenJwt;
  late int status;

  @override
  void initState() {
    super.initState();
    pid = widget.pid;
    uid = widget.uid;
    picture = widget.picture;
    date = widget.dateprogress;
    tokenJwt = widget.tokenJwt;
    formatDate = _formatDateDay(date);
    formatTime = _formatDateTime(date);
  }

  String _formatDateDay(String date) {
    DateTime datetime = DateTime.parse(date);
    return DateFormat("dd-MM-yyyy").format(datetime);
  }

  String _formatDateTime(String date) {
    DateTime datetime = DateTime.parse(date);
    return DateFormat("HH.mm").format(datetime);
  }

  Future<void> deleteImageProgress(int uid, int pid, String tokenJwt) async {
    status = await PhotoService().deleteImage(uid, pid, tokenJwt);
    if (status == 1) {
      Get.back(result: 1);
    } else {
      Get.back(result: 0);
    }
  }

  Future<void> setBeforeProgress(int uid, int pid, String tokenJwt) async {
    status = await PhotoService().setBeforeImageProgress(uid, pid, tokenJwt);
    if (status == 1) {
      Get.back(result: 2);
    } else {
      Get.back(result: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog.fullscreen(
        backgroundColor: const Color.fromARGB(255, 247, 159, 28),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(picture),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.x,
                              color: Color.fromARGB(255, 224, 224, 224),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  title: "ยืนยันการลบรูปภาพ!!!",
                                  btnOkText: "ยืนยัน",
                                  btnOkOnPress: () {
                                    deleteImageProgress(uid, pid, tokenJwt);
                                  },
                                ).show();
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: Colors.red,
                              )),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.21,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3,
                          offset: Offset(2, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "ถ่ายเมื่อวันที่",
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "$formatDate $formatTime",
                            style: const TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.orangeAccent,
                                  ),
                                ),
                                onPressed: () {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    title: "ยืนยันการตั้งเป็น Before",
                                    btnOkText: "ยืนยัน",
                                    btnOkOnPress: () {
                                      setBeforeProgress(uid, pid, tokenJwt);
                                    },
                                  ).show();
                                },
                                child: const Text(
                                  "Before",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Kanit',
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
