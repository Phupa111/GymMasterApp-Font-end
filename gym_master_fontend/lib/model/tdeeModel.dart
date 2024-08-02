// To parse this JSON data, do
//
//     final tdeeModel = tdeeModelFromJson(jsonString);

import 'dart:convert';

List<TdeeModel> tdeeModelFromJson(String str) =>
    List<TdeeModel>.from(json.decode(str).map((x) => TdeeModel.fromJson(x)));

String tdeeModelToJson(List<TdeeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TdeeModel {
  int bulking;
  int maintenance;
  int cutting;
  int bulkCarbGram;
  int bulkProteinGram;
  int bulkFatGram;
  int mainCarbGram;
  int mainProteinGram;
  int mainFatGram;
  int cutCarbGram;
  int cutProteinGram;
  int cutFatGram;

  TdeeModel({
    required this.bulking,
    required this.maintenance,
    required this.cutting,
    required this.bulkCarbGram,
    required this.bulkProteinGram,
    required this.bulkFatGram,
    required this.mainCarbGram,
    required this.mainProteinGram,
    required this.mainFatGram,
    required this.cutCarbGram,
    required this.cutProteinGram,
    required this.cutFatGram,
  });

  factory TdeeModel.fromJson(Map<String, dynamic> json) => TdeeModel(
        bulking: json["bulking"],
        maintenance: json["maintenance"],
        cutting: json["cutting"],
        bulkCarbGram: json["bulk_carb_gram"],
        bulkProteinGram: json["bulk_protein_gram"],
        bulkFatGram: json["bulk_fat_gram"],
        mainCarbGram: json["main_carb_gram"],
        mainProteinGram: json["main_protein_gram"],
        mainFatGram: json["main_fat_gram"],
        cutCarbGram: json["cut_carb_gram"],
        cutProteinGram: json["cut_protein_gram"],
        cutFatGram: json["cut_fat_gram"],
      );

  Map<String, dynamic> toJson() => {
        "bulking": bulking,
        "maintenance": maintenance,
        "cutting": cutting,
        "bulk_carb_gram": bulkCarbGram,
        "bulk_protein_gram": bulkProteinGram,
        "bulk_fat_gram": bulkFatGram,
        "main_carb_gram": mainCarbGram,
        "main_protein_gram": mainProteinGram,
        "main_fat_gram": mainFatGram,
        "cut_carb_gram": cutCarbGram,
        "cut_protein_gram": cutProteinGram,
        "cut_fat_gram": cutFatGram,
      };
}
