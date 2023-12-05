// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/ProductListPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ProductInputPage extends StatefulWidget {
  ProductInputPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ProductInputPage createState() => _ProductInputPage();
}

class _ProductInputPage extends State<ProductInputPage> {
  Uint8List bytes = Uint8List(0);
  late TextEditingController _inputController;
  late TextEditingController _outputController;
  late Product product;

  @override
  void initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
  }

  void scanChanged(String text) {
    product.scanNo = text;
  }

  void nameChanged(String text) {
    product.name = text;
  }

  void priceChanged(String text) {
    product.price = text as int;
  }

  TextField scanNoTF() {
    return TextField(
      controller: this._outputController,
      onChanged: scanChanged,
      onSubmitted: (value) => _generateBarCode(value),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.text_fields),
        helperText: '商品条形码，可以输入或者扫描商品',
        hintText: '请输入条形码',
        hintStyle: TextStyle(fontSize: 15),
        contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
        suffixIcon: GestureDetector(
            onTap: () => _scan(), child: Icon(Icons.info_outline_rounded)),
      ),
    );
  }

  TextField nameTF() {
    return TextField(
      onChanged: nameChanged,
      decoration:
          InputDecoration(prefixIcon: Icon(Icons.abc), labelText: '商品名称'),
    );
  }

  TextField priceTF() {
    return TextField(
      onChanged: priceChanged,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.price_change), labelText: '商品价格'),
    );
  }

  ListView _listV() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        scanNoTF(),
        SizedBox(height: 20),
        nameTF(),
        SizedBox(height: 20),
        priceTF(),
      ],
    );
  }

  Widget _buttonGroup() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 120,
            child: InkWell(
              onTap: () => _generateBarCode(this._inputController.text),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Image.asset('images/generate_qrcode.png'),
                    ),
                    Divider(height: 20),
                    Expanded(flex: 1, child: Text("Generate")),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 120,
            child: InkWell(
              onTap: _scan,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Image.asset('images/scanner.png'),
                    ),
                    Divider(height: 20),
                    Expanded(flex: 1, child: Text("Scan")),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 120,
            child: InkWell(
              onTap: _scanPhoto,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Image.asset('images/albums.png'),
                    ),
                    Divider(height: 20),
                    Expanded(flex: 1, child: Text("Scan Photo")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      this._outputController.text = barcode;
    }
  }

  Future _scanPhoto() async {
    await Permission.storage.request();
    String barcode = await scanner.scanPhoto();
    this._outputController.text = barcode;
  }

  // Future _scanPath(String path) async {
  //   await Permission.storage.request();
  //   String barcode = await scanner.scanPath(path);
  //   this._outputController.text = barcode;
  // }

  // Future _scanBytes() async {
  //   File? file = await ImagePicker.platform
  //       .getImageFromSource(source: ImageSource.camera)
  //       .then((picked) {
  //     if (picked == null) return null;
  //     return File(picked.path);
  //   });
  //   if (file == null) return;
  //   Uint8List bytes = file.readAsBytesSync();
  //   String barcode = await scanner.scanBytes(bytes);
  //   this._outputController.text = barcode;
  // }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("商品信息"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Show Snackbar',
              onPressed: () async {
                realm.writeAsync(() => null);
              },
            )
          ],
        ),
        body: _listV());
  }
}
