import 'package:evercook/features/recipe/presentation/pages/ingredient_wiki_details.dart';
import 'package:flutter/material.dart';

class IngredientWikiCard extends StatelessWidget {
  final Color color;
  const IngredientWikiCard({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    List<String> topics = ['topic1', 'topic2', 'topic3'];

    return GestureDetector(
      onTap: () {
        Navigator.push(context, IngredientWikiDetails.route());
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16).copyWith(bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              label: Text(e),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ingredient Name',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
            // Text('${calculateReadingTime(blog.content)} mins'),
          ],
        ),
      ),
    );
  }
}
