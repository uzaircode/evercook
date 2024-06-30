import 'package:evercook/core/common/widgets/homepage/recipe_item.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeList({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeItem(recipe: recipe);
        },
      ),
    );
  }
}
