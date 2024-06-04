import 'package:evercook/features/cookbook/presentation/pages/edit_cookbook.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/recipe_details_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/core/utils/logger.dart';

class CookbookDetails extends StatefulWidget {
  final String cookbookId;
  final String cookbookTitle;
  static route(Recipe recipe) => MaterialPageRoute(builder: (context) => RecipeDetailsPage(recipe: recipe));

  const CookbookDetails({Key? key, required this.cookbookId, required this.cookbookTitle}) : super(key: key);

  @override
  _CookbookDetailsState createState() => _CookbookDetailsState();
}

class _CookbookDetailsState extends State<CookbookDetails> {
  late Future<List<Map<String, dynamic>>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = fetchRecipesForCookbook(widget.cookbookId);
  }

  Future<List<Map<String, dynamic>>> fetchRecipesForCookbook(String cookbookId) async {
    try {
      final response = await Supabase.instance.client
          .from('cookbook_recipes')
          .select('recipes(id, name, description, image_url)')
          .eq('cookbook_id', cookbookId);

      LoggerService.logger.d(response);
      final recipes = response as List;
      return List<Map<String, dynamic>>.from(recipes.map((e) => e['recipes']));
    } catch (e) {
      print('Failed to fetch recipes: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cookbookTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
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
          TextButton(
            onPressed: () {
              Navigator.push(context, CookbookEditPage.route(widget.cookbookId));
            },
            child: Text(
              'Edit',
              style: TextStyle(
                color: Color.fromARGB(255, 221, 56, 32),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching recipes'));
          } else {
            final recipes = snapshot.data ?? [];
            if (recipes.isEmpty) {
              return Center(child: Text('No recipes available'));
            } else {
              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[300],
                              image: recipe['image_url'] != null
                                  ? DecorationImage(
                                      image: NetworkImage(recipe['image_url'] ?? ''),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: recipe['image_url'] == null ? Icon(Icons.image, size: 50, color: Colors.grey) : null,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recipe Name
                                Text(
                                  recipe['name'] ?? '(No Title)',
                                  style: Theme.of(context).textTheme.titleSmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                // Recipe Description
                                Text(
                                  recipe['description'] ?? '',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
          }
        },
      ),
    );
  }
}
