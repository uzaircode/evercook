import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/error/error_handler.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/data/models/recipe_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 96, 94, 94),
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                await saveSelectedRecipes();
                Navigator.pushAndRemoveUntil(
                  context,
                  Dashboard.route(),
                  (route) => false,
                );
              },
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
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text('Are you sure you want to delete this recipe?'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      // Add delete logic here
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        backgroundColor: const Color(0xFFFF0000),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 38,
                        top: 16,
                        bottom: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'recipe_image_${recipe.id}',
                            child: Container(
                              width: 100,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.grey[300],
                                image: recipe.imageUrl!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(recipe.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: recipe.imageUrl!.isEmpty
                                  ? const Icon(Icons.image, size: 50, color: Colors.grey)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.name ?? '',
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  recipe.description ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Checkbox(
                                  checkColor: Colors.red,
                                  value: selectedRecipes.contains(recipe.id),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedRecipes.add(recipe.id);
                                        LoggerService.logger.d(selectedRecipes);
                                      } else {
                                        selectedRecipes.remove(recipe.id);
                                      }
                                    });
                                  },
                                ),
                                Divider(),
                              ],
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
