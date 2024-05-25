// import 'dart:convert';
import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/common/widgets/skeleton/homepage_skeleton.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/theme/theme_services.dart';
import 'package:evercook/core/utils/extract_domain.dart';
import 'package:evercook/core/utils/logger.dart';
// import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/pages/add_new_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/pages/new_recipe_url_page.dart';
import 'package:evercook/features/recipe/presentation/pages/profile_user_page.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_page.dart';
import 'package:evercook/pages/home/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(RecipeFetchAllRecipes());
    context.read<AuthBloc>().stream.listen((authState) {
      if (authState is AuthIsUserLoggedIn) {
        context.read<RecipeBloc>().add(RecipeFetchAllRecipes());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 250,
                padding: EdgeInsets.all(16),
                child: Wrap(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Add New Recipe',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 127, 127, 127),
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey[300], thickness: 1),
                    ListTile(
                      leading: Icon(Icons.link_outlined),
                      title: Text('Save Recipe From the Web'),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                      onTap: () => Navigator.push(
                        context,
                        NewRecipeUrlPage.route(),
                      ),
                    ),
                    Divider(color: Colors.grey[300], thickness: 1),
                    ListTile(
                      leading: Icon(Icons.edit_note_outlined),
                      title: Text('Create New Recipe'),
                      contentPadding: EdgeInsets.symmetric(vertical: 2),
                      onTap: () => Navigator.push(context, AddNewRecipePage.route()),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              heroTag: Null,
              largeTitle: Text(
                'Discover',
              ),
              leading: GestureDetector(
                onTap: () {
                  ThemeService().switchTheme();
                },
                child: Icon(Icons.cloud),
              ),
              trailing: TextButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearch(),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  iconColor: const Color.fromARGB(255, 244, 118, 160),
                ),
                child: const FaIcon(Icons.search),
              ),
              border: null,
            ),
          ];
        },
        body: BlocConsumer<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipeFailure) {
              showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const HomepageSkeleton();
            }
            if (state is RecipeDisplaySuccess) {
              return state.recipes.isEmpty
                  ? EmptyValue(
                      iconData: Icons.book_outlined,
                      description: 'No recipes in',
                      value: 'Cookbook',
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = state.recipes[index];
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
                                              context.read<RecipeBloc>().add(RecipeDelete(id: recipe.id));
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                Dashboard.route(),
                                                (route) => false,
                                              );
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
                            onTap: () {
                              Navigator.push(
                                context,
                                RecipeDetailsPage.route(recipe),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 18,
                                right: 42,
                                top: 16,
                                bottom: 8,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: 'transition_${recipe.id}', // Assuming recipe.id is unique
                                    child: Container(
                                      width: 100,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: Colors.grey[300],
                                        image: recipe.imageUrl != null
                                            ? DecorationImage(
                                                image: NetworkImage(recipe.imageUrl ?? ''),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: recipe.imageUrl == null
                                          ? const Icon(Icons.image, size: 50, color: Colors.grey)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.name ?? '(No Title)',
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.3,
                                          ),
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSearchResults(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Loader());
        }

        var results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final profile = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 238, 198, 202),
                backgroundImage: NetworkImage(profile['image_url'] ?? 'https://robohash.org/${profile['id']}'),
              ),
              title: Text(
                profile['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(context, ProfileUserPage.route(profile));
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSearchResults(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Loader());
        }

        if (query.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Start searching for people, we'll wait",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 121, 120, 120),
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          );
        }

        var results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final profile = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 238, 198, 202),
                backgroundImage: NetworkImage(
                  profile['image_url'] ?? 'https://robohash.org/${profile['id']}',
                ),
              ),
              title: Text(
                profile['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                LoggerService.logger.d(profile);
                Navigator.push(context, ProfileUserPage.route(profile));
              },
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchSearchResults(String query) async {
    final response = await Supabase.instance.client.from('profiles').select().textSearch('name', query);

    return (response as List).cast<Map<String, dynamic>>();
  }
}
