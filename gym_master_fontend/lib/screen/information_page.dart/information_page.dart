import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  TextEditingController _date = TextEditingController();
  String _dropdownValue = "male";
  final _gender = ["Male", "Female"];
  final _formkey = GlobalKey<FormState>();
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
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey,
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
                    TextFormField(
                      validator: (username) {
                        if (username!.isEmpty) {
                          return "Please Enter username";
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xFFF1F0F0),
                        border: InputBorder.none,
                        hintText: "ชื่อผู้ใช้",
                        hintStyle: const TextStyle(
                          fontFamily: 'Kanit',
                          color: Color(0xFFFFAC41),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.monitor_weight_sharp,
                          color: Color(0xFFFFAC41),
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            "กก.",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFFAC41)),
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
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        focusColor: const Color(0xFFFFAC41),
                        prefixIcon: const Icon(
                          Icons.accessibility,
                          color: Color(0xFFFFAC41),
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            "ซม.",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFFAC41)),
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
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
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
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      controller: _date,
                      onTap: () {
                        // print("clicked");
                        _selectDate();
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    DropdownButtonFormField(
                      iconEnabledColor: const Color(0xFFFFAC41),
                      items: _gender.map((String gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _dropdownValue = value!;
                        });
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F0F0),
                          prefixIcon: const Icon(
                            Icons.transgender_sharp,
                            color: Color(0xFFFFAC41),
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors
                                    .transparent), // Change border color on focus
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintText: "เพศ",
                          hintStyle: const TextStyle(color: Color(0xFFFFAC41))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Change border color on focus
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.percent_sharp,
                          color: Color(0xFFFFAC41),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xFFF1F0F0),
                        border: InputBorder.none,
                        hintText: "Body Fat",
                        hintStyle: const TextStyle(
                          fontFamily: 'Kanit',
                          color: Color(0xFFFFAC41),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FilledButton(
                        onPressed: () {
                          _formkey.currentState!.validate();
                        },
                        child: Text("9jvwx"))
                  ],
                ),
              ),
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
              colorScheme: const ColorScheme.light(
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
