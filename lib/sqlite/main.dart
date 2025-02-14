import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  const _MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Database _database;
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'simple_db.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
    );

    _loadItems();
  }

  Future<void> _loadItems() async {
    final List<Map<String, dynamic>> maps = await _database.query('items');
    setState(() {
      _items = List.generate(maps.length, (i) => maps[i]['name'] as String);
    });
  }

  Future<void> _addItem() async {
    String newItem = 'Item ${_items.length + 1}';
    await _database.insert(
      'items',
      {'name': newItem},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadItems();
  }

  Future<void> _deleteItem(int index) async {
    await _database.delete(
      'items',
      where: 'name = ?',
      whereArgs: [_items[index]],
    );
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQLite Example')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
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
