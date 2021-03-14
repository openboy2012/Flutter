// To parse this JSON data, do
//
//     final blServerInfo = blServerInfoFromJson(jsonString);

import 'dart:convert';

BlServerInfoResp blServerInfoFromJson(String str) => BlServerInfoResp.fromJson(json.decode(str));

String blServerInfoToJson(BlServerInfoResp data) => json.encode(data.toJson());

class BlServerInfoResp {
  BlServerInfoResp({
    this.msg,
    this.code,
    this.platformList,
  });

  String msg;
  int code;
  List<BLPlatformInfo> platformList;

  factory BlServerInfoResp.fromJson(Map<String, dynamic> json) => BlServerInfoResp(
    msg: json["msg"],
    code: json["code"],
    platformList: List<BLPlatformInfo>.from(json["serverList"].map((x) => BLPlatformInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "code": code,
    "platformList": List<dynamic>.from(platformList.map((x) => x.toJson())),
  };
}

class BLPlatformInfo
{
  BLPlatformInfo({
    this.name,
    this.platformId,
    this.serveList,
  });

  String name;
  String platformId;
  List<BLServerInfo> serveList;

  factory BLPlatformInfo.fromJson(Map<String, dynamic> json) => BLPlatformInfo(
    name: json["name"],
    platformId: json["id"],
    serveList:List<BLServerInfo>.from(json["value"].map((x) => BLServerInfo.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": this.platformId,
    // "value": value == null ? null : List<dynamic>.from(value.map((x) => x.toJson())),
  };
}

class BLServerInfo {
  BLServerInfo({
    this.name,
    this.serverId,
    this.nickname,
    this.roleId,
  });

  String name;
  String serverId;
  String nickname;
  String roleId;

  factory BLServerInfo.fromJson(Map<String, dynamic> json) => BLServerInfo(
    name: json["name"],
    serverId: json["id"],
    nickname: json["value"]["name"].toString(),
    roleId: json["value"]["id"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": this.serverId,
    // "value": value == null ? null : List<dynamic>.from(value.map((x) => x.toJson())),
  };
}
