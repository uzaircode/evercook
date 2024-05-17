import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/presentation/pages/edit_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';

class RecipeDetailsPage extends StatelessWidget {
  static route(Recipe recipe) => MaterialPageRoute(builder: (context) => RecipeDetailsPage(recipe: recipe));

  final Recipe recipe;

  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Grey color background
                shape: BoxShape.circle, // Rounded shape
              ),
              margin: const EdgeInsets.all(8), // Optional, for spacing around the leading widget
              child: IconButton(
                onPressed: () {
                  // Navigation logic here
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                color: const Color.fromARGB(255, 96, 94, 94), // Icon color, change as needed
              ),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Grey color background
                  shape: BoxShape.circle, // Rounded shape
                ),
                margin: const EdgeInsets.all(8), // Optional, for spacing around the button
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, EditRecipePage.route(recipe));
                  },
                  icon: const Icon(Icons.edit),
                  color: const Color.fromARGB(255, 96, 94, 94), // Icon color, change as needed
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                  color: const Color.fromARGB(255, 193, 27, 27),
                ),
              ),
            ],
            stretch: true,
            pinned: true,
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderImage(recipe.imageUrl ?? ''),
            ),
          ),
          BlocConsumer<RecipeBloc, RecipeState>(
            listener: (context, state) {
              if (state is RecipeFailure) {
                _showSnackbar(context, 'Error: ${state.error}');
              } else if (state is RecipeDeleteSuccess) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  recipe.title ?? '',
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _addMealPlan();
                                },
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildDetailsRow(
                            recipe.prepTime ?? '',
                            recipe.cookTime ?? '',
                            recipe.servings?.toString() ?? '',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            recipe.description ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(color: Colors.grey.shade300),
                          _buildSectionTitle(
                            context,
                            'Ingredients',
                            IconButton(
                              onPressed: () async {
                                LoggerService.logger.d('Starting to add to shopping list');
                                LoggerService.logger.d('Recipe ID: ${recipe.id}');
                                LoggerService.logger.d('User ID: ${recipe.userId}');

                                try {
                                  // Perform the RPC call and store the result
                                  await _addShoppingList();
                                } catch (e) {
                                  // Log any errors that occur during the RPC call
                                  LoggerService.logger.e('Error updating shopping list: $e');
                                }
                              },
                              icon: const Icon(Icons.local_grocery_store_outlined),
                            ),
                          ),
                          _buildIngredientList(
                            recipe.ingredients,
                          ),
                          const SizedBox(height: 16),
                          Divider(color: Colors.grey.shade300),
                          _buildSectionTitle(context, 'Directions', null),
                          Text(
                            recipe.directions ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 109, 107, 107),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(color: Colors.grey.shade300),
                          _buildSectionTitle(
                            context,
                            'Notes',
                            null,
                          ),
                          Text(
                            recipe.notes ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 109, 107, 107),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addMealPlan() async {
    await Supabase.instance.client.from('meal_plan').insert([
      {
        'recipe_id': recipe.id,
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'date': DateTime.now().toIso8601String(),
      }
    ]);
  }

  Widget _buildHeaderImage(String imageUrl) {
    return Hero(
      tag: 'transition',
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildDetailsRow(String prepTime, String cookTime, String servings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailColumn('Prep Time', prepTime),
        _buildDetailColumn('Cook Time', cookTime),
        _buildDetailColumn('Servings', servings),
      ],
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          border: Border.all(
            color: Colors.grey[300]!, // Border color
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientList(List<Map<String, dynamic>> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients
          .map((ingredient) => Text(
                '${ingredient['name']}',
                style: const TextStyle(
                  fontSize: 15,
                  height: 2,
                  fontWeight: FontWeight.w500,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconButton? icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          if (icon != null) icon,
          // IconButton(
          //   onPressed: () async {
          //     LoggerService.logger.d('Starting to add to shopping list');
          //     LoggerService.logger.d('Recipe ID: ${recipe.id}');
          //     LoggerService.logger.d('User ID: ${recipe.userId}');

          //     try {
          //       // Perform the RPC call and store the result
          //       await _addShoppingList();
          //     } catch (e) {
          //       // Log any errors that occur during the RPC call
          //       LoggerService.logger.e('Error updating shopping list: $e');
          //     }
          //   },
          //   icon: const Icon(Icons.local_grocery_store_outlined),
          // ),
        ],
      ),
    );
  }

  Future<void> _addShoppingList() async {
    await Supabase.instance.client.rpc('add_to_shopping_list', params: {
      'recipe_id': recipe.id,
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to delete this recipe?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<RecipeBloc>().add(RecipeDelete(id: recipe.id));
                Navigator.of(context).pop();
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
