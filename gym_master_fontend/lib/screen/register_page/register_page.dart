import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const Text(
                  "กรอกข้อมูล",
                  style: TextStyle(
                    fontSize: 42,
                    color: Color(0xFFFFAC41),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: const Color(0xFFF1F0F0),
                    border: InputBorder.none,
                    hintText: "ชื่อผู้ใช้",
                    hintStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFAC41),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors
                              .transparent), // Change border color on focus
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.monitor_weight_sharp,
                      color: Color(0xFFFFAC41),
                    ),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "กก.",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFFAC41)),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: const Color(0xFFF1F0F0),
                    border: InputBorder.none,
                    hintText: "น้ำหนัก",
                    hintStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFAC41),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors
                              .transparent), // Change border color on focus
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    focusColor: Color(0xFFFFAC41),
                    prefixIcon: Icon(
                      Icons.accessibility,
                      color: Color(0xFFFFAC41),
                    ),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "ซม.",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFFAC41)),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: const Color(0xFFF1F0F0),
                    border: InputBorder.none,
                    hintText: "ส่วนสูง",
                    hintStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFAC41),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors
                              .transparent), // Change border color on focus
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_today_rounded,
                      color: Color(0xFFFFAC41),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: const Color(0xFFF1F0F0),
                    border: InputBorder.none,
                    hintText: "วัน-เดือน-ปีเกิด",
                    hintStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFAC41),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors
                              .transparent), // Change border color on focus
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  controller: _date,
                  onTap: () {
                    print("clicked");
                    _selectDate();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xFFFFAC41),
              ),
            ),
            child: child!);
      },
    );

    if (_picked != null) {
      setState(() {
        _date.text =
            "${_picked.day.toString().padLeft(2, '0')}-${_picked.month.toString().padLeft(2, '0')}-${_picked.year.toString()}";
        print(_date.text);
      });
    }
  }
}
