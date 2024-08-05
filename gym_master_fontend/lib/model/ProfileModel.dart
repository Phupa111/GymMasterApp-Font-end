// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

List<ProfileModel> profileModelFromJson(String str) => List<ProfileModel>.from(
    json.decode(str).map((x) => ProfileModel.fromJson(x)));

String profileModelToJson(List<ProfileModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileModel {
  List<Detail> detail;
  String bmi;
  String bmr;
  String bodyFat;

  ProfileModel({
    required this.detail,
    required this.bmi,
    required this.bmr,
    required this.bodyFat,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        detail:
            List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
        bmi: json["bmi"],
        bmr: json["bmr"],
        bodyFat: json["bodyFat"],
      );

  Map<String, dynamic> toJson() => {
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "bmi": bmi,
        "bmr": bmr,
        "bodyFat": bodyFat,
      };
}

class Detail {
  int uid;
  String username;
  String email;
  String profilePic;
  int gender;
  String birthday;
  int height;
  double weight;

  Detail({
    required this.uid,
    required this.username,
    required this.email,
    required this.profilePic,
    required this.gender,
    required this.birthday,
    required this.height,
    required this.weight,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        profilePic: json["profile_pic"],
        gender: json["gender"],
        birthday: json["birthday"],
        height: json["height"],
        weight: json["weight"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "profile_pic": profilePic,
        "gender": gender,
        "birthday": birthday,
        "height": height,
        "weight": weight,
      };
}
