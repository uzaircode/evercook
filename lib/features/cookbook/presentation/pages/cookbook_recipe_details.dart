import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CookbookDetailsPage extends StatefulWidget {
  final String cookbookId;
  final String cookbookTitle;

  const CookbookDetailsPage({
    Key? key,
    required this.cookbookId,
    required this.cookbookTitle,
  }) : super(key: key);

  @override
  _CookbookDetailsPageState createState() => _CookbookDetailsPageState();
}

class _CookbookDetailsPageState extends State<CookbookDetailsPage> {
  late Future<List<Map<String, dynamic>>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = fetchCookbookRecipes();
  }

  Future<List<Map<String, dynamic>>> fetchCookbookRecipes() async {
    try {
      final response = await Supabase.instance.client
          .from('cookbook_recipes')
          .select('recipes(*)')
          .eq('cookbook_id', widget.cookbookId);

      final recipes = response as List;
      LoggerService.logger.i('Fetched recipes: $recipes');

      return recipes.map((e) => e['recipes']).toList().cast<Map<String, dynamic>>();
    } catch (e) {
      LoggerService.logger.e('Failed to fetch recipes: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cookbookTitle),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loader());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching recipes: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recipes found'));
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  leading: recipe['image_url'] != null && recipe['image_url'].isNotEmpty
                      ? Image.network(recipe['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 50),
                  title: Text(recipe['title'] ?? 'No Title'),
                  subtitle: Text(recipe['description'] ?? 'No Description'),
                  onTap: () {
                    // Navigate to the recipe detail page if you have one
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
