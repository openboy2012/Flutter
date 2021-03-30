import 'package:flutter/material.dart';
import 'SecondPage.dart';
import 'BLGetDollPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextButton getPointFlatButton(){
    return TextButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
      },
      child: Text("死神激斗积分领取"),
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

  TextButton playerFlatButton(){
    return TextButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => BLGetDollPage()));
      },
      child: Text("死神激斗刷分"),
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

  ListView _listView() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        getPointFlatButton(),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            height: 20,
          ),
        ),
        playerFlatButton(),
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
        title: Text("死神激斗"),
      ),
      body: _listView(),
    );
  }
}