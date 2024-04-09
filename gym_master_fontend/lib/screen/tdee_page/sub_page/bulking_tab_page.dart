import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BulkingTabPage extends StatelessWidget {
  const BulkingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          const Text(
            "แคลเลอลี่ที่ท่านควรได้รับต่อวัน",
            style: TextStyle(
                color: Color(0xffFFAC41), fontFamily: 'Kanit', fontSize: 16.0),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "2078",
                style: TextStyle(
                  color: Color(0xffFFAC41),
                  fontSize: 96,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w100,
                ),
              ),
              Padding(
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
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: const Color(0xffFFAC41),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 5),
                        color: const Color.fromARGB(96, 141, 139, 139),
                        blurRadius: 5),
                  ]),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.drumstickBite,
                  color: Colors.white,
                ),
                title: Row(
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
                  "120g.",
                  style: TextStyle(
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
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: const Color(0xffFFAC41),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 5),
                        color: const Color.fromARGB(96, 141, 139, 139),
                        blurRadius: 5),
                  ]),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.breadSlice,
                  color: Colors.white,
                ),
                title: Row(
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
                  "60g.",
                  style: TextStyle(
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
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: const Color(0xffFFAC41),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 5),
                        color: const Color.fromARGB(96, 141, 139, 139),
                        blurRadius: 5),
                  ]),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.droplet,
                  color: Colors.white,
                ),
                title: Row(
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
                  "40g.",
                  style: TextStyle(
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
  }
}
