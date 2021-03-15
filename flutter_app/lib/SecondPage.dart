import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_app/APIs/BLApi.dart';
import 'package:flutter_app/Models/BLResponse.dart';
import 'package:flutter_app/Models/BLServerInfo.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

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

class BL2CookieApi {
  //改为使用 PersistCookieJar，在文档中有介绍，PersistCookieJar将cookie保留在文件中，因此，如果应用程序退出，则cookie始终存在，除非显式调用delete
  static PersistCookieJar _cookieJar;
  static Future<PersistCookieJar> get cookieJar async {
    // print(_cookieJar);
    if (_cookieJar == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath  = appDocDir.path;
      print('获取的文件系统目录 appDocPath： ' + appDocPath);
      _cookieJar = new PersistCookieJar(dir: appDocPath);
    }
    return _cookieJar;
  }
}

class _SecondPage extends State<SecondPage> {
  int _counter = 0;

  String responseText;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;

    });
  }


  void _blLoginAction() async
  {
    Map<String, dynamic> headers = new Map();
    headers["token"] = BLApi.BL_WX_TOKEN;
    BaseOptions options = new BaseOptions(
      headers:headers,
      baseUrl:BLApi.BL_BASE_URL,
    );
    Dio dio = new Dio(options);
    Map<String, dynamic> params = new Map();
    params["loginType"] = 0;
    params["account"] = '1011550377';
    params["passWord"] = 'asdf1234';
    // params["account"] = '18657349251';
    // params["passWord"] = 'dkl1234';
    // params["account"] = '18043172036';
    // params["passWord"] = 'renwei1234';
    // params["account"] = '1010473892';
    // params["passWord"] = 'liuyixian11';
    ///登陆账号
    Response response = await dio.post(BLApi.BL_USER_LOGIN, data: params);
    print("Account Login is" + response.data.toString());

    ///获取绑定列表
    Response responseServer = await dio.get(BLApi.BL_SERVER_LIST);
    print("ServerList is" + responseServer.data.toString());
    var serverList = BlServerInfoResp.fromJson(responseServer.data);

    var platformInfos = serverList.platformList;
    for (BLPlatformInfo platformInfo in platformInfos)
    {
      ///遍历平台信息
      if(platformInfo.name == "IOS")
      {
        for (BLServerInfo serverInfo in platformInfo.serveList)
        {
          Map<String, dynamic> params = new Map();
          params["phone"] = "18888888888";
          params["serverId"] = serverInfo.serverId;
          ///绑定账号内容
          Response responseBind = await dio.post(BLApi.BL_USER_BIND_ROLE, data:params);

          print("BL user bind role is " + serverInfo.nickname + " is " + BLResponse.fromJson(responseBind.data).code.toString());
          ///开始获取积分
          await getAllPoint(dio, serverInfo.nickname);
        }
      }
    }
  }

  ///获取积分
  void getAllPoint (Dio dio, String nickname) async
  {
    ///按照类型开始领取积分
    for (int i = 0; i < 5; i++)
    {
      Response responsePoint = await dio.post(BLApi.BL_GET_POINT, data: {"type":i});
      print(nickname + " getPoint type is " + i.toString() + " Reuslt is " + BLResponse.fromJson(responsePoint.data).code.toString());
    }

    ///获取已经获得的娃娃信息
    // Response responseGetPoint = await dio.get(BLApi.BL_USER_DOLL_INFO);
    // print("Point Info is" + responseGetPoint.data.toString());
  }

  FlatButton normalFlatButton(){
    return FlatButton(
      onPressed: _blLoginAction,
      child: Text("自动领取积分"),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  Column _shapeColumn(){
    return Column(
      children: [
        Container(
          height: 30,
          alignment: Alignment.center,
          child: Text('shape button'),
        ),
        FlatButton(
          color: Colors.grey,
          textColor: Colors.white,
          onPressed: _blLoginAction,
          child: Container(
            height: 100,
            width: 100,
            child: Text('圆的'),
            alignment: Alignment.center,
          ),
          shape: CircleBorder(
            side: BorderSide(
              width: 2,
              color: Colors.red,
              style: BorderStyle.solid,
              // style: BorderStyle.none,
            ),
          ),
        ),
      ],
    );
  }

  ListView _listView() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        normalFlatButton(),
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
        title: Text("死神激斗领取积分"),
      ),
      body: _listView(),
    );
  }
}