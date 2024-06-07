import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/error/error_handler.dart';
import 'package:evercook/features/recipe/data/models/recipe_model.dart';
import 'package:flutter/material.dart';
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
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 96, 94, 94),
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                await saveSelectedRecipes();
                Navigator.pop(context);
              },
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
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 38,
                      top: 16,
                      bottom: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[300],
                            image: recipe.imageUrl!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(recipe.imageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              recipe.imageUrl!.isEmpty ? const Icon(Icons.image, size: 50, color: Colors.grey) : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.name ?? '',
                                softWrap: true,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                recipe.description ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Checkbox(
                                checkColor: Colors.red,
                                value: selectedRecipes.contains(recipe.id),
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
                              Divider(),
                            ],
                          ),
                        ),
                      ],
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
