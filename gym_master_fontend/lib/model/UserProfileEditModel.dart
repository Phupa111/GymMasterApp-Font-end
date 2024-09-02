// To parse this JSON data, do
//
//     final userProfileEditModel = userProfileEditModelFromJson(jsonString);

import 'dart:convert';

List<UserProfileEditModel> userProfileEditModelFromJson(String str) =>
    List<UserProfileEditModel>.from(
        json.decode(str).map((x) => UserProfileEditModel.fromJson(x)));

String userProfileEditModelToJson(List<UserProfileEditModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserProfileEditModel {
  int uid;
  int gender;
  String profilePic;
  String username;
  String password;
  int height;
  String weight;

  UserProfileEditModel({
    required this.uid,
    required this.gender,
    required this.profilePic,
    required this.username,
    required this.password,
    required this.height,
    required this.weight,
  });

  factory UserProfileEditModel.fromJson(Map<String, dynamic> json) =>
      UserProfileEditModel(
        uid: json["uid"],
        gender: json["gender"],
        profilePic: json["Profile_pic"],
        username: json["username"],
        password: json["password"],
        height: json["height"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "gender": gender,
        "Profile_pic": profilePic,
        "username": username,
        "password": password,
        "height": height,
        "weight": weight,
      };
}
