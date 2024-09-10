// To parse this JSON data, do
//
//     final photoProgressModel = photoProgressModelFromJson(jsonString);

import 'dart:convert';

List<PhotoProgressModel> photoProgressModelFromJson(String str) =>
    List<PhotoProgressModel>.from(
        json.decode(str).map((x) => PhotoProgressModel.fromJson(x)));

String photoProgressModelToJson(List<PhotoProgressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhotoProgressModel {
  int uid;
  int? weight;
  String picture;
  String dataProgress;

  PhotoProgressModel({
    required this.uid,
    required this.weight,
    required this.picture,
    required this.dataProgress,
  });

  factory PhotoProgressModel.fromJson(Map<String, dynamic> json) =>
      PhotoProgressModel(
        uid: json["uid"],
        weight: json["weight"],
        picture: json["picture"],
        dataProgress: json["data_progress"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "weight": weight,
        "picture": picture,
        "data_progress": dataProgress,
      };
}
