import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_page.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, RecipeDetailsPage.route(recipe));
      },
      child: SizedBox(
        height: 250, // Increased height to accommodate image
        width: double.infinity, // Using full width of the parent container
        child: Card(
          clipBehavior: Clip.antiAlias, // Adds clipping to the Card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover, // Covers the width of the card
                  width: double.infinity, // Match the card's width
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
