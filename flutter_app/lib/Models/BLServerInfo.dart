// To parse this JSON data, do
//
//     final blServerInfo = blServerInfoFromJson(jsonString);

import 'dart:convert';

BlServerInfo blServerInfoFromJson(String str) => BlServerInfo.fromJson(json.decode(str));

String blServerInfoToJson(BlServerInfo data) => json.encode(data.toJson());

class BlServerInfo {
  BlServerInfo({
    this.msg,
    this.code,
    this.serverList,
  });

  String msg;
  int code;
  List<ServerList> serverList;

  factory BlServerInfo.fromJson(Map<String, dynamic> json) => BlServerInfo(
    msg: json["msg"],
    code: json["code"],
    serverList: List<ServerList>.from(json["serverList"].map((x) => ServerList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "code": code,
    "serverList": List<dynamic>.from(serverList.map((x) => x.toJson())),
  };
}

class ServerList {
  ServerList({
    this.name,
    this.id,
    this.value,
  });

  String name;
  String id;
  List<ServerList> value;

  factory ServerList.fromJson(Map<String, dynamic> json) => ServerList(
    name: json["name"],
    id: json["id"],
    value: json["value"] == null ? null : List<ServerList>.from(json["value"].map((x) => ServerList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "value": value == null ? null : List<dynamic>.from(value.map((x) => x.toJson())),
  };
}
