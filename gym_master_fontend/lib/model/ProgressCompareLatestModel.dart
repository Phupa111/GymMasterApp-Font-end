// To parse this JSON data, do
//
//     final progressCompareLatestModel = progressCompareLatestModelFromJson(jsonString);

import 'dart:convert';

List<ProgressCompareLatestModel> progressCompareLatestModelFromJson(
        String str) =>
    List<ProgressCompareLatestModel>.from(
        json.decode(str).map((x) => ProgressCompareLatestModel.fromJson(x)));

String progressCompareLatestModelToJson(
        List<ProgressCompareLatestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProgressCompareLatestModel {
  int pid;
  int uid;
  String picture;
  String dataProgress;

  ProgressCompareLatestModel({
    required this.pid,
    required this.uid,
    required this.picture,
    required this.dataProgress,
  });

  factory ProgressCompareLatestModel.fromJson(Map<String, dynamic> json) =>
      ProgressCompareLatestModel(
        pid: json["pid"],
        uid: json["uid"],
        picture: json["picture"],
        dataProgress: json["data_progress"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "uid": uid,
        "picture": picture,
        "data_progress": dataProgress,
      };
}
