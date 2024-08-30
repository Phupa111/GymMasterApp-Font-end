// To parse this JSON data, do
//
//     final exInTabelModel = exInTabelModelFromJson(jsonString);

import 'dart:convert';

List<ExInTabelModel> exInTabelModelFromJson(String str) =>
    List<ExInTabelModel>.from(
        json.decode(str).map((x) => ExInTabelModel.fromJson(x)));

String exInTabelModelToJson(List<ExInTabelModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExInTabelModel {
  int cpid;
  int eid;
  String gifImage;
  String name;
  int exInTabelModelSet;
  int rep;

  ExInTabelModel({
    required this.cpid,
    required this.eid,
    required this.gifImage,
    required this.name,
    required this.exInTabelModelSet,
    required this.rep,
  });

  factory ExInTabelModel.fromJson(Map<String, dynamic> json) => ExInTabelModel(
        cpid: json["cpid"],
        eid: json["eid"],
        gifImage: json["gif_image"],
        name: json["name"],
        exInTabelModelSet: json["set"],
        rep: json["rep"],
      );

  Map<String, dynamic> toJson() => {
        "cpid": cpid,
        "eid": eid,
        "gif_image": gifImage,
        "name": name,
        "set": exInTabelModelSet,
        "rep": rep,
      };
}
