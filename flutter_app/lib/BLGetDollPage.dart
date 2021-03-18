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
    params["account"] = '1011550377';
    params["passWord"] = 'asdf1234';
    ///登陆账号
    Response responseLogin = await dio.post(BLApi.BL_USER_LOGIN, data: params);
    int code = BLResponse.fromJson(responseLogin.data).code;
    print("Account Login is " + code.toString());
    ///登陆成功
    if (code == 0) {
      // doUserGetDoll(this.dio, params["account"]);
    }

    // Response responseLogout = await dio.post(BLApi.BL_USER_LOGOUT);
    // code = BLResponse.fromJson(responseLogin.data).code;
    // print("Account Logout is " + code.toString());
  }

  void getDollAction () async
  {
    ///获取绑定列表
    Response responseItemInfo = await this.dio.get(BLApi.BL_USER_DOLL_INFO);
    print("BL ItemInfo is " + responseItemInfo.data.toString());
    var blItemInfoResp = BLItemInfoResp.fromGetItemJson(responseItemInfo.data);
    print("BL ItemInfo is " + blItemInfoResp.toString());

    BLItemInfo info = blItemInfoResp.itemInfo;
    bool needContinue = true;
    int dollType = 2;
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
            }
            else {
              info = blItemInfoResp.itemInfo;
            }
          }
          ///白哉
          else {
            ///没有刷到娃娃，但是成功，需要退出循环
            if (blItemInfoResp.itemInfo.dollbz != info.dollbz + 1)
            {
              needContinue = false;
            }
            else {
              info = blItemInfoResp.itemInfo;
            }
          }
      }
      else {
        print("继续刷分");
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