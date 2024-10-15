// To parse this JSON data, do
//
//     final equipmentModel = equipmentModelFromJson(jsonString);

import 'dart:convert';

List<EquipmentModel> equipmentModelFromJson(String str) =>
    List<EquipmentModel>.from(
        json.decode(str).map((x) => EquipmentModel.fromJson(x)));

String equipmentModelToJson(List<EquipmentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EquipmentModel {
  int eqid;
  String name;

  EquipmentModel({
    required this.eqid,
    required this.name,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) => EquipmentModel(
        eqid: json["eqid"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "eqid": eqid,
        "Name": name,
      };
}
