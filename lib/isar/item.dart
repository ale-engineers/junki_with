import 'package:isar/isar.dart';

part 'item.g.dart';

@collection
class Item {
  Id id = Isar.autoIncrement; // 自動インクリメント
  late String name;

  Item({required this.name});
}
