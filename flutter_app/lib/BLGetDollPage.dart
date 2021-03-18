import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/APIs/BLApi.dart';
import 'package:flutter_app/Models/BLItemInfo.dart';
import 'package:flutter_app/Models/BLResponse.dart';
import 'package:flutter_app/Models/BLServerInfo.dart';

class BLGetDollPage extends StatefulWidget {
  BLGetDollPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _BLGetDollPage createState() => _BLGetDollPage();
}


class _BLGetDollPage extends State<BLGetDollPage> {

  String crystalNumber;
  Dio dio;

  void blLoginAction() async
  {
    Map<String, dynamic> headers = new Map();
    headers["token"] = BLApi.BL_WX_TOKEN;
    BaseOptions options = new BaseOptions(
      headers:headers,
      baseUrl:BLApi.BL_BASE_URL,
    );
    this.dio = new Dio(options);

    Map<String, dynamic> params = new Map();
    params["loginType"] = 0;
    // params["account"] = '1011550377';
    // params["passWord"] = 'asdf1234';
    params["account"] = '18657349251';
    params["passWord"] = 'dkl1234';
    // params["account"] = '18043172036';
    // params["passWord"] = 'renwei1234';
    // params["account"] = '1010473892';
    // params["passWord"] = 'liuyixian11';
    ///登陆账号
    Response responseLogin = await dio.post(BLApi.BL_USER_LOGIN, data: params);
    int code = BLResponse.fromJson(responseLogin.data).code;
    print("Account Login is " + code.toString());

    String roleName = "钻石爸比";
    // String roleName = "超光年";
    // String roleName = "打的狗子改名";
    // String roleName = "收活跃玩家";
    ///登陆成功
    if (code == 0) {
      ///获取绑定列表
      Response responseServer = await dio.get(BLApi.BL_SERVER_LIST);
      var serverList = BlServerInfoResp.fromJson(responseServer.data);

      var platformInfos = serverList.platformList;
      for (BLPlatformInfo platformInfo in platformInfos) {
        ///遍历平台信息
        if (platformInfo.name == "IOS") {
          for (BLServerInfo serverInfo in platformInfo.serveList) {
            ///判断是否是要刷分的昵称
            if (serverInfo.nickname == roleName)
            {
              Map<String, dynamic> params = new Map();
              params["phone"] = "18888888888";
              params["serverId"] = serverInfo.serverId;

              ///绑定账号内容
              Response responseBind = await dio.post(
                  BLApi.BL_USER_BIND_ROLE, data: params);

              print("BL user bind role is " + serverInfo.nickname + " is " +
                  BLResponse
                      .fromJson(responseBind.data)
                      .code
                      .toString());

              ///开始获取积分
              getDollAction();
            }
          }
        }
      }
    }

    // Response responseLogout = await dio.post(BLApi.BL_USER_LOGOUT);
    // code = BLResponse.fromJson(responseLogin.data).code;
    // print("Account Logout is " + code.toString());
  }

  void getDollAction () async
  {
    ///获取绑定列表
    Response responseItemInfo = await this.dio.get(BLApi.BL_USER_DOLL_INFO);
    var blItemInfoResp = BLItemInfoResp.fromGetItemJson(responseItemInfo.data);
    BLItemInfo info = blItemInfoResp.itemInfo;
    print("刷分前的信息[积分:" + info.point.toString() +
          "蓝染娃娃:" + info.dolllr.toString() +
          "白哉娃娃:" + info.dollbz.toString() + "]");
    bool needContinue = true;
    int dollType = 2; ///先摇白哉
    int crystalNumber = 15; ///想要摇的水晶数量
    do {
      Response responseGeDoll = await dio.post(BLApi.BL_GET_DOLL, data:{"type":dollType});
      blItemInfoResp = BLItemInfoResp.fromGetDollJson(responseGeDoll.data);
      if (blItemInfoResp.code == 0) { ///请求成功
          ///蓝染
          if (dollType == 3) {
            ///没有刷到娃娃，但是成功，需要退出循环
            if (blItemInfoResp.itemInfo.dolllr != info.dolllr + 1)
            {
              needContinue = false;
              print("刷到环，任务强制结束 [积分:" + info.point.toString() +
                  " 蓝染娃娃数量:" + info.dolllr.toString() +
                  " 白哉娃娃数量:" + info.dollbz.toString() + "]"
              );
            }
            else {
              info = blItemInfoResp.itemInfo;
              print("刷到一个蓝染 [积分:" + info.point.toString() +
                  " 蓝染娃娃数量:" + info.dolllr.toString() +
                  " 白哉娃娃数量:" + info.dollbz.toString() + "]"
              );
              if (info.dolllr < 3 * crystalNumber) {
                dollType = 3;
              }
              else {
                needContinue = false;
                print("完成刷分任务[积分:" + info.point.toString() +
                    " 蓝染娃娃数量:" + info.dolllr.toString() +
                    " 白哉娃娃数量:" + info.dollbz.toString() + "]"
                );
              }
            }
          }
          ///白哉
          else {
            ///没有刷到娃娃，但是成功，需要退出循环
            if (blItemInfoResp.itemInfo.dollbz != info.dollbz + 1)
            {
              print("刷到环，任务强制结束 [积分:" + info.point.toString() +
                  " 蓝染娃娃数量:" + info.dolllr.toString() +
                  " 白哉娃娃数量:" + info.dollbz.toString() + "]"
              );
              needContinue = false;
            }
            else {
              info = blItemInfoResp.itemInfo;
              print("刷到一个白哉 [积分:" + info.point.toString() +
                  " 蓝染娃娃数量:" + info.dolllr.toString() +
                  " 白哉娃娃数量:" + info.dollbz.toString() + "]"
              );
              if (info.dollbz < 4 * crystalNumber) {
                dollType = 2;
              }
              else {
                dollType = 3;
                print("更新刷新蓝染娃娃 [积分:" + info.point.toString() +
                    " 蓝染娃娃数量:" + info.dolllr.toString() +
                    " 白哉娃娃数量:" + info.dollbz.toString() + "]"
                );
              }
            }
          }
      }
      else {
        print("继续刷分:"+ blItemInfoResp.code.toString() + " msg:" +blItemInfoResp.msg);
      }
    }
    while (info.point > 0 && needContinue);
  }


  FlatButton loginFlatButton(){
    return FlatButton(
      onPressed: blLoginAction,
      child: Text("登陆账号"),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  FlatButton getDollFlatButton(){
    return FlatButton(
      onPressed: getDollAction,
      child: Text("开始刷新娃娃"),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  ListView _listView() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        TextField(),
        TextField(),
        TextField(),
        loginFlatButton(),
        // Text(crystalNumber),
        TextField(),
        getDollFlatButton(),
      ],
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
        title: Text("死神激斗刷娃娃"),
      ),
      body: _listView(),
    );
  }
}