// To parse this JSON data, do
//
//     final progressCompareModel = progressCompareModelFromJson(jsonString);

import 'dart:convert';

List<ProgressCompareModel> progressCompareModelFromJson(String str) =>
    List<ProgressCompareModel>.from(
        json.decode(str).map((x) => ProgressCompareModel.fromJson(x)));

String progressCompareModelToJson(List<ProgressCompareModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProgressCompareModel {
  int pid;
  int uid;
  int isBefore;
  String picture;
  String dataProgress;

  ProgressCompareModel({
    required this.pid,
    required this.uid,
    required this.isBefore,
    required this.picture,
    required this.dataProgress,
  });

  factory ProgressCompareModel.fromJson(Map<String, dynamic> json) =>
      ProgressCompareModel(
        pid: json["pid"],
        uid: json["uid"],
        isBefore: json["isBefore"],
        picture: json["picture"],
        dataProgress: json["data_progress"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "uid": uid,
        "isBefore": isBefore,
        "picture": picture,
        "data_progress": dataProgress,
      };
}
