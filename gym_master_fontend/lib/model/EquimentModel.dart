// To parse this JSON data, do
//
//     final eqiumentModel = eqiumentModelFromJson(jsonString);

import 'dart:convert';

List<EqiumentModel> eqiumentModelFromJson(String str) =>
    List<EqiumentModel>.from(
        json.decode(str).map((x) => EqiumentModel.fromJson(x)));

String eqiumentModelToJson(List<EqiumentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EqiumentModel {
  int eqid;
  String name;
  String photo;

  EqiumentModel({
    required this.eqid,
    required this.name,
    required this.photo,
  });

  factory EqiumentModel.fromJson(Map<String, dynamic> json) => EqiumentModel(
        eqid: json["eqid"],
        name: json["Name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "eqid": eqid,
        "Name": name,
        "photo": photo,
      };
}
