// To parse this JSON data, do
//
//     final weeksDiffModel = weeksDiffModelFromJson(jsonString);

import 'dart:convert';

List<WeeksDiffModel> weeksDiffModelFromJson(String str) => List<WeeksDiffModel>.from(json.decode(str).map((x) => WeeksDiffModel.fromJson(x)));

String weeksDiffModelToJson(List<WeeksDiffModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WeeksDiffModel {
    int weeksDiff;

    WeeksDiffModel({
        required this.weeksDiff,
    });

    factory WeeksDiffModel.fromJson(Map<String, dynamic> json) => WeeksDiffModel(
        weeksDiff: json["weeks_diff"],
    );

    Map<String, dynamic> toJson() => {
        "weeks_diff": weeksDiff,
    };
}
