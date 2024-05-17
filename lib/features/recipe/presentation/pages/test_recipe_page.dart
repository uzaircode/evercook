import 'package:flutter/material.dart';

class TestRecipePage extends StatelessWidget {
  static MaterialPageRoute route(Map<String, dynamic> recipe) {
    return MaterialPageRoute(builder: (context) => TestRecipePage(recipe: recipe));
  }

  final Map<String, dynamic> recipe;

  const TestRecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                _buildRecipeDetails(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildRecipeDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe['title'] ?? 'Title',
            softWrap: true,
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailsRow(
            recipe['prep_time'] ?? '',
            recipe['cook_time'] ?? '',
            recipe['servings']?.toString() ?? '',
          ),
          const SizedBox(height: 16),
          Text(
            recipe['description'] ?? 'Description',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          _buildSectionTitle('Ingredients'),
          _buildIngredientList(recipe['ingredients'] ?? []),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          _buildSectionTitle('Directions'),
          // Add directions here if available
        ],
      ),
    );
  }

  Widget _buildDetailsRow(String prepTime, String cookTime, String servings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailColumn('Prep Time', prepTime),
        _buildDetailColumn('Cook Time', cookTime),
        _buildDetailColumn('Servings', servings),
      ],
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          border: Border.all(
            color: Colors.grey[300]!, // Border color
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
