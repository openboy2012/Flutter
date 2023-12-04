import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/ProductInputPage.dart';
import 'package:realm/realm.dart';

late Realm realm;

class ProductListPage extends StatefulWidget {
  ProductListPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ProductListPage createState() => _ProductListPage();
}

class _ProductListPage extends State<ProductListPage> {
  Future<Realm> initRealm(String assetKey) async {
    final config = Configuration.local([Product.schema]);
    final file = File(config.path);
    // await file.delete(); // <-- uncomment this to start over on every restart
    if (!await file.exists()) {
      ByteData realmBytes = await rootBundle.load(assetKey);
      await file.writeAsBytes(
        realmBytes.buffer
            .asUint8List(realmBytes.offsetInBytes, realmBytes.lengthInBytes),
        mode: FileMode.write,
      );
    }
    return Realm(config);
  }

  @override
  void initState() {
    final config = Configuration.local([Product.schema]);
    realm = Realm(config);
    super.initState();
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
          title: Text("商品列表"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Show Snackbar',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductInputPage()));
              },
            )
          ],
        ),
        body: StreamBuilder<RealmResultsChanges<Product>>(
          stream: realm.all<Product>().changes,
          builder: (context, snapshot) {
            final data = snapshot.data;

            if (data == null) return const CircularProgressIndicator();

            final results = data.results;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final c = results[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.car_rental)),
                  title: Text(c.name),
                  subtitle: Text(c.price.toString()),
                );
              },
            );
          },
        ));
  }
}
