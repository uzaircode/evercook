import 'package:evercook/features/recipe/presentation/pages/test_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Future<List<Map<String, dynamic>>> fetchRecipesByUserId(String userId) async {
    final response = await Supabase.instance.client.from('recipes').select().eq('user_id', userId);
    LoggerService.logger.i('data of recipes of this particular user: $response');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(Icons.report_outlined),
            onPressed: () {
              // Add action for reporting profile
            },
          ),
        ],
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
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 238, 198, 202),
                    backgroundImage: NetworkImage(
                        widget.profileData['imageUrl'] ?? 'https://robohash.org/${widget.profileData['id']}'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.profileData['name'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.profileData['bio'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
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
                                builder: (context) => TestRecipePage(recipe: recipe),
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
                                  recipe['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
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
