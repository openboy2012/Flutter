// To parse this JSON data, do
//
//     final blServerInfo = blServerInfoFromJson(jsonString);

import 'dart:convert';

BlServerInfoResp blServerInfoFromJson(String str) =>
    BlServerInfoResp.fromJson(json.decode(str));

String blServerInfoToJson(BlServerInfoResp data) => json.encode(data.toJson());

class BlServerInfoResp {
  BlServerInfoResp({
    required this.msg,
    required this.code,
    this.platformList,
    this.serverList,
  });

  String msg;
  int code;
  List<BLPlatformInfo>? platformList;
  List<BLServerInfo>? serverList;

  factory BlServerInfoResp.fromJson(Map<String, dynamic> json) =>
      BlServerInfoResp(
        msg: json["msg"],
        code: json["code"],
        platformList: List<BLPlatformInfo>.from(
            json["serverList"].map((x) => BLPlatformInfo.fromJson(x))),
        serverList: null,
      );

  factory BlServerInfoResp.fromZPJson(Map<String, dynamic> json) =>
      BlServerInfoResp(
        msg: json["msg"],
        code: json["code"],
        platformList: null,
        serverList: List<BLServerInfo>.from(json["server"]["IOS"]["流魂街"]
            .map((x) => BLServerInfo.fromZPJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "code": code,
      };
}

class BLPlatformInfo {
  BLPlatformInfo({
    required this.name,
    required this.platformId,
    required this.serveList,
  });

  String name;
  String platformId;
  List<BLServerInfo> serveList;

  factory BLPlatformInfo.fromJson(Map<String, dynamic> json) => BLPlatformInfo(
      name: json["name"],
      platformId: json["id"],
      serveList: List<BLServerInfo>.from(
          json["value"].map((x) => BLServerInfo.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": this.platformId,
        // "value": value == null ? null : List<dynamic>.from(value.map((x) => x.toJson())),
      };
}

class BLServerInfo {
  BLServerInfo({
    ///服务器名称
    required this.name,

    ///服务器id
    required this.serverId,

    ///游戏昵称
    required this.nickname,

    ///角色id
    this.roleId,
  });

  late String name;
  late String serverId;
  late String nickname;
  late String? roleId;

  factory BLServerInfo.fromJson(Map<String, dynamic> json) => BLServerInfo(
        name: json["name"],
        serverId: json["id"],
        nickname: json["value"][0]["name"],
        roleId: json["value"][0]["id"],
      );

  factory BLServerInfo.fromZPJson(Map<String, dynamic> json) => BLServerInfo(
      name: json["serverName"],
      serverId: json["serverId"].toString(),
      nickname: json["roleName"],
      roleId: null);

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": this.serverId,
        // "value": value == null ? null : List<dynamic>.from(value.map((x) => x.toJson())),
      };
}
