// To parse this JSON data, do
//
//     final blResponse = blResponseFromJson(jsonString);

import 'dart:convert';

blResponseFromJson(String str) => BLResponse.fromJson(json.decode(str));

String blResponseToJson(BLResponse data) => json.encode(data.toJson());

class BLResponse {
  BLResponse({
    this.msg,
    this.code,
  });

  String msg;
  int code;

  factory BLResponse.fromJson(Map<String, dynamic> json) => BLResponse(
    msg: json["msg"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "code": code,
  };
}