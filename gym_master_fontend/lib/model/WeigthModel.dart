import 'dart:convert';

List<WeightModel> weightModelFromJson(String str) => List<WeightModel>.from(
    json.decode(str).map((x) => WeightModel.fromJson(x)));

String weightModelToJson(List<WeightModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WeightModel {
  double weight;
  DateTime dataProgressThai;

  WeightModel({
    required this.weight,
    required this.dataProgressThai,
  });

  factory WeightModel.fromJson(Map<String, dynamic> json) => WeightModel(
        weight: json["weight"]?.toDouble(),
        dataProgressThai: DateTime.parse(json["data_progress_thai"]),
      );

  Map<String, dynamic> toJson() => {
        "weight": weight,
        "data_progress_thai": dataProgressThai.toIso8601String(),
      };
}
