// import 'dart:convert';
import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/common/widgets/skeleton/skeleton_homepage.dart';
import 'package:evercook/core/constant/db_constants.dart';
// import 'package:evercook/core/cubit/app_user.dart';
// import 'package:evercook/core/theme/theme_services.dart';
import 'package:evercook/core/utils/extract_domain.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/profile_pages/profile_page.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/pages/add_recipe_pages/add_new_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/pages/add_recipe_pages/new_recipe_url_page.dart';
import 'package:evercook/features/recipe/presentation/pages/community_pages/profile_user_page.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/recipe_details_page.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    // final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

    return Scaffold(
      floatingActionButton: Container(
        width: 50.0,
        height: 50.0,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            AddRecipeBottomSheet(context);
          },
          child: const Icon(
            Icons.add,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              // backgroundColor: CupertinoColors.systemBackground,
              heroTag: Null,
              alwaysShowMiddle: false,
              largeTitle: Text(
                'Directory',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              middle: Text(
                'Directory',
                style: TextStyle(
                  fontFamily: GoogleFonts.notoSerif().fontFamily,
                  color: Color.fromARGB(255, 64, 64, 64),
                  fontWeight: FontWeight.w700,
                ),
              ),
              // leading: GestureDetector(
              //   onTap: () {
              //     ThemeService().switchTheme();
              //   },
              //   child: Icon(Icons.cloud),
              // ),
              leading: GestureDetector(
                onTap: () {
                  // Navigator.push(context, ProfilePage.route());
                  Navigator.push(context, _createRoute(ProfilePage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 233, 232, 240),
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/a/ACg8ocK6xCHK3meZn4GXuEROw3GwSrcaPQ3EI-8qmq0Bqg3ROirau1pk=s96-c',
                        fit: BoxFit.cover, // Ensures the image covers the whole area
                      ),
                    ),
                  ),
                ),
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
                  iconColor: const Color.fromARGB(255, 221, 56, 32),
                ),
                child: const FaIcon(Icons.search),
              ),
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
              return const SkeletonHomepage();
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
                                    tag: 'transition_${recipe.id}',
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

  Future<dynamic> AddRecipeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.2),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add New Recipe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 127, 127, 127),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Divider(color: Colors.grey[300], thickness: 1),
              ListTile(
                leading: Icon(Icons.link_outlined),
                title: Text(
                  'Save Recipe From the Web',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    NewRecipeUrlPage.route(),
                  );
                },
              ),
              Divider(color: Colors.grey[300], thickness: 1),
              ListTile(
                leading: Icon(Icons.edit_note_outlined),
                title: Text(
                  'Create New Recipe',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 2),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    AddNewRecipePage.route(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

//todo separate to business logic
class CustomSearch extends SearchDelegate<String> {
  @override
  TextStyle? get searchFieldStyle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  @override
  String? get searchFieldLabel => 'Search user';

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
          return const EmptyValue(
            iconData: Icons.search_outlined,
            description: "Start searching for people, we'll wait",
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

  //todo separate to business logic
  Future<List<Map<String, dynamic>>> fetchSearchResults(String query) async {
    final response = await Supabase.instance.client.from(DBConstants.profilesTable).select().textSearch('name', query);

    return (response as List).cast<Map<String, dynamic>>();
  }
}