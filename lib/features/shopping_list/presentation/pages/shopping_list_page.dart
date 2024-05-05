//zzz!!
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/core/utils/logger.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);
  static route() => MaterialPageRoute(builder: (context) => const ShoppingListPage());

  @override
  ShoppingListPageState createState() => ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {
  late List<Map<String, dynamic>> shoppingListItems = [];
  late Set<String> recipeIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShoppingListItems();
  }

  Future<void> fetchShoppingListItems() async {
    setState(() => isLoading = true);
    final response =
        await Supabase.instance.client.from('shopping_list').select().order('list_id', ascending: true).select();

    setState(() {
      shoppingListItems = List<Map<String, dynamic>>.from(response);
      recipeIds = shoppingListItems.map((item) => item['recipe_id'].toString()).toSet();
      isLoading = false;
    });
    setState(() => isLoading = false);
  }

  Future<void> deleteRecipeItems(String recipeId) async {
    await Supabase.instance.client.from('shopping_list').delete().eq('recipe_id', recipeId).select();

    LoggerService.logger.i('Deleted items for recipe_id: $recipeId');
    fetchShoppingListItems(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: recipeIds
                        .map((id) => ListTile(
                              title: Text('Recipe ID: $id'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteRecipeItems(id),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    itemCount: shoppingListItems.length,
                    itemBuilder: (context, index) {
                      var item = shoppingListItems[index];
                      return ListTile(
                        title: Text(
                          item['ingredient'],
                          style: TextStyle(
                            decoration: item['purchased'] ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: Checkbox(
                          value: item['purchased'] as bool,
                          onChanged: (bool? newValue) async {
                            if (newValue == null) return;
                            try {
                              setState(() {
                                shoppingListItems[index]['purchased'] = newValue;
                              });
                              await Supabase.instance.client.from('shopping_list').upsert({
                                'list_id': item['list_id'],
                                'recipe_id': item['recipe_id'],
                                'ingredient': item['ingredient'],
                                'purchased': newValue,
                              }).select();
                              LoggerService.logger.i('Purchased: $newValue');
                            } catch (e) {
                              LoggerService.logger.e('Error updating item: $e');
                              setState(() {
                                shoppingListItems[index]['purchased'] = !newValue;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
