import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeDetails extends StatelessWidget {
  const RecipeDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extracting arguments passed to this page
    final Map<String, dynamic> arguments = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              arguments['name'],
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            _buildDetailRow('Servings', arguments['name']),
            _buildDetailRow('Prep Time', arguments['name']),
            _buildDetailRow('Cook Time', arguments['name']),
            _buildDetailRow('Total Time', arguments['name']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
