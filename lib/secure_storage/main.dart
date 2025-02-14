import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final String? storedData = await _storage.read(key: 'items');
    if (storedData != null) {
      setState(() {
        _items = List<String>.from(jsonDecode(storedData));
      });
    }
  }

  Future<void> _addItem() async {
    String newItem = 'Item ${_items.length + 1}';
    _items.add(newItem);
    await _storage.write(key: 'items', value: jsonEncode(_items));
    _loadItems();
  }

  Future<void> _deleteItem(int index) async {
    _items.removeAt(index);
    await _storage.write(key: 'items', value: jsonEncode(_items));
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Storage Example')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addItem,
      ),
    );
  }
}
