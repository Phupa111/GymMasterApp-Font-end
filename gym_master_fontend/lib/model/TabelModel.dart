import 'dart:convert';

List<TabelModel> tabelModelFromJson(String str) =>
    List<TabelModel>.from(json.decode(str).map((x) => TabelModel.fromJson(x)));

String tabelModelToJson(List<TabelModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TabelModel {
  int tid;
  int uid;
  String couserName;
  int times;
  int gender;
  int level;
  String description;
  int isCreateByAdmin;
  int dayPerWeek;
  int timeRest;

  TabelModel({
    required this.tid,
    required this.uid,
    required this.couserName,
    required this.times,
    required this.gender,
    required this.level,
    required this.description,
    required this.isCreateByAdmin,
    required this.dayPerWeek,
     required this.timeRest,
  });

  factory TabelModel.fromJson(Map<String, dynamic> json) => TabelModel(
        tid: json["tid"] ?? 0,
        uid: json["uid"] ?? 0,
        couserName: json["couserName"] ?? '',
        times: json["times"] ?? 0,
        gender: json["gender"] ?? 0,
        level: json["level"] ?? 0,
        description: json["description"] ?? '',
        isCreateByAdmin: json["isCreateByAdmin"] ?? 0,
        dayPerWeek: json["dayPerWeek"] ?? 0,
        timeRest: json["time_rest"]??0,
      );

  Map<String, dynamic> toJson() => {
        "tid": tid,
        "uid": uid,
        "couserName": couserName,
        "times": times,
        "gender": gender,
        "level": level,
        "description": description,
        "isCreateByAdmin": isCreateByAdmin,
        "dayPerWeek": dayPerWeek,
        "time_rest": timeRest,
      };
}
