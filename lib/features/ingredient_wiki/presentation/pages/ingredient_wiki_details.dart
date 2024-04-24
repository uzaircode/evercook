import 'package:evercook/features/ingredient_wiki/domain/entities/ingredient_wiki.dart';
import 'package:flutter/material.dart';

class IngredientWikiDetails extends StatelessWidget {
  static route(IngredientWiki ingredient) => MaterialPageRoute(
        builder: (context) => IngredientWikiDetails(ingredient: ingredient),
      );
  final IngredientWiki ingredient;

  const IngredientWikiDetails({Key? key, required this.ingredient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Wiki Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(ingredient.imageUrl),
              ),
              const SizedBox(height: 20),
              Text(
                ingredient.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ingredient.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ingredient.storage,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ingredient.foodScience,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ingredient.cookingTips,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ingredient.healthBenefits,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
