import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/common/widgets/skeleton/skeleton_homepage.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/utils/extract_domain.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/profile_pages/profile_page.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/pages/add_recipe_pages/add_new_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/pages/add_recipe_pages/new_recipe_url_page.dart';
import 'package:evercook/features/recipe/presentation/pages/community_pages/profile_user_page.dart';
import 'package:evercook/features/recipe/presentation/pages/recipe_details_pages/recipe_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> display_list = [];
  List<Recipe> allRecipes = [];
  final TextEditingController textFieldController = TextEditingController();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No need to fetch recipes here again
  }

  void updateList(String value) {
    setState(() {
      display_list = allRecipes.where((element) {
        final query = value.toLowerCase();
        final nameMatch = element.name?.toLowerCase().contains(query) ?? false;
        final ingredientsMatch = element.ingredients.any((ingredient) => ingredient.toLowerCase().contains(query));
        final resourcesMatch = element.sources?.toLowerCase().contains(query) ?? false;

        return nameMatch || ingredientsMatch || resourcesMatch;
      }).toList();
      // display_list = allRecipes.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 50.0,
        height: 50.0,
        child: FloatingActionButton(
          heroTag: '',
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
              heroTag: 'trans',
              alwaysShowMiddle: false,
              largeTitle: Text(
                'Directory',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              middle: Text(
                'Directory',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(context, _createRoute(ProfilePage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).splashColor,
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/a/ACg8ocK6xCHK3meZn4GXuEROw3GwSrcaPQ3EI-8qmq0Bqg3ROirau1pk=s96-c',
                        // 'https://robohash.org/$userId',
                        // avatar,
                        fit: BoxFit.cover,
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
              // Update allRecipes when new data is fetched
              allRecipes = List.from(state.recipes);

              // If display_list is empty, set it to allRecipes
              if (display_list.isEmpty || !display_list.any((recipe) => allRecipes.contains(recipe))) {
                display_list = List.from(allRecipes);
              }

              return display_list.isEmpty
                  ? EmptyValue(
                      iconData: Icons.book_outlined,
                      description: 'No recipes in',
                      value: 'Directory',
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 38,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextField(
                              controller: textFieldController,
                              onChanged: (value) => updateList(value),
                              // decoration: Theme.of(context).,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                filled: true,
                                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 160, 160, 160)),
                                suffixIcon: textFieldController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          textFieldController.clear();
                                          updateList('');
                                        },
                                      )
                                    : null,
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: display_list.length,
                              itemBuilder: (context, index) {
                                final recipe = display_list[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Slidable(
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
                                                        // Navigator.pushAndRemoveUntil(
                                                        //   context,
                                                        //   Dashboard.route(),
                                                        //   (route) => false,
                                                        // );
                                                        Navigator.pop(context);
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Hero(
                                            tag: 'recipe_image_${recipe.id}', // Use recipe.id directly
                                            child: Container(
                                              width: 100,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0),
                                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                image: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                          recipe.imageUrl ?? '',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : null,
                                              ),
                                              child: recipe.imageUrl == null || recipe.imageUrl!.isEmpty
                                                  ? const Icon(
                                                      Icons.image,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    )
                                                  : null,
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
                            ),
                          )
                        ],
                      ),
                    );
            }
            return Container(); // Or any other appropriate widget for default state
          },
        ),
      ),
    );
  }
}

Future<dynamic> AddRecipeBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250,
        padding: EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        child: Wrap(
          children: [
            Center(
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            SizedBox(height: 8),
            Divider(),
            ListTile(
              leading: Icon(Icons.link_outlined),
              title: Text(
                'Save Recipe From the Web',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
            Divider(),
            ListTile(
              leading: Icon(Icons.edit_note_outlined),
              title: Text(
                'Create New Recipe',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
