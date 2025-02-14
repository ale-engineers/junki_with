import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('items');
    if (storedData != null) {
      setState(() {
        _items = List<String>.from(jsonDecode(storedData));
      });
    }
  }

  Future<void> _addItem() async {
    String newItem = 'Item ${_items.length + 1}';
    _items.add(newItem);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('items', jsonEncode(_items));
    _loadItems();
  }

  Future<void> _deleteItem(int index) async {
    _items.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('items', jsonEncode(_items));
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Preferences Example')),
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
