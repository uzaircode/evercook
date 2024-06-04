import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/features/recipe/presentation/pages/community_pages/user_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/core/utils/logger.dart';

class ProfileUserPage extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const ProfileUserPage({Key? key, required this.profileData}) : super(key: key);

  static Route<dynamic> route(Map<String, dynamic> profileData) {
    return MaterialPageRoute(builder: (context) => ProfileUserPage(profileData: profileData));
  }

  @override
  ProfileUserPageState createState() => ProfileUserPageState();
}

class ProfileUserPageState extends State<ProfileUserPage> {
  late Future<List<Map<String, dynamic>>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = fetchRecipesByUserId(widget.profileData['id']);
  }

  //todo separate to business logic
  Future<List<Map<String, dynamic>>> fetchRecipesByUserId(String userId) async {
    final response = await Supabase.instance.client
        .from(DBConstants.recipesTable)
        .select()
        .eq(
          'user_id',
          userId,
        )
        .eq(
          'public',
          true,
        );
    LoggerService.logger.i('data of recipes of this particular user: $response');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
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
        title: Text(
          widget.profileData['name'],
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const FaIcon(Icons.report_outlined),
        //     onPressed: () {
        //       // Add action for reporting profile
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromARGB(255, 238, 198, 202),
                    backgroundImage: NetworkImage(
                        widget.profileData['avatar_url'] ?? 'https://robohash.org/${widget.profileData['id']}'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.profileData['name'] ?? 'Unknown User',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 20,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.profileData['bio'] ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final recipes = snapshot.data!;
                  LoggerService.logger.i(recipes.toString());
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 0,
                        mainAxisExtent: 270,
                      ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserRecipePage(recipe: recipe),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(recipe['image_url'] ?? 'https://via.placeholder.com/150'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  recipe['name'] ?? 'Unnamed Recipe',
                                  style: Theme.of(context).textTheme.titleSmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Text('No recipes found.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
