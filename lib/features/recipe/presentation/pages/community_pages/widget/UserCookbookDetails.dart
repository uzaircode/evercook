import 'package:evercook/core/common/widgets/skeleton/skeleton_homepage.dart';
import 'package:evercook/features/cookbook/presentation/pages/edit_cookbook.dart';
import 'package:evercook/features/recipe/data/models/recipe_model.dart';
import 'package:evercook/features/recipe/presentation/pages/community_pages/user_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/recipe_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/core/utils/logger.dart';

class UserCookbookDetails extends StatefulWidget {
  final String cookbookId;
  final String cookbookTitle;

  const UserCookbookDetails({Key? key, required this.cookbookId, required this.cookbookTitle}) : super(key: key);

  @override
  _UserCookbookDetailsState createState() => _UserCookbookDetailsState();
}

class _UserCookbookDetailsState extends State<UserCookbookDetails> {
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
          .select(
              'recipes(id, name, description, image_url, user_id, ingredients, updated_at, prep_time, cook_time, servings, directions, notes, sources, utensils, public, user_id)')
          .eq('cookbook_id', cookbookId);

      LoggerService.logger.d(response);
      final recipes = response as List;
      return List<Map<String, dynamic>>.from(recipes.map((e) => e['recipes']));
    } catch (e) {
      print('Failed to fetch recipes: $e');
      return []; // Return an empty list if there's an error
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
            color: Theme.of(context).colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.left_chevron,
            ),
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SkeletonHomepage();
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
                  LoggerService.logger.d(recipe);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        UserRecipePage.route(recipe),
                      );
                    },
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
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              image: recipe['image_url'] != null
                                  ? DecorationImage(
                                      image: NetworkImage(recipe['image_url'] ?? ''),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: recipe['image_url'] == null
                                ? Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  )
                                : null,
                          ),
                          SizedBox(width: 16),
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
                                      recipe['name'] ?? '(No Title)',
                                      softWrap: true,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      recipe['description'] ?? '',
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
