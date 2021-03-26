import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/APIs/BLApi.dart';
import 'package:flutter_app/Models/BLResponse.dart';
import 'package:flutter_app/Models/BLServerInfo.dart';
import 'package:flutter_app/Models/BLItemInfo.dart';
import 'dart:io';

class SecondPage extends StatefulWidget {
  SecondPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SecondPage createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {

  static Map<String, dynamic> serverKeyValues = {"18657349251":"流魂街51区",
    "18043172036":"流魂街52区","1010473892":"流魂街103区","1011550377":"流魂街51区"};

  String _printText = "开始领取积分";
  Dio dio;
  var blAccounts = [];

  void _blGetPointAction() async
  {
    Map<String, dynamic> headers = new Map();
    headers["token"] = BLApi.BL_WX_TOKEN;
    BaseOptions options = new BaseOptions(
      headers:headers,
      baseUrl:BLApi.BL_BASE_URL,
    );

    _printText = "开始领取积分";

    this.dio = new Dio(options);
    preparedBLUser();
    for (Map<String, dynamic> params in this.blAccounts) {
      ///登陆账号
      Response responseLogin = await this.dio.post(BLApi.BL_USER_LOGIN, data: params);
      int code = BLResponse.fromJson(responseLogin.data).code;
      blPrintTextView("账号登陆状态:" + code.toString());
      ///登陆成功
      if (code == 0) {
        await doUserGetPoint(this.dio, params["account"]);
      }

      Response responseLogout = await this.dio.post(BLApi.BL_USER_LOGOUT);
      code = BLResponse.fromJson(responseLogout.data).code;
      blPrintTextView("账号登出状态:" + code.toString());
    }
  }

  void preparedBLUser() {
    var accounts = [];
    Map<String, dynamic> params = new Map();
    params["loginType"] = 0;
    params["account"] = '1011550377';
    params["passWord"] = 'asdf1234';
    accounts.add(params);
    params = new Map();
    params["loginType"] = 0;
    params["account"] = '18657349251';
    params["passWord"] = 'dkl1234';
    accounts.add(params);
    params = new Map();
    params["loginType"] = 0;
    params["account"] = '18043172036';
    params["passWord"] = 'renwei1234';
    accounts.add(params);
    params = new Map();
    params["loginType"] = 0;
    params["account"] = '1010473892';
    params["passWord"] = 'liuyixian11';
    accounts.add(params);
    this.blAccounts = accounts;
  }

  void blPrintTextView(String line) {
    setState(() {
      _printText = _printText + "\n";
      _printText = _printText + line;
    });
    print(line);
  }

  Future doUserGetPoint (Dio dio, String account) async
  {
    ///获取绑定列表
    Response responseServer = await dio.get(BLApi.BL_SERVER_LIST);
    var serverList = BlServerInfoResp.fromJson(responseServer.data);

    var platformInfos = serverList.platformList;
    for (BLPlatformInfo platformInfo in platformInfos) {
      ///遍历平台信息
      if (platformInfo.name == "IOS") {
        for (BLServerInfo serverInfo in platformInfo.serveList) {
          ///匹配正确的账号信息
          if (serverInfo.name == serverKeyValues[account]) {
            Map<String, dynamic> params = new Map();
            params["phone"] = "18888888888";
            params["serverId"] = serverInfo.serverId;

            ///绑定账号内容
            Response responseBind = await dio.post(
                BLApi.BL_USER_BIND_ROLE, data: params);

            blPrintTextView("当前绑定的游戏昵称:" + serverInfo.nickname + " 绑定结果:" +
                BLResponse
                    .fromJson(responseBind.data)
                    .code
                    .toString());

            ///开始获取积分
            await getAllPointByUser(dio, serverInfo.nickname);
          }
        }
      }
    }
  }

  void _blCircleAction() async {
    Map<String, dynamic> headers = new Map();
    BaseOptions options = new BaseOptions(
      baseUrl:BLApi.BLZP_BASE_URL,
    );

    _printText = "开始转盘";

    this.dio = new Dio(options);
    preparedBLUser();
    for (Map<String, dynamic> params in this.blAccounts) {
      params["openId"] = BLApi.BLZP_WX_OPEN_ID;
      ///登陆账号
      Response responseLogin = await this.dio.post(BLApi.BLZP_USER_LOGIN, data: params);
      int code = BLResponse.fromJson(responseLogin.data).code;
      blPrintTextView("账号登陆状态:" + code.toString());
      ///登陆成功
      if (code == 0) {
        await doUserGetZPPoint(this.dio, params["account"]);
      }

      Response responseLogout = await this.dio.post(BLApi.BLZP_USER_LOGOUT, data: BLApi.BLZP_WX_OPEN_ID);
      blPrintTextView("账号登出状态:" + responseLogout.toString());
    }
  }

  Future doUserGetZPPoint (Dio dio, String account) async
  {
    ///获取绑定列表
    Response responseServer = await dio.get(BLApi.BLZP_SERVER_LIST, queryParameters:{"openId":BLApi.BLZP_WX_OPEN_ID});
    var serverList = BlServerInfoResp.fromZPJson(responseServer.data);

    var list = serverList.serverList;

    for (BLServerInfo serverInfo in list) {
      ///匹配正确的账号信息
      if (serverInfo.name == serverKeyValues[account]) {
        Map<String, dynamic> params = new Map();
        params["phone"] = "18888888888";
        params["serverId"] = serverInfo.serverId;
        params["openId"] = BLApi.BLZP_WX_OPEN_ID;

        ///绑定账号内容
        Response responseBind = await dio.post(
            BLApi.BLZP_USER_BIND_ROLE, data: params);

        blPrintTextView("当前绑定的游戏昵称:" + serverInfo.nickname + " 绑定结果:" +
            BLResponse
                .fromJson(responseBind.data)
                .code
                .toString());

        ///开始获取积分
        await getAllPointThanPlayByUser(dio, serverInfo.nickname);
      }
    }
  }

  Future getAllPointThanPlayByUser(dio, String nickname) async
  {
    ///按照类型开始领取积分
    for (int i = 1; i < 4; i++)
    {
      Response responsePoint = await dio.post(BLApi.BLZP_GET_CHAGNE, data: {"type":i,"openId":BLApi.BLZP_WX_OPEN_ID});
      BLResponse response = BLResponse.fromJson(responsePoint.data);
      blPrintTextView(nickname + " 获取转盘机会 类型:" + i.toString() + " 结果:" + response.code.toString() + " 消息:" + response.msg);
    }

    for (int j = 0; j < 3; j++)
    {
      await Future.delayed(Duration(milliseconds: 500 * j), () async{
        Response responseUseChange = await this.dio.post(BLApi.BLZP_USE_CHNAGE, data:BLApi.BLZP_WX_OPEN_ID);
        BLUseChanceResp resp = BLUseChanceResp.fromJson(responseUseChange.data);
        blPrintTextView(nickname + " 摇转盘结果:" + resp.code.toString() + " 消息:" + resp.msg + " 奖励:" + resp.itemName);
      });
    }
  }

  ///获取积分
  Future getAllPointByUser (Dio dio, String nickname) async
  {
    ///按照类型开始领取积分
    for (int i = 0; i < 5; i++)
    {
      Response responsePoint = await dio.post(BLApi.BL_GET_POINT, data: {"type":i});
      BLResponse response = BLResponse.fromJson(responsePoint.data);
      blPrintTextView(nickname + " getPoint type:" + i.toString() + " Result:" + response.code.toString() + " msg:" + response.msg);
      ///没登陆过游戏的，跳出循环
      // if (response.code != 0 && i == 0)
      // {
      //   break;
      // }
    }

    ///获取已经获得的娃娃信息
    Response responseItemInfo = await dio.get(BLApi.BL_USER_DOLL_INFO);
    var blItemInfoResp = BLItemInfoResp.fromGetItemJson(responseItemInfo.data);
    BLItemInfo info = blItemInfoResp.itemInfo;
    blPrintTextView("当前账号的信息[积分:" + info.point.toString() +
        "蓝染娃娃:" + info.dolllr.toString() +
        "白哉娃娃:" + info.dollbz.toString() + "]");
  }

  TextButton getPointTextButton(){
    return TextButton(
      onPressed: _blGetPointAction,
      child: Text("自动领取积分"),
      style: ButtonStyle(
        ///更优美的方式来设置
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            //按下时的颜色
            return Colors.red;
          }
          //默认状态使用灰色
          return Colors.white;
        },
        ),
        ///背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return Colors.purple[200];
          }
          //默认不使用背景颜色
          return Colors.blue;
        }),
      ),
    );
  }

  TextButton circleTextButton () {
    return TextButton(
      onPressed: _blCircleAction,
      child: Text("自动转盘处理"),
      style: ButtonStyle(
        ///更优美的方式来设置
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            //按下时的颜色
            return Colors.red;
          }
          //默认状态使用灰色
          return Colors.white;
        },
        ),
        ///背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return Colors.purple[200];
          }
          //默认不使用背景颜色
          return Colors.blue;
        }),
      ),
    );
  }

  ListView _columns() {
    return ListView(
        padding: EdgeInsets.all(20),
        children: [
          getPointTextButton(),
          circleTextButton(),
          Text(_printText, style: TextStyle(color: Colors.black54),),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("死神激斗领取积分"),
      ),
      body: _columns(),
    );
  }
}