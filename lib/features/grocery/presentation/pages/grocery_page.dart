import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({Key? key}) : super(key: key);
  static route() => MaterialPageRoute(builder: (context) => const GroceryPage());

  @override
  _GroceryPageState createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  late Map<String, dynamic> recipes = {};
  late List<Map<String, dynamic>> ingredients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShoppingListItems();
  }

  //todo separate to business logic
  Future<void> fetchShoppingListItems() async {
    setState(() => isLoading = true);
    try {
      final res = await Supabase.instance.client
          .from(DBConstants.shoppingListTable)
          .select('*, recipes:recipe_id (name, image_url)')
          .order('list_id', ascending: true);

      Map<String, dynamic> tempRecipes = {};
      List<Map<String, dynamic>> tempIngredients = [];

      for (var item in res as List) {
        String recipeId = item['recipe_id'];
        if (!tempRecipes.containsKey(recipeId)) {
          tempRecipes[recipeId] = {
            'name': item['recipes']['name'],
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

  //todo separate to business logic
  void _deleteRecipe(String recipeId, BuildContext context) async {
    try {
      await Supabase.instance.client.from(DBConstants.shoppingListTable).delete().eq('recipe_id', recipeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe deleted successfully')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        Dashboard.route(),
        (route) => false,
      );
    } catch (e) {
      print('Error deleting recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error when attempting to delete recipe')),
      );
    }
  }

  //todo separate to business logic
  Future<void> _updateItem(int index, bool newValue) async {
    var item = ingredients[index];
    try {
      setState(() {
        ingredients[index]['purchased'] = newValue;
      });
      await Supabase.instance.client.from(DBConstants.shoppingListTable).upsert({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CupertinoSliverNavigationBar(
              alwaysShowMiddle: false,
              largeTitle: Text(
                'Groceries',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              middle: Text(
                'Groceries',
                style: TextStyle(
                  fontFamily: GoogleFonts.notoSerif().fontFamily,
                  color: Color.fromARGB(255, 64, 64, 64),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : recipes.isEmpty
                  ? EmptyValue(
                      iconData: Icons.shopping_bag_outlined,
                      description: 'No recipes in',
                      value: 'Groceries',
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          height: 240,
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
                                  elevation: 2,
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
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              entry.value['name'],
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
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 2,
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                                  fontWeight: FontWeight.w500,
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
                      ],
                    ),
        ),
      ),
    );
  }
}