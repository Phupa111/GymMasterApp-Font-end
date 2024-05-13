// To parse this JSON data, do
//
//     final tabelModel = tabelModelFromJson(jsonString);

import 'dart:convert';

List<TabelModel> tabelModelFromJson(String str) => List<TabelModel>.from(json.decode(str).map((x) => TabelModel.fromJson(x)));

String tabelModelToJson(List<TabelModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    });

    factory TabelModel.fromJson(Map<String, dynamic> json) => TabelModel(
        tid: json["tid"],
        uid: json["uid"],
        couserName: json["couserName"],
        times: json["times"],
        gender: json["gender"],
        level: json["level"],
        description: json["description"],
        isCreateByAdmin: json["isCreateByAdmin"],
        dayPerWeek: json["dayPerWeek"],
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
    };
}
