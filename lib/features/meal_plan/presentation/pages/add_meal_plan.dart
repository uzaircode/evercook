import 'package:cached_network_image/cached_network_image.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/error/error_handler.dart';
import 'package:evercook/core/utils/extract_domain.dart';
import 'package:evercook/features/recipe/data/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelectRecipesPage extends StatefulWidget {
  final DateTime date;

  const SelectRecipesPage({Key? key, required this.date}) : super(key: key);

  @override
  _SelectRecipesPageState createState() => _SelectRecipesPageState();
}

class _SelectRecipesPageState extends State<SelectRecipesPage> {
  List<String> selectedRecipes = [];
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = getAllRecipes();
  }

  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final recipes = await Supabase.instance.client
          .from(DBConstants.recipesTable)
          .select('*, profiles (name)')
          .eq('user_id', Supabase.instance.client.auth.currentSession!.user.id);

      return recipes.map<RecipeModel>((recipe) {
        return RecipeModel.fromJson(recipe).copyWith(userName: recipe['profiles']['name']);
      }).toList();
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<void> saveSelectedRecipes() async {
    try {
      for (String recipeId in selectedRecipes) {
        await Supabase.instance.client.from(DBConstants.mealPlan).insert({
          'date': DateFormat('yyyy-MM-dd').format(widget.date),
          'recipe_id': recipeId,
          'user_id': Supabase.instance.client.auth.currentSession!.user.id,
        });
      }
    } catch (e) {
      print('Error saving recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () async {
              await saveSelectedRecipes();
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 221, 56, 32),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<RecipeModel>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recipes found'));
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedRecipes.contains(recipe.id)) {
                        selectedRecipes.remove(recipe.id);
                      } else {
                        selectedRecipes.add(recipe.id);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20, top: 16, bottom: 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                      decoration: BoxDecoration(
                        color: selectedRecipes.contains(recipe.id)
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? Color.fromARGB(255, 49, 49, 53)
                                : Color.fromARGB(255, 242, 244, 245))
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: Color.fromARGB(255, 221, 56, 32),
                            checkColor: Colors.white,
                            value: selectedRecipes.contains(recipe.id),
                            shape: CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedRecipes.add(recipe.id);
                                } else {
                                  selectedRecipes.remove(recipe.id);
                                }
                              });
                            },
                          ),
                          Container(
                            width: 100,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: recipe.imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: SizedBox(
                              height: 110,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).dividerTheme.color!,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.name ?? '(No Title)',
                                      softWrap: true,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    recipe.sources != null
                                        ? Row(
                                            children: [
                                              const FaIcon(
                                                FontAwesomeIcons.book,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                extractDomain(recipe.sources!),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                    const SizedBox(height: 5),
                                    Text(
                                      recipe.description ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
