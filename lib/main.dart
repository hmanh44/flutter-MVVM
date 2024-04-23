import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Item {
  final int id;
  String name;

  Item({required this.id, required this.name});
}

class ItemViewModel extends ChangeNotifier {
  List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  void addItem(String name) {
    _items.add(Item(id: _items.length + 1, name: name));
    notifyListeners();
  }
  
  void deleteItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  void updateItem(Item item, String newName) {
    item.name = newName;
    notifyListeners();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ItemViewModel(),
      child: MaterialApp(
        title: 'Flutter MVVM Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ItemListScreen(),
      ),
    );
  }
}

class ItemListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: Consumer<ItemViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.items.length,
            itemBuilder: (context, index) {
              final item = viewModel.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('ID: ${item.id}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    viewModel.deleteItem(item);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final String itemName = _controller.text.trim();
                if (itemName.isNotEmpty) {
                  Provider.of<ItemViewModel>(context, listen: false)
                      .addItem(itemName);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
