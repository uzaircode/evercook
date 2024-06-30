import 'package:cached_network_image/cached_network_image.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/utils/extract_domain.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/confirm_ingredients_page.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/recipe_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;

  const RecipeItem({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              padding: EdgeInsets.only(left: 0),
              onPressed: (BuildContext context) {
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => ConfirmIngredientsPage(
                    recipe: recipe,
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              foregroundColor: Colors.white,
              icon: Icons.shopping_bag_outlined,
            ),
            SizedBox(width: 2),
            SlidableAction(
              padding: EdgeInsets.only(left: 0),
              onPressed: (BuildContext context) async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  confirmText: 'Confirm',
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: Theme.of(context).brightness == Brightness.dark
                          ? ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Theme.of(context).colorScheme.onPrimaryContainer, // Header background color
                                onPrimary: Colors.white, // Header text color
                                onSurface: Theme.of(context).colorScheme.onSurface, // Body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  textStyle: Theme.of(context).textTheme.titleSmall, // Custom text style
                                ),
                              ),
                            )
                          : ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Theme.of(context).colorScheme.onSecondaryContainer, // Header background color
                                onPrimary: Colors.black, // Header text color
                                onSurface: Theme.of(context).colorScheme.onPrimary, // Body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Color.fromARGB(255, 34, 34, 36),
                                  textStyle: Theme.of(context).textTheme.titleSmall, // Custom text style
                                ),
                              ),
                            ),
                      child: child!,
                    );
                  },
                );
                if (selectedDate != null) {
                  await Supabase.instance.client.from(DBConstants.mealPlan).insert([
                    {
                      'recipe_id': recipe.id,
                      'user_id': Supabase.instance.client.auth.currentUser!.id,
                      'date': selectedDate.toIso8601String(),
                    }
                  ]).then((_) {
                    if (context.mounted) {
                      LoggerService.logger.i('debug');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Meal plan added successfully')),
                      );
                    }
                  });
                }
              },
              backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              foregroundColor: Colors.white,
              icon: Icons.calendar_month_outlined,
            ),
            SizedBox(width: 2),
            SlidableAction(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              padding: EdgeInsets.only(left: 0),
              onPressed: (BuildContext context) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(
                        'Confirm Delete',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      content: Text(
                        'Are you sure you want to delete this recipe?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          child: const Text('Delete'),
                          onPressed: () {
                            context.read<RecipeBloc>().add(RecipeDelete(id: recipe.id));
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted) {
                                showSuccessSnackBar(context, "Successfully deleted the recipe");
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Color.fromARGB(255, 255, 69, 58),
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                RecipeDetailsPage.route(recipe),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Hero(
                  tag: 'recipe_image_${recipe.id}',
                  child: Container(
                    width: 100,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: recipe.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 110,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerTheme.color!,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<RecipeBloc, RecipeState>(
                            builder: (context, state) {
                              return Text(
                                recipe.name ?? '(No Title)',
                                softWrap: true,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.titleSmall,
                              );
                            },
                          ),
                          recipe.sources != null
                              ? Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.book,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      extractDomain(recipe.sources!),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 5),
                          Text(
                            recipe.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
