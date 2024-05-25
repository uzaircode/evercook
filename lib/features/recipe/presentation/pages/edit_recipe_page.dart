import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/pick_image.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/widgets/recipe_editor.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditRecipePage extends StatefulWidget {
  static route(Recipe recipe) => MaterialPageRoute(
        builder: (context) => EditRecipePage(recipe: recipe),
      );

  final Recipe recipe;

  const EditRecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final prepTimeController = TextEditingController();
  final cookTimeController = TextEditingController();
  final servingsController = TextEditingController();
  File? image;

  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      // Retrieve the recipe passed from the previous page
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is Recipe) {
        nameController.text = widget.recipe.name ?? '';
        descriptionController.text = widget.recipe.description ?? '';
        prepTimeController.text = widget.recipe.prepTime ?? '';
        cookTimeController.text = widget.recipe.cookTime ?? '';
        servingsController.text = widget.recipe.servings.toString();
      }
      isInit = false;
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void updateRecipe() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('recipes')
          .update({
            'name': nameController.text.trim(),
            'description': descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
            'prep_time': prepTimeController.text.trim(),
            'cook_time': cookTimeController.text.trim(),
            'servings': int.parse(servingsController.text.trim()),
          })
          .eq('id', widget.recipe.id)
          .select();
    } catch (e) {
      LoggerService.logger.i('Exception during update: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error during update: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        actions: [
          IconButton(
            onPressed: () {
              LoggerService.logger.i('Recipe updated');
              updateRecipe();
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: selectImage,
                child: image != null
                    ? SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : DottedBorder(
                        dashPattern: const [10, 4],
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        color: AppPallete.borderColor,
                        child: const SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open, size: 40),
                              SizedBox(height: 15),
                              Text('Select your image', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              RecipeEditor(controller: nameController, hintText: widget.recipe.name ?? ''),
              const SizedBox(height: 10),
              RecipeEditor(controller: descriptionController, hintText: widget.recipe.description ?? ''),
              const SizedBox(height: 10),
              RecipeEditor(controller: cookTimeController, hintText: widget.recipe.cookTime ?? ''),
              const SizedBox(height: 10),
              RecipeEditor(controller: prepTimeController, hintText: widget.recipe.prepTime ?? ''),
              const SizedBox(height: 10),
              RecipeEditor(controller: servingsController, hintText: widget.recipe.servings.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
