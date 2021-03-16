import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
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

      ysDioTest();
    });
  }

  void ysDioTest() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get("http://www.baidu.com");
    responseText = response.data.toString();
    print(response.data.toString());
    // Optionally the request above could also be done as
    // response = await dio.get("http://www.google.com.cn", queryParameters: {"id": 12, "name": "wendu"});
    // print(response.data.toString());
  }

  FlatButton getPointFlatButton(){
    return FlatButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
      },
      child: Text("死神激斗积分领取"),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  FlatButton palyerFlatButton(){
    return FlatButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => BLGetDollPage()));
      },
      child: Text("死神激斗刷分"),
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
          onPressed: (){

          },
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
        getPointFlatButton(),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            height: 40,
          ),
        ),
        palyerFlatButton(),
        // _shapeColumn(),
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