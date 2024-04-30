import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  List<Map<String, dynamic>> shoppingListItems = [
    {'name': 'Milk', 'quantity': '1', 'unit': 'L', 'isTicked': false},
    {'name': 'Eggs', 'quantity': '6', 'unit': 'pcs', 'isTicked': false},
    {'name': 'Bread', 'quantity': '1', 'unit': 'loaf', 'isTicked': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: shoppingListItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '${shoppingListItems[index]['name']} - ${shoppingListItems[index]['quantity']} ${shoppingListItems[index]['unit']}'),
            trailing: Checkbox(
              value: shoppingListItems[index]['isTicked'],
              onChanged: (bool? newValue) {
                setState(() {
                  shoppingListItems[index]['isTicked'] = newValue!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
