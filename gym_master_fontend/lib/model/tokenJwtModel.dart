// To parse this JSON data, do
//
//     final tokenJwtModel = tokenJwtModelFromJson(jsonString);

import 'dart:convert';

TokenJwtModel tokenJwtModelFromJson(String str) =>
    TokenJwtModel.fromJson(json.decode(str));

String tokenJwtModelToJson(TokenJwtModel data) => json.encode(data.toJson());

class TokenJwtModel {
  String tokenJwt;

  TokenJwtModel({
    required this.tokenJwt,
  });

  factory TokenJwtModel.fromJson(Map<String, dynamic> json) => TokenJwtModel(
        tokenJwt: json["tokenJWT"] ?? ' ',
      );

  Map<String, dynamic> toJson() => {
        "tokenJWT": tokenJwt ?? ' ',
      };
}
