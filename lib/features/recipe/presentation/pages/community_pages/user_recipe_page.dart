import 'package:evercook/core/utils/logger.dart';
import 'package:flutter/material.dart';

class UserRecipePage extends StatelessWidget {
  static MaterialPageRoute route(Map<String, dynamic> recipe) {
    return MaterialPageRoute(builder: (context) => UserRecipePage(recipe: recipe));
  }

  final Map<String, dynamic> recipe;

  const UserRecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoggerService.logger.d(recipe.toString());
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            pinned: true,
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderImage(recipe['image_url'] ?? ''),
            ),
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
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildRecipeDetails(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildHeaderImage(String imageUrl) {
    return Hero(
      tag: 'transition',
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('Image not available'));
        },
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildRecipeDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe['name'] ?? '(No name)',
            softWrap: true,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDetailsRow(
            recipe['prep_time'] ?? '',
            recipe['cook_time'] ?? '',
            recipe['servings'] ?? '',
          ),
          const SizedBox(height: 24),
          Text(
            recipe['description'] ?? '',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          _buildSectionTitle('Ingredients'),
          _buildIngredientList(recipe['ingredients'] ?? []),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          _buildSectionTitle('Directions'),
          Text(
            recipe['directions'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildDetailsRow(String prepTime, String cookTime, String servings) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildDetailColumn(
            'Prep',
            prepTime,
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
            divider: VerticalDivider(
              color: Color.fromARGB(255, 233, 234, 234),
              thickness: 1.2,
            ),
          ),
          _buildDetailColumn(
            'Servings',
            servings,
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
  Widget _buildDetailColumn(String title, String value, {Widget? icon, Widget? divider}) {
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildIngredientList(List<dynamic> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients
          .map((ingredient) => Text(
                ingredient.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  height: 2,
                  fontWeight: FontWeight.w500,
                ),
              ))
          .toList(),
    );
  }

  //todo move this widget to widget page
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 96, 94, 94),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
