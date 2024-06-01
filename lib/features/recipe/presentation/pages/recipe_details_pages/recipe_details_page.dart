import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/route_transitision.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/confirm_ingredients_page.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/cook_mode.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/edit_recipe_page.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
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
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () {
                  Future.delayed(Duration.zero, () {
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.arrow_back),
                color: const Color.fromARGB(255, 96, 94, 94),
              ),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, EditRecipePage.route(recipe));
                  },
                  icon: const Icon(Icons.edit),
                  color: const Color.fromARGB(255, 96, 94, 94),
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
            expandedHeight: 500,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'recipe_image_${recipe.id}',
                child: _buildHeaderImage(
                  recipe.imageUrl ?? '',
                ),
              ),
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
                                  recipe.name ?? '(No Title)',
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDetailsRow(
                            recipe.prepTime ?? '',
                            recipe.cookTime ?? '',
                            recipe.servings ?? '',
                            context,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  animationDownToUp(
                                    CookModePage(
                                      recipe: recipe,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color.fromARGB(255, 221, 56, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_arrow_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Cook Mode',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            recipe.description ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Color(0xFF3F3F3F) // Light Theme specific color
                                      : Colors.white,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Divider(),
                          _buildSectionWithContent(
                            context,
                            'Ingredients',
                            recipe.ingredients.join('\n'),
                            iconData: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              margin: const EdgeInsets.all(8),
                              child: IconButton(
                                onPressed: () async {
                                  await _addMealPlan();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    Dashboard.route(),
                                    (route) => false,
                                  );
                                },
                                icon: const Icon(Icons.calendar_month),
                                color: const Color.fromARGB(255, 96, 94, 94),
                              ),
                            ),
                            icon: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              margin: const EdgeInsets.all(8),
                              child: IconButton(
                                onPressed: () async {
                                  try {
                                    Navigator.push(
                                      context,
                                      animationDownToUp(
                                        ConfirmIngredientsPage(
                                          recipe: recipe,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    LoggerService.logger.e(
                                      'Error updating shopping list: $e',
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.local_grocery_store_outlined,
                                ),
                                color: const Color.fromARGB(255, 96, 94, 94),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(),
                          _buildSectionWithContent(
                            context,
                            'Directions',
                            recipe.directions,
                          ),
                          const SizedBox(height: 16),
                          recipe.notes != null ? Divider() : SizedBox.shrink(),
                          _buildSectionWithContent(
                            context,
                            'Notes',
                            recipe.notes,
                          ),
                          const SizedBox(height: 16),
                          recipe.notes != null ? Divider() : SizedBox.shrink(),
                          _buildSectionWithContent(
                            context,
                            'Utensils',
                            recipe.utensils,
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

  //todo separate to business logic
  Future<void> _addMealPlan() async {
    await Supabase.instance.client.from(DBConstants.mealPlan).insert([
      {
        'recipe_id': recipe.id,
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'date': DateTime.now().toIso8601String(),
      }
    ]);
  }

  //todo move this widget to widget page
  Widget _buildHeaderImage(String imageUrl) {
    LoggerService.logger.d('recipe details: transition_${recipe.id}');
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }

  //todo move this widget to widget page
  Widget _buildDetailsRow(String prepTime, String cookTime, String servings, BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildDetailColumn(
            'Prep',
            prepTime,
            context,
            icon: Icon(
              Icons.access_time_rounded,
              size: 22,
            ),
            divider: VerticalDivider(
              color: Color.fromARGB(255, 233, 234, 234),
              thickness: 1.2,
            ),
          ),
          _buildDetailColumn(
            'Cook',
            cookTime,
            context,
            divider: VerticalDivider(
              color: Color.fromARGB(255, 233, 234, 234),
              thickness: 1.2,
            ),
          ),
          _buildDetailColumn(
            'Servings',
            servings,
            context,
            divider: VerticalDivider(
              color: Color.fromARGB(255, 233, 234, 234),
              thickness: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildDetailColumn(String title, String value, BuildContext context, {Widget? icon, Widget? divider}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Row(
        children: [
          if (icon != null) icon,
          if (divider != null) divider,
          SizedBox(width: 5),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildSectionWithContent(BuildContext context, String title, String? content,
      {Widget? icon, Widget? iconData}) {
    if (content == null || content.isEmpty) {
      return SizedBox.shrink(); // Return an empty widget if content is null or empty
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                child: Row(
                  children: [
                    if (iconData != null) iconData,
                    if (icon != null) icon,
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
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

  //todo move this widget to widget page
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
