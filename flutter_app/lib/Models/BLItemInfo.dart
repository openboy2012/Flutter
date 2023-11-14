// To parse this JSON data, do
//
//     final blItemInfoFromJson = blResponseFromJson(jsonString);

import 'dart:convert';

blItemInfoFromJson(String str) => BLItemInfo.fromJson(json.decode(str));

String blItemInfoToJson(BLItemInfo data) => json.encode(data.toJson());

class BLItemInfoResp {
  BLItemInfoResp({
    required this.msg,
    required this.code,
    required this.itemInfo,
  });

  String msg;
  int code;
  BLItemInfo itemInfo;

  factory BLItemInfoResp.fromGetItemJson(Map<String, dynamic> json) =>
      BLItemInfoResp(
        msg: json["msg"],
        code: json["code"],
        itemInfo: BLItemInfo.fromJson(json["itemInfo"]),
      );

  factory BLItemInfoResp.fromGetDollJson(Map<String, dynamic> json) =>
      BLItemInfoResp(
        msg: json["msg"],
        code: json["code"],
        itemInfo: BLItemInfo.fromJson(json["newItemInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "code": code,
      };
}

class BLItemInfo {
  BLItemInfo({
    required this.dollbz,
    required this.dolllr,
    required this.point,
  });

  ///朽木白哉的娃娃数量
  int dollbz;

  ///蓝染惣右介的娃娃数量
  int dolllr;

  ///剩余保存的积分
  int point;

  factory BLItemInfo.fromJson(Map<String, dynamic> json) => BLItemInfo(
        dollbz: json["doll3"],
        dolllr: json["doll4"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        // "msg": msg,
        // "code": code,
      };
}
