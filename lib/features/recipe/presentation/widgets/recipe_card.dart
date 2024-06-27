import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, RecipeDetailsPage. route());
      },
      child: Container(
        height: 80,
        width: 100,
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
      ),
    );
  }
}
