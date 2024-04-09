// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  User user;

  UserModel({
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class User {
  int uid;
  String username;
  String email;
  String password;
  int height;
  String birthday;
  int gender;
  String profilePic;
  int daySuscessExerice;
  int role;

  User({
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
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        height: json["height"],
        birthday: json["birthday"],
        gender: json["gender"],
        profilePic: json["profile_pic"],
        daySuscessExerice: json["day_suscess_exerice"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "password": password,
        "height": height,
        "birthday": birthday,
        "gender": gender,
        "profile_pic": profilePic,
        "day_suscess_exerice": daySuscessExerice,
        "role": role,
      };
}
