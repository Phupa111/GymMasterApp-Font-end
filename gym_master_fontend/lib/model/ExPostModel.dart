// To parse this JSON data, do
//
//     final exPostModel = exPostModelFromJson(jsonString);

import 'dart:convert';

List<ExPostModel> exPostModelFromJson(String str) => List<ExPostModel>.from(
    json.decode(str).map((x) => ExPostModel.fromJson(x)));

String exPostModelToJson(List<ExPostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExPostModel {
  int eid;
  String? gifImage;
  String name;
  String muscle;
  String description;
  int eqid;
  String equipment;

  ExPostModel({
    required this.eid,
    this.gifImage,
    required this.name,
    required this.muscle,
    required this.description,
    required this.eqid,
    required this.equipment,
  });

  factory ExPostModel.fromJson(Map<String, dynamic> json) => ExPostModel(
        eid: json["eid"],
        gifImage: json["gif_image"] as String?,
        name: json["name"] ?? '',
        muscle: json["muscle"] ?? '',
        description: json["description"] ?? '',
        eqid: json["eqid"],
        equipment: json["equipment"],
      );

  Map<String, dynamic> toJson() => {
        "eid": eid,
        "gif_image": gifImage,
        "name": name,
        "muscle": muscle,
        "description": description,
        "eqid": eqid,
        "equipment": equipment,
      };
}
