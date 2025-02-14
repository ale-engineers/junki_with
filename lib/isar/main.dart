import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      ItemSchema,
    ],
    directory: dir.path,
  );
  runApp(IsarMyApp(isar));
}

class IsarMyApp extends StatelessWidget {
  final Isar isar;

  IsarMyApp(this.isar);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(isar),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Isar isar;

  HomeScreen(this.isar);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await widget.isar.items.where().findAll();
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem() async {
    final newItem = Item(name: 'Item ${_items.length + 1}');
    await widget.isar.writeTxn(() async {
      await widget.isar.items.put(newItem);
    });
    _loadItems();
  }

  Future<void> _deleteItem(int index) async {
    await widget.isar.writeTxn(() async {
      await widget.isar.items.delete(_items[index].id);
    });
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Isar Example')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index].name),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteItem(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
