import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_master_fontend/model/tdeeModel.dart';

class BulkingTabPage extends StatelessWidget {
  const BulkingTabPage({super.key, required this.tdeeData});
  final List<TdeeModel> tdeeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        final tdee = tdeeData[index];
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              const Text(
                "แคลเลอลี่ที่ท่านควรได้รับต่อวัน",
                style: TextStyle(
                    color: Color(0xffFFAC41),
                    fontFamily: 'Kanit',
                    fontSize: 16.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${tdee.bulking}",
                    style: const TextStyle(
                      color: Color(0xffFFAC41),
                      fontSize: 96,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 26),
                    child: Text(
                      "Kcal",
                      style: TextStyle(
                        color: Color(0xffFFAC41),
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "ปริมาณ โปรตีน/คาร์บ/ไขมัน ต่อวัน",
                  style: TextStyle(
                      color: Color(0xffFFAC41),
                      fontFamily: 'Kanit',
                      fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: const Color(0xffFFAC41),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 5),
                            color: Color.fromARGB(96, 141, 139, 139),
                            blurRadius: 5),
                      ]),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.drumstickBite,
                      color: Colors.white,
                    ),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "โปรตีน",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "${tdee.bulkProteinGram} g.",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: const Color(0xffFFAC41),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 5),
                            color: Color.fromARGB(96, 141, 139, 139),
                            blurRadius: 5),
                      ]),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.breadSlice,
                      color: Colors.white,
                    ),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "คาร์บ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "${tdee.bulkCarbGram} g.",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: const Color(0xffFFAC41),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 5),
                            color: Color.fromARGB(96, 141, 139, 139),
                            blurRadius: 5),
                      ]),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.droplet,
                      color: Colors.white,
                    ),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ไขมัน",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "${tdee.bulkFatGram} g.",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "*ิBulking คือการเพิ่มน้ำหนักและเพิ่มขนาดกล้ามเนื้อ",
                  style: TextStyle(
                      color: Color(0xffFFAC41),
                      fontFamily: 'Kanit',
                      fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
