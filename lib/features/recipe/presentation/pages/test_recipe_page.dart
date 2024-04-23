import 'dart:io';

import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:flutter/material.dart';

class TestRecipePage extends StatefulWidget {
  static route(Recipe recipe) => MaterialPageRoute(
        builder: (context) => TestRecipePage(recipe: recipe),
      );

  final Recipe recipe;
  TestRecipePage({super.key, required this.recipe});

  @override
  State<TestRecipePage> createState() => _TestRecipePageState();
}

class _TestRecipePageState extends State<TestRecipePage> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
    );
  }
}
