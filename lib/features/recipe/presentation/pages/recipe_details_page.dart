import 'package:evercook/core/utils/format_date.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/pages/edit_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeDetailsPage extends StatelessWidget {
  static route(Recipe recipe) => MaterialPageRoute(
        builder: (context) => RecipeDetailsPage(recipe: recipe),
      );

  final Recipe recipe;
  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                EditRecipePage.route(recipe),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          // TODO UI: popup delete confirmation
          IconButton(
            onPressed: () {
              context.read<RecipeBloc>().add(RecipeDelete(id: recipe.id));
              Navigator.pushAndRemoveUntil(context, HomePage.route(), (route) => false);
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            _imageWidget(recipe.imageUrl),
            // TODO UI: show success snackbar
            IconButton(
              onPressed: () async {
                await Supabase.instance.client.from('meal_plan').insert([
                  {
                    'recipe_id': recipe.id,
                    'user_id': Supabase.instance.client.auth.currentUser!.id,
                    'date': DateTime.now().toIso8601String(),
                  }
                ]);
              },
              icon: const Icon(Icons.calendar_month),
            ),
            _buildDetailRow('Description', recipe.description),
            _buildDetailRow('Prep Time', recipe.prepTime),
            _buildDetailRow('Cook Time', recipe.cookTime),
            _buildDetailRow('Servings', recipe.servings.toString()),
            _buildDetailRow('Updated At', formatDatebdMMMYYY(recipe.updatedAt)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        LoggerService.logger.d('Starting to add to shopping list');
                        LoggerService.logger.d('Recipe ID: ${recipe.id}');
                        LoggerService.logger.d('User ID: ${recipe.userId}');

                        try {
                          // Perform the RPC call and store the result
                          await Supabase.instance.client.rpc('add_to_shopping_list', params: {
                            'recipe_id': recipe.id,
                          });
                        } catch (e) {
                          // Log any errors that occur during the RPC call
                          LoggerService.logger.e('Error updating shopping list: $e');
                        }
                      },
                      icon: const Icon(Icons.local_grocery_store_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                for (var ingredient in recipe.ingredients)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '${ingredient['name']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _imageWidget(String imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: SizedBox(
      height: 200, // Specify your desired height here
      width: double.infinity, // Optionally specify a width
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover, // This ensures the image covers the container area without distortion
      ),
    ),
  );
}
