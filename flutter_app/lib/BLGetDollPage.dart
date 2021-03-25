import 'package:flutter/cupertino.dart';
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

  num _crystalNumber;
  String _account;
  String _password;
  String _nickname;
  String _printText = "准备刷分";
  BLItemInfoResp loginResp;
  Dio dio;

  void blPrintTextView(String line) {
    setState(() {
      _printText = _printText + "\n";
      _printText = _printText + line;
    });
    print(line);
  }

  void blLoginAction() async
  {

    _printText = "准备刷分";

    if (_account == null ||
        _password == null ||
        _account.length == 0 ||
        _password.length == 0) {
      blPrintTextView("请输入账号密码");
      return;
    }

    Map<String, dynamic> headers = new Map();
    headers["token"] = BLApi.BL_WX_TOKEN;
    BaseOptions options = new BaseOptions(
      headers:headers,
      baseUrl:BLApi.BL_BASE_URL,
    );
    this.dio = new Dio(options);

    Map<String, dynamic> params = new Map();
    params["loginType"] = 0;
    params["account"] = _account;
    params["passWord"] = _password;
    // params["account"] = '13575819592';
    // params["passWord"] = 'bz123456';
    // params["account"] = '18657349251';
    // params["passWord"] = 'dkl1234';
    // params["account"] = '18043172036';
    // params["passWord"] = 'renwei1234';
    // params["account"] = '1010473892';
    // params["passWord"] = 'liuyixian11';
    // params["account"] = '1009872400';
    // params["passWord"] = 'zzz56789';
    ///登陆账号
    Response responseLogin = await dio.post(BLApi.BL_USER_LOGIN, data: params);
    int code = BLResponse.fromJson(responseLogin.data).code;
    blPrintTextView("用户登陆:" + code.toString());

    // String roleName = "钻石爸比";
    // String roleName = "超光年";
    // String roleName = "东篱把酒";
    // String roleName = "收活跃玩家";
    // String roleName = "照小坏";

    if (_nickname == null ||
    _nickname.length == 0)
    {
      blPrintTextView("请设置角色昵称");
      return;
    }
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
            if (serverInfo.nickname == _nickname)
            {
              Map<String, dynamic> params = new Map();
              params["phone"] = "18888888888";
              params["serverId"] = serverInfo.serverId;

              ///绑定账号内容
              Response responseBind = await dio.post(
                  BLApi.BL_USER_BIND_ROLE, data: params);

              blPrintTextView("账号绑定角色:" + serverInfo.nickname + " 结果:" +
                  BLResponse
                      .fromJson(responseBind.data)
                      .code
                      .toString());

              Response responseItemInfo = await this.dio.get(BLApi.BL_USER_DOLL_INFO);
              var blItemInfoResp = BLItemInfoResp.fromGetItemJson(responseItemInfo.data);
              BLItemInfo info = blItemInfoResp.itemInfo;
              blPrintTextView("刷分前的信息[积分:" + info.point.toString() +
                  "蓝染娃娃:" + info.dolllr.toString() +
                  "白哉娃娃:" + info.dollbz.toString() + "]");
              this.loginResp = blItemInfoResp;
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
    var blItemInfoResp = this.loginResp;
    BLItemInfo lastInfo = blItemInfoResp.itemInfo;
    bool needContinue = true;
    int dollType = 2; ///先摇白哉
    // int _crystalNumber = 1; ///想要摇的水晶数量
    if (_crystalNumber == 0)
    {
      blPrintTextView("请输入数量");
      return;
    }
    do {
      Response responseGeDoll = await this.dio.post(BLApi.BL_GET_DOLL, data:{"type":dollType});
      blItemInfoResp = BLItemInfoResp.fromGetDollJson(responseGeDoll.data);
      if (blItemInfoResp.code == 0) { ///请求成功
          ///蓝染
          if (dollType == 3) {
            ///没有刷到娃娃，但是成功，需要退出循环
            if (blItemInfoResp.itemInfo.dolllr != lastInfo.dolllr + 1) {
              lastInfo = blItemInfoResp.itemInfo;
              needContinue = false;
              blPrintTextView("刷到环，任务强制结束 [积分:" + lastInfo.point.toString() +
                  " 蓝染娃娃数量:" + lastInfo.dolllr.toString() +
                  " 白哉娃娃数量:" + lastInfo.dollbz.toString() + "]"
              );
            }
            else {
              lastInfo = blItemInfoResp.itemInfo;
              blPrintTextView("刷到一个蓝染 [积分:" + lastInfo.point.toString() +
                  " 蓝染娃娃数量:" + lastInfo.dolllr.toString() +
                  " 白哉娃娃数量:" + lastInfo.dollbz.toString() + "]"
              );
              if (lastInfo.point == 0) {
                needContinue = false;
              }
              if (lastInfo.dolllr < 3 * _crystalNumber) {
                ///被3整数以后转换下类型
                if (lastInfo.dolllr % 3 == 0) {
                  blPrintTextView("转换抽取类型为白哉娃娃");
                  dollType = 2;
                }
                else {
                  dollType = 3;
                }
              }
              else {
                needContinue = false;
                blPrintTextView("完成刷分任务[积分:" + lastInfo.point.toString() +
                    " 蓝染娃娃数量:" + lastInfo.dolllr.toString() +
                    " 白哉娃娃数量:" + lastInfo.dollbz.toString() + "]"
                );
              }
            }
          }
          ///白哉
          else {
            ///没有刷到娃娃，但是成功，需要退出循环
            if (blItemInfoResp.itemInfo.dollbz != lastInfo.dollbz + 1) {
              lastInfo = blItemInfoResp.itemInfo;
              needContinue = false;
              blPrintTextView("刷到环，任务强制结束 [积分:" + lastInfo.point.toString() +
                  " 蓝染娃娃数量:" + lastInfo.dolllr.toString() +
                  " 白哉娃娃数量:" + lastInfo.dollbz.toString() + "]"
              );
            }
            else {
              lastInfo = blItemInfoResp.itemInfo;
              blPrintTextView("刷到一个白哉 [积分:" + lastInfo.point.toString() +
                  " 蓝染娃娃数量:" + lastInfo.dolllr.toString() +
                  " 白哉娃娃数量:" + lastInfo.dollbz.toString() + "]"
              );
              if (lastInfo.point == 0) {
                needContinue = false;
              }
              if (lastInfo.dollbz < 4 * _crystalNumber) {
                ///被4整数以后转换下类型
                if (lastInfo.dollbz % 4 == 0) {
                  blPrintTextView("转换抽取类型为蓝染娃娃");
                  dollType = 3;
                }
                else {
                  dollType = 2;
                }
              }
              else {
                dollType = 3;
                blPrintTextView("更新刷新蓝染娃娃 [积分:" + lastInfo.point.toString() +
                    " 蓝染娃娃数量:" + lastInfo.dolllr.toString() +
                    " 白哉娃娃数量:" + lastInfo.dollbz.toString() + "]"
                );
              }
            }
          }
      }
      else {
        blPrintTextView("继续刷分:"+ blItemInfoResp.code.toString() + " 消息内容:" +blItemInfoResp.msg);
      }
    }
    while (needContinue);
  }

  TextButton loginFlatButton(){
    return TextButton(
      onPressed: blLoginAction,
      child: Text("登陆账号"),
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

  TextButton getDollFlatButton(){
    return TextButton(
      onPressed: getDollAction,
      child: Text("开始刷新娃娃"),
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

  void accountChanged(String account) {
    _account = account;
  }

  void passwordChanged(String pwd) {
    _password = pwd;
  }

  void nicknameChanged(String nickname) {
    _nickname = nickname;
  }

  void crystalNumberChanged(String count) {
    _crystalNumber = num.parse(count);
  }

  ListView _listView() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        TextField(
          onChanged: accountChanged,
          decoration:
          InputDecoration(labelText: '账户名'),),
        TextField(
          obscureText: true,
          onChanged: passwordChanged,
          decoration:
          InputDecoration(labelText: '密码'),
        ),
        TextField(
          onChanged:nicknameChanged,
          decoration:
          InputDecoration(labelText: '游戏昵称'),),
        loginFlatButton(),
        TextField(
          onChanged: crystalNumberChanged,
          decoration:
          InputDecoration(labelText: '水晶数量'),),
        getDollFlatButton(),
        Text(_printText, style: TextStyle(color: Colors.black54),),
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