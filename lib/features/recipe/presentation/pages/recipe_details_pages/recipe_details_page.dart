import 'package:cached_network_image/cached_network_image.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/route_transitision.dart';
import 'package:evercook/core/common/widgets/snackbar/show_fail_snackbar.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/confirm_ingredients_page.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/cook_mode.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/edit_recipe_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';

class RecipeDetailsPage extends StatefulWidget {
  static route(Recipe recipe) => MaterialPageRoute(builder: (context) => RecipeDetailsPage(recipe: recipe));

  final Recipe recipe;

  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
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
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () {
                  Future.delayed(
                    Duration.zero,
                    () {
                      Navigator.pop(context);
                    },
                  );
                },
                icon: const Icon(
                  CupertinoIcons.left_chevron,
                ),
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(8),
                child: PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Theme.of(context).colorScheme.onTertiary),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: Theme.of(context).colorScheme.onTertiary)),
                        ],
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'addMealPlan',
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.onTertiary),
                          SizedBox(width: 8),
                          Text('Add to Meal Plan', style: TextStyle(color: Theme.of(context).colorScheme.onTertiary)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'addGrocery',
                      child: Row(
                        children: [
                          Icon(Icons.shopping_cart_outlined, color: Theme.of(context).colorScheme.onTertiary),
                          SizedBox(width: 8),
                          Text('Add to Groceries', style: TextStyle(color: Theme.of(context).colorScheme.onTertiary)),
                        ],
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Color.fromARGB(255, 193, 27, 27)),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Color.fromARGB(255, 193, 27, 27))),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (String value) {
                    if (value == 'edit') {
                      Navigator.push(context, EditRecipePage.route(widget.recipe));
                    } else if (value == 'delete') {
                      _showDeleteDialog(context);
                    } else if (value == 'addMealPlan') {
                      _addMealPlan().then((_) {
                        showSuccessSnackBar(context, 'Meal plan added successfully');
                      });
                    } else if (value == 'addGrocery') {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => ConfirmIngredientsPage(
                          recipe: widget.recipe,
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.more_horiz_outlined),
                ),
              ),
            ],
            stretch: true,
            pinned: true,
            expandedHeight: widget.recipe.imageUrl == null || widget.recipe.imageUrl!.isEmpty ? null : 500,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'recipe_image_${widget.recipe.id}',
                child: _buildHeaderImage(
                  widget.recipe.imageUrl ?? '',
                ),
              ),
            ),
          ),
          BlocConsumer<RecipeBloc, RecipeState>(
            listener: (context, state) {
              if (state is RecipeFailure) {
                showFailSnackbar(context, 'Error: ${state.error}');
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
                            children: [
                              Flexible(
                                child: Text(
                                  widget.recipe.name ?? '(No Title)',
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDetailsRow(
                            widget.recipe.prepTime ?? '',
                            widget.recipe.cookTime ?? '',
                            widget.recipe.servings ?? '',
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
                                      recipe: widget.recipe,
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
                            widget.recipe.description ?? '',
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
                            widget.recipe.ingredients.join('\n'),
                            iconData: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                shape: BoxShape.circle,
                              ),
                              margin: const EdgeInsets.all(8),
                              child: IconButton(
                                onPressed: () async {
                                  await _addMealPlan();
                                  showSuccessSnackBar(context, 'Meal plan added successfully');
                                },
                                icon: const Icon(Icons.calendar_month),
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  animationDownToUp(
                                    ConfirmIngredientsPage(
                                      recipe: widget.recipe,
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
                                    Icons.local_grocery_store_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add to Shopping list',
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
                          Divider(),
                          _buildSectionWithContent(
                            context,
                            'Directions',
                            widget.recipe.directions,
                          ),
                          const SizedBox(height: 16),
                          widget.recipe.notes != null ? Divider() : SizedBox.shrink(),
                          _buildSectionWithContent(
                            context,
                            'Notes',
                            widget.recipe.notes,
                          ),
                          const SizedBox(height: 16),
                          widget.recipe.notes != null ? Divider() : SizedBox.shrink(),
                          _buildSectionWithContent(
                            context,
                            'Utensils',
                            widget.recipe.utensils,
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
        'recipe_id': widget.recipe.id,
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'date': DateTime.now().toIso8601String(),
      }
    ]);
  }

  //todo move this widget to widget page
  Widget _buildHeaderImage(String? imageUrl) {
    LoggerService.logger.d('recipe details: transition_${widget.recipe.id}');
    if (imageUrl == null || imageUrl.isEmpty) {
      return SizedBox.shrink();
    }
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildDetailsRow(
    String? prepTime,
    String? cookTime,
    String? servings,
    BuildContext context,
  ) {
    if ((prepTime == null || prepTime.isEmpty) &&
        (cookTime == null || cookTime.isEmpty) &&
        (servings == null || servings.isEmpty)) {
      return SizedBox.shrink();
    }
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 22,
                ),
                SizedBox(width: 5),
                VerticalDivider(
                  thickness: 1.2,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Prep',
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
                      prepTime ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 1.2,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              children: [
                SizedBox(width: 5),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cook',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      cookTime ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildDetailColumn(
            'Servings',
            servings ?? '',
            context,
            divider: VerticalDivider(
              thickness: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildDetailColumn(String title, String value, BuildContext context, {Widget? icon, Widget? divider}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Expanded(
          child: Row(
            children: [
              if (icon != null) icon,
              if (divider != null) divider,
              SizedBox(width: 5),
              Flexible(
                child: Column(
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
          title: Text(
            "Confirm",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          content: const Text("Are you sure you want to delete this recipe?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<RecipeBloc>().add(RecipeDelete(id: widget.recipe.id));
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSuccessSnackBar(context, "Successfully deleted the recipe");
                });
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Color.fromARGB(255, 221, 56, 32),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
