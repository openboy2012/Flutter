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

class BLUseChanceResp {
  BLUseChanceResp ({
    this.msg,
    this.code,
    this.drawResult,
    this.itemName,
    this.canDrawCount,
    this.useDrawCount,
  });

  String msg;
  int code;
  int drawResult;
  String itemName;
  int canDrawCount;
  int useDrawCount;

  factory BLUseChanceResp.fromJson(Map<String, dynamic> json) => BLUseChanceResp(
    msg: json["msg"],
    code: json["code"],
    drawResult: json["drawResult"] == null ? null : json["drawResult"],
    itemName: json["itemName"] == null ? "无" : json["itemName"],
  );

  factory BLUseChanceResp.fromBaseJson(Map<String, dynamic> json) => BLUseChanceResp(
    msg: json["msg"],
    code: json["code"],
    useDrawCount: json["useDrawCount"],
    canDrawCount: json["canDrawCount"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "code": code,
  };
}