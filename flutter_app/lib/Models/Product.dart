import 'package:realm/realm.dart';
part 'Product.g.dart';

@RealmModel()
class _Product {
  ///条形码信息
  late String scanNo;

  ///商品名称
  late String name;

  ///商品价格
  late int price;

  ///商品图片
  late String picPath;
}
