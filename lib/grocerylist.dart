import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main342() {
  runApp(
    MaterialApp(
      title: 'Grocery List App',
      home: GroceryApp(storage: GroceryStorage()),
    ),
  );
}

class GroceryStorage {
  // Get the directory path for storing the file
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get the grocery list file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/grocery_list.txt');
  }

  // Read grocery items from the file
  Future<List<String>> readGroceryList() async {
    try {
      final file = await _localFile;

      // Read the file contents
      final contents = await file.readAsString();

      return contents.split('\n').where((item) => item.isNotEmpty).toList();
    } catch (e) {
      // If encountering an error, return an empty list
      return [];
    }
  }

  // Write grocery items to the file
  Future<File> writeGroceryList(List<String> groceryList) async {
    final file = await _localFile;

    // Convert the list to a string with each item on a new line
    return file.writeAsString(groceryList.join('\n'));
  }
}

class GroceryApp extends StatefulWidget {
  const GroceryApp({super.key, required this.storage});

  final GroceryStorage storage;

  @override
  State<GroceryApp> createState() => _GroceryAppState();
}

class _GroceryAppState extends State<GroceryApp> {
  List<String> _groceryList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Read the grocery list from the file when the app starts
    widget.storage.readGroceryList().then((value) {
      setState(() {
        _groceryList = value;
      });
    });
  }

  // Add a grocery item to the list and update the file
  Future<File> _addGroceryItem(String item) async {
    setState(() {
      _groceryList.add(item);
    });

    // Write the updated list to the file
    return widget.storage.writeGroceryList(_groceryList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter grocery item",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _addGroceryItem(_controller.text); // Add the item to the list and save it
                  _controller.clear(); // Clear the text field
                }
              },
              child: const Text("Add to List"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _groceryList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_groceryList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}








