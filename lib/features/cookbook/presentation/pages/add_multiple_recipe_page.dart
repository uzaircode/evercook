import 'package:cached_network_image/cached_network_image.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/error/error_handler.dart';
import 'package:evercook/core/utils/extract_domain.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:evercook/features/recipe/data/models/recipe_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddMultipleRecipePage extends StatefulWidget {
  final String title;
  final bool public;

  static route({
    required String title,
    required bool public,
  }) =>
      MaterialPageRoute(
        builder: (context) => AddMultipleRecipePage(
          title: title,
          public: public,
        ),
      );

  const AddMultipleRecipePage({
    Key? key,
    required this.title,
    required this.public,
  }) : super(key: key);

  @override
  _AddMultipleRecipePageState createState() => _AddMultipleRecipePageState();
}

class _AddMultipleRecipePageState extends State<AddMultipleRecipePage> {
  List<String> selectedRecipes = [];
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = getAllRecipes();
  }

  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final recipes = await Supabase.instance.client
          .from(DBConstants.recipesTable) // Replace with your actual table name
          .select('*, profiles (name)')
          .eq(
            'user_id',
            Supabase.instance.client.auth.currentSession!.user.id,
          ); // Replace with your actual user ID field

      return recipes
          .map<RecipeModel>(
            (recipe) => RecipeModel.fromJson(recipe).copyWith(
              userName: recipe['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ErrorHandler.handleError(e); // Replace with your actual error handler
    }
  }

  Future<void> saveSelectedRecipes() async {
    try {
      // Insert cookbook and wait for completion
      final cookbookResponse = await Supabase.instance.client.from('cookbooks').insert({
        'title': widget.title,
        'public': widget.public,
      }).select('*');

      LoggerService.logger.i(cookbookResponse);

      final cookbookId = cookbookResponse[0]['id'] as String;
      for (String recipeId in selectedRecipes) {
        await Supabase.instance.client.from('cookbook_recipes').insert({
          'cookbook_id': cookbookId,
          'recipe_id': recipeId,
          'user_id': Supabase.instance.client.auth.currentSession!.user.id,
        });
      }
    } catch (e) {
      print('Error saving recipes: $e');
    }
  }

  // void saveSelectedRecipes() async {
  //   try {
  //     for (String recipeId in selectedRecipes) {
  //       await Supabase.instance.client.from('cookbook_recipes').insert({
  //         'recipe_id': recipeId,
  //       });
  //     }
  //     print('Selected recipes saved: $selectedRecipes');
  //   } catch (e) {
  //     print('Error saving recipes: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    LoggerService.logger.i('The title of the cookbook is: ${widget.title}');
    LoggerService.logger.i('The bool public of the cookbook is: ${widget.public}');
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.left_chevron,
            ),
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await saveSelectedRecipes();
              Navigator.pushAndRemoveUntil(
                context,
                Dashboard.route(),
                (route) => false,
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSuccessSnackBar(context, "Successfully added the cookbook");
              });
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 221, 56, 32),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<RecipeModel>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recipes found'));
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedRecipes.contains(recipe.id)) {
                        selectedRecipes.remove(recipe.id);
                      } else {
                        selectedRecipes.add(recipe.id);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20, top: 16, bottom: 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                      decoration: BoxDecoration(
                        color: selectedRecipes.contains(recipe.id)
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? Color.fromARGB(255, 49, 49, 53) // Dark theme color
                                : Color.fromARGB(255, 242, 244, 245)) // Light theme color
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Color.fromARGB(255, 221, 56, 32),
                            value: selectedRecipes.contains(recipe.id),
                            shape: CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedRecipes.add(recipe.id);
                                } else {
                                  selectedRecipes.remove(recipe.id);
                                }
                              });
                            },
                          ),
                          Container(
                            width: 100,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: recipe.imageUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Loader(),
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.error,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          SizedBox(width: 14),
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
                                    Text(
                                      recipe.name ?? '(No Title)',
                                      softWrap: true,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.titleSmall,
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
