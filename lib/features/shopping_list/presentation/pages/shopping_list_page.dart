import 'package:evercook/features/recipe/presentation/pages/recipe_details_page.dart';
import 'package:evercook/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/core/utils/logger.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);
  static route() => MaterialPageRoute(builder: (context) => const ShoppingListPage());

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late Map<String, dynamic> recipes = {};
  late List<Map<String, dynamic>> ingredients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShoppingListItems();
  }

  Future<void> fetchShoppingListItems() async {
    setState(() => isLoading = true);
    try {
      final res = await Supabase.instance.client
          .from('shopping_list')
          .select('*, recipes:recipe_id (title, image_url)')
          .order('list_id', ascending: true);

      Map<String, dynamic> tempRecipes = {};
      List<Map<String, dynamic>> tempIngredients = [];

      for (var item in res as List) {
        String recipeId = item['recipe_id'];
        if (!tempRecipes.containsKey(recipeId)) {
          tempRecipes[recipeId] = {
            'title': item['recipes']['title'],
            'image_url': item['recipes']['image_url'],
            'ingredients': [],
          };
        }
        tempRecipes[recipeId]['ingredients'].add(item);
        tempIngredients.add(item);
      }

      setState(() {
        recipes = tempRecipes;
        ingredients = tempIngredients;
        isLoading = false;
      });
    } catch (error) {
      LoggerService.logger.e('Error fetching shopping list items: $error');
      setState(() => isLoading = false);
    }
  }

  void _deleteRecipe(String recipeId, BuildContext context) async {
    try {
      // Delete from 'shopping_list' table where 'recipe_id' matches.
      await Supabase.instance.client.from('shopping_list').delete().eq('recipe_id', recipeId);

      // Show a snackbar to inform the user about successful deletion.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe deleted successfully')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        Dashboard.route(),
        (route) => false,
      );

      // Navigate back to the dashboard page.
    } catch (e) {
      // Handle any errors that occur during the deletion process.
      print('Error deleting recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error when attempting to delete recipe')),
      );
    }
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        var entry = recipes.entries.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            // Optionally, navigate or perform another action
                          },
                          child: Card(
                            margin: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                            child: Image.network(
                                              entry.value['image_url'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 4,
                                          top: 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.close, color: Colors.red),
                                              onPressed: () {
                                                _deleteRecipe(entry.key, context);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        entry.value['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      var item = ingredients[index];
                      return ListTile(
                        title: Text(
                          item['ingredient'],
                          style: TextStyle(
                            decoration: item['purchased'] ? TextDecoration.lineThrough : null,
                            color: item['purchased'] ? Colors.grey : null,
                            decorationColor: item['purchased'] ? Colors.grey : null,
                          ),
                        ),
                        trailing: Checkbox(
                          value: item['purchased'] as bool?,
                          onChanged: (bool? newValue) {
                            if (newValue == null) return;
                            _updateItem(index, newValue);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _updateItem(int index, bool newValue) async {
    var item = ingredients[index];
    try {
      setState(() {
        ingredients[index]['purchased'] = newValue;
      });
      await Supabase.instance.client.from('shopping_list').upsert({
        'list_id': item['list_id'],
        'recipe_id': item['recipe_id'],
        'ingredient': item['ingredient'],
        'purchased': newValue,
      });
      LoggerService.logger.i('Purchased: $newValue');
    } catch (e) {
      LoggerService.logger.e('Error updating item: $e');
      setState(() {
        ingredients[index]['purchased'] = !newValue;
      });
    }
  }
}
