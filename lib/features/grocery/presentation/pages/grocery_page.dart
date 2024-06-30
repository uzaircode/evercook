import 'package:cached_network_image/cached_network_image.dart';
import 'package:evercook/core/common/widgets/custom_navigation_bar.dart';
import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/common/widgets/snackbar/show_fail_snackbar.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/core/utils/logger.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({Key? key}) : super(key: key);
  static route() => MaterialPageRoute(builder: (context) => const GroceryPage());

  @override
  _GroceryPageState createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  late Map<String, dynamic> recipes = {};
  late List<Map<String, dynamic>> unpurchasedIngredients = [];
  late List<Map<String, dynamic>> purchasedIngredients = [];
  bool isLoading = true;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    fetchShoppingListItems();
  }

  Future<void> fetchShoppingListItems() async {
    setState(() => isLoading = true);
    try {
      final res = await Supabase.instance.client
          .from(DBConstants.shoppingListTable)
          .select('*, recipes:recipe_id (name, image_url)')
          .eq('user_id', Supabase.instance.client.auth.currentSession!.user.id);

      Map<String, dynamic> tempRecipes = {};
      List<Map<String, dynamic>> tempUnpurchasedIngredients = [];
      List<Map<String, dynamic>> tempPurchasedIngredients = [];

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
        if (item['purchased'] == true) {
          tempPurchasedIngredients.add(item);
        } else {
          tempUnpurchasedIngredients.add(item);
        }
      }

      setState(() {
        recipes = tempRecipes;
        unpurchasedIngredients = tempUnpurchasedIngredients;
        purchasedIngredients = tempPurchasedIngredients;
        isLoading = false;
      });
    } catch (error) {
      LoggerService.logger.e('Error fetching shopping list items: $error');
      setState(() => isLoading = false);
    }
  }

  void _deleteRecipe(String recipeId, BuildContext context) async {
    try {
      await Supabase.instance.client
          .from(DBConstants.shoppingListTable)
          .delete()
          .eq('recipe_id', recipeId)
          .eq('user_id', Supabase.instance.client.auth.currentSession!.user.id);

      setState(() {
        recipes.remove(recipeId);
        int removeIndex = unpurchasedIngredients.indexWhere((item) => item['recipe_id'] == recipeId);
        while (removeIndex != -1) {
          final removedItem = unpurchasedIngredients.removeAt(removeIndex);
          _listKey.currentState?.removeItem(
            removeIndex,
            (context, animation) => _buildIngredientItem(context, removeIndex, animation, removedItem),
          );
          removeIndex = unpurchasedIngredients.indexWhere((item) => item['recipe_id'] == recipeId);
        }
        removeIndex = purchasedIngredients.indexWhere((item) => item['recipe_id'] == recipeId);
        while (removeIndex != -1) {
          final removedItem = purchasedIngredients.removeAt(removeIndex);
          _listKey.currentState?.removeItem(
            removeIndex + unpurchasedIngredients.length,
            (context, animation) =>
                _buildIngredientItem(context, removeIndex + unpurchasedIngredients.length, animation, removedItem),
          );
          removeIndex = purchasedIngredients.indexWhere((item) => item['recipe_id'] == recipeId);
        }
      });
      showSuccessSnackBar(context, "Recipe deleted successfully");
    } catch (e) {
      print('Error deleting recipe: $e');
      showFailSnackbar(context, "Error when attempting to delete recipe");
    }
  }

  void _deleteAllRecipe(List<String> recipeIds, BuildContext context) async {
    try {
      await Supabase.instance.client
          .from(DBConstants.shoppingListTable)
          .delete()
          .inFilter('recipe_id', recipeIds)
          .eq('user_id', Supabase.instance.client.auth.currentSession!.user.id);

      setState(() {
        for (var recipeId in recipeIds) {
          recipes.remove(recipeId);
          int removeIndex = unpurchasedIngredients.indexWhere((item) => item['recipe_id'] == recipeId);
          while (removeIndex != -1) {
            final removedItem = unpurchasedIngredients.removeAt(removeIndex);
            _listKey.currentState?.removeItem(
              removeIndex,
              (context, animation) => _buildIngredientItem(context, removeIndex, animation, removedItem),
            );
            removeIndex = unpurchasedIngredients.indexWhere((item) => item['recipe_id'] == recipeId);
          }
          removeIndex = purchasedIngredients.indexWhere((item) => item['recipe_id'] == recipeId);
          while (removeIndex != -1) {
            final removedItem = purchasedIngredients.removeAt(removeIndex);
            _listKey.currentState?.removeItem(
              removeIndex + unpurchasedIngredients.length,
              (context, animation) =>
                  _buildIngredientItem(context, removeIndex + unpurchasedIngredients.length, animation, removedItem),
            );
            removeIndex = purchasedIngredients.indexWhere((item) => item['recipe_id'] == recipeId);
          }
        }
      });
    } catch (e) {
      LoggerService.logger.e('Error deleting all recipes: $e');
      showFailSnackbar(context, "Error when attempting to delete all recipes");
    }
  }

  Future<void> _updateItem(int index, bool newValue) async {
    if (index < 0 || index >= unpurchasedIngredients.length + purchasedIngredients.length) return;

    var item;
    bool isPurchased;
    if (index < unpurchasedIngredients.length) {
      item = unpurchasedIngredients[index];
      isPurchased = false;
    } else {
      item = purchasedIngredients[index - unpurchasedIngredients.length];
      isPurchased = true;
    }

    try {
      setState(() {
        if (isPurchased) {
          purchasedIngredients.removeAt(index - unpurchasedIngredients.length);
          if (!newValue) {
            unpurchasedIngredients.insert(0, item);
          }
        } else {
          unpurchasedIngredients.removeAt(index);
          if (newValue) {
            purchasedIngredients.add(item);
          } else {
            unpurchasedIngredients.insert(0, item);
          }
        }

        item['purchased'] = newValue;
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => _buildIngredientItem(context, index, animation, item),
        );
        _listKey.currentState?.insertItem(
          newValue ? purchasedIngredients.length + unpurchasedIngredients.length - 1 : 0,
          duration: Duration(milliseconds: 300),
        );
      });

      await Supabase.instance.client.from(DBConstants.shoppingListTable).upsert({
        'list_id': item['list_id'],
        'recipe_id': item['recipe_id'],
        'ingredient': item['ingredient'],
        'purchased': newValue,
      }).eq('user_id', Supabase.instance.client.auth.currentSession!.user.id);

      LoggerService.logger.i('Purchased: $newValue');
    } catch (e) {
      LoggerService.logger.e('Error updating item: $e');
      setState(() {
        item['purchased'] = !newValue;
      });
    }
  }

  Future<void> addNewGroceryItem(Map<String, dynamic> newItem) async {
    try {
      setState(() {
        // Insert the new item before the first purchased item or at the end if all items are unpurchased
        unpurchasedIngredients.insert(0, newItem);
        _listKey.currentState?.insertItem(0);
      });

      await Supabase.instance.client
          .from(DBConstants.shoppingListTable)
          .upsert(newItem)
          .eq('user_id', Supabase.instance.client.auth.currentSession!.user.id);

      LoggerService.logger.i('Added new grocery item');
    } catch (e) {
      LoggerService.logger.e('Error adding new grocery item: $e');
    }
  }

  Widget _buildIngredientItem(BuildContext context, int index, Animation<double> animation, Map<String, dynamic> item) {
    String name = item['ingredient'];
    List<InlineSpan> spans = [];

    // Improved regular expression to capture common fractions and quantities
    RegExp exp = RegExp(r'(\b\d*\.?\d+\s*(?:/\s*\d+)?|¼|½|¾|\d+/\d+)|(\D+)');

    exp.allMatches(name).forEach((match) {
      if (match.group(1) != null) {
        spans.add(TextSpan(
          text: match.group(1),
          style: TextStyle(
            color: item['purchased'] ? Colors.grey : const Color.fromARGB(255, 221, 56, 32),
            fontWeight: FontWeight.bold,
          ),
        ));
      }
      if (match.group(2) != null) {
        spans.add(TextSpan(
          text: match.group(2),
          style: TextStyle(
            color: item['purchased'] ? Colors.grey : Theme.of(context).colorScheme.onTertiary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ));
      }
    });

    return FadeTransition(
      opacity: animation,
      child: CheckboxListTile(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16.0,
            ),
            children: spans,
          ),
        ),
        value: item['purchased'] as bool?,
        onChanged: (bool? newValue) {
          if (newValue == null) return;
          _updateItem(index, newValue);
        },
        activeColor: Color.fromARGB(255, 221, 56, 32),
        checkColor: Colors.white,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomNavigationBar(
              largeTitle: 'Shopping List',
              middleTitle: 'Shopping List',
              trailing: IconButton(
                onPressed: () {
                  List<String> recipeIds = recipes.keys.toList();
                  _deleteAllRecipe(recipeIds, context);
                },
                icon: Icon(Icons.delete_outlined),
              ),
            ),
          ],
          body: isLoading
              ? const Center(child: Loader())
              : recipes.isEmpty
                  ? EmptyValue(
                      iconData: Icons.shopping_bag_outlined,
                      description: 'No recipes in',
                      value: 'Shopping List',
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              var entry = recipes.entries.elementAt(index);
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: Theme.of(context).colorScheme.primaryContainer,
                                margin: const EdgeInsets.all(8),
                                elevation: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    width: 180,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Positioned.fill(
                                                child: entry.value['image_url'] != null &&
                                                        entry.value['image_url'].isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl: entry.value['image_url'],
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const Icon(
                                                        Icons.image,
                                                        size: 70,
                                                        color: Colors.grey,
                                                      ),
                                              ),
                                              Positioned(
                                                right: 4,
                                                top: 4,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.tertiary,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Color.fromARGB(255, 221, 56, 32),
                                                    ),
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
                                          width: double.infinity,
                                          color: Theme.of(context).colorScheme.tertiary,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            entry.value['name'] ?? '(No Title)',
                                            style: Theme.of(context).textTheme.titleSmall,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
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
                        Divider(),
                        AnimatedList(
                          key: _listKey,
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          initialItemCount: unpurchasedIngredients.length + purchasedIngredients.length,
                          itemBuilder: (context, index, animation) {
                            var item = index < unpurchasedIngredients.length
                                ? unpurchasedIngredients[index]
                                : purchasedIngredients[index - unpurchasedIngredients.length];
                            return _buildIngredientItem(context, index, animation, item);
                          },
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
