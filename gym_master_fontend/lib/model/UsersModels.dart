// To parse this JSON data, do
//
//     final usersModels = usersModelsFromJson(jsonString);

import 'dart:convert';

List<UsersModels> usersModelsFromJson(String str) => List<UsersModels>.from(
    json.decode(str).map((x) => UsersModels.fromJson(x)));

String usersModelsToJson(List<UsersModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersModels {
  int uid;
  String username;
  String email;
  String password;
  double height;
  DateTime birthday;
  int gender;
  String profilePic;
  int? daySuscessExerice;
  int role;
  int isDisbel;

  UsersModels({
    required this.uid,
    required this.username,
    required this.email,
    required this.password,
    required this.height,
    required this.birthday,
    required this.gender,
    required this.profilePic,
    required this.daySuscessExerice,
    required this.role,
    required this.isDisbel,
  });

  factory UsersModels.fromJson(Map<String, dynamic> json) => UsersModels(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        height: json["height"]?.toDouble(),
        birthday: DateTime.parse(json["birthday"]),
        gender: json["gender"],
        profilePic: json["profile_pic"],
        daySuscessExerice: json["day_suscess_exerice"],
        role: json["role"],
        isDisbel: json["isDisbel"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "password": password,
        "height": height,
        "birthday": birthday.toIso8601String(),
        "gender": gender,
        "profile_pic": profilePic,
        "day_suscess_exerice": daySuscessExerice,
        "role": role,
        "isDisbel": isDisbel,
      };
}
