// To parse this JSON data, do
//
//     final tabelEnModel = tabelEnModelFromJson(jsonString);

import 'dart:convert';

List<TabelEnModel> tabelEnModelFromJson(String str) => List<TabelEnModel>.from(json.decode(str).map((x) => TabelEnModel.fromJson(x)));

String tabelEnModelToJson(List<TabelEnModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TabelEnModel {
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
    int count;

    TabelEnModel({
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
        required this.count,
    });

    factory TabelEnModel.fromJson(Map<String, dynamic> json) => TabelEnModel(
        tid: json["tid"],
        uid: json["uid"],
        couserName: json["couserName"],
        times: json["times"],
        gender: json["gender"],
        level: json["level"],
        description: json["description"],
        isCreateByAdmin: json["isCreateByAdmin"],
        dayPerWeek: json["dayPerWeek"],
        timeRest: json["time_rest"],
        count: json["count"],
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
        "count": count,
    };
}
