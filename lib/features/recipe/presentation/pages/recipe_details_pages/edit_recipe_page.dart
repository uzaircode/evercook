import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/pick_image.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late TextEditingController imageUrlController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController prepTimeController;
  late TextEditingController cookTimeController;
  late TextEditingController servingsController;
  late TextEditingController directionsController;
  late TextEditingController notesController;
  late TextEditingController sourcesController;
  late List<TextEditingController> ingredientsControllers;
  File? image;
  bool isInit = true;

  @override
  void initState() {
    super.initState();
    imageUrlController = TextEditingController(text: widget.recipe.imageUrl ?? '');
    nameController = TextEditingController(text: widget.recipe.name ?? '');
    descriptionController = TextEditingController(text: widget.recipe.description ?? '');
    prepTimeController = TextEditingController(text: widget.recipe.prepTime ?? '');
    cookTimeController = TextEditingController(text: widget.recipe.cookTime ?? '');
    servingsController = TextEditingController(text: widget.recipe.servings ?? '');
    directionsController = TextEditingController(text: widget.recipe.directions ?? '');
    notesController = TextEditingController(text: widget.recipe.notes ?? '');
    sourcesController = TextEditingController(text: widget.recipe.sources ?? '');
    ingredientsControllers =
        widget.recipe.ingredients.map((ingredient) => TextEditingController(text: ingredient)).toList();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void addIngredientField() {
    setState(() {
      ingredientsControllers.add(TextEditingController());
    });
  }

  void removeIngredientField(int index) {
    setState(() {
      if (ingredientsControllers.length > 1) {
        ingredientsControllers.removeAt(index);
      }
    });
  }

  @override
  void dispose() {
    imageUrlController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    prepTimeController.dispose();
    cookTimeController.dispose();
    servingsController.dispose();
    directionsController.dispose();
    notesController.dispose();
    sourcesController.dispose();
    ingredientsControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoggerService.logger.d('Ingredients data is: $ingredientsControllers');
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Future.delayed(Duration.zero, () {
                Navigator.pop(context);
              });
            },
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 96, 94, 94),
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () async {
                LoggerService.logger.i('button clicked');
                await updateRecipe();
              },
              icon: const Icon(
                Icons.done_rounded,
                color: const Color.fromARGB(255, 96, 94, 94),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Recipe',
              style: TextStyle(
                color: const Color.fromARGB(255, 54, 54, 54),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            buildImageField(),
            const SizedBox(height: 20),
            buildTextField(
              'Name',
              nameController,
              hintText: widget.recipe.name,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Description',
              descriptionController,
              hintText: widget.recipe.description,
              isExpanded: true,
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Prep Time',
              prepTimeController,
              hintText: '12 minutes',
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Cook Time',
              cookTimeController,
              hintText: widget.recipe.cookTime,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Servings',
              servingsController,
              hintText: widget.recipe.servings,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Directions',
              directionsController,
              hintText: widget.recipe.servings,
              isExpanded: true,
              maxLines: 2,
            ),
            SizedBox(height: 20),
            buildEditableIngredientsList(),
            const SizedBox(height: 20),
            buildTextField(
              'Notes',
              notesController,
              hintText: widget.recipe.notes,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Sources',
              sourcesController,
              hintText: widget.recipe.servings,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: ingredientsControllers.map((controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Ingredient',
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () => removeIngredientField(ingredientsControllers.indexOf(controller)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        TextButton.icon(
          onPressed: addIngredientField,
          icon: Icon(
            Icons.add,
            color: Color.fromARGB(255, 221, 56, 32),
          ),
          label: Text(
            "Add Ingredient",
            style: TextStyle(
              color: Color.fromARGB(255, 221, 56, 32),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(
    String title,
    TextEditingController controller, {
    String? hintText,
    bool isExpanded = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (Optional)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          maxLines: isExpanded ? null : maxLines,
          minLines: isExpanded ? maxLines : null,
          keyboardType: isExpanded ? TextInputType.multiline : TextInputType.text,
        ),
      ],
    );
  }

  Widget buildImageField() {
    return GestureDetector(
      onTap: () {
        selectImage();
      },
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                image!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          : (widget.recipe.imageUrl != null && widget.recipe.imageUrl!.isNotEmpty)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.recipe.imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : DottedBorder(
                  dashPattern: const [10, 6],
                  radius: const Radius.circular(10),
                  borderType: BorderType.RRect,
                  strokeWidth: 2,
                  strokeCap: StrokeCap.round,
                  color: Color.fromARGB(255, 212, 212, 216),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add Cover Photo',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '(up to 12 Mb)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<void> updateRecipe() async {
    try {
      //todo separate to business logic
      final supabase = Supabase.instance.client;
      await supabase
          .from(DBConstants.recipesTable)
          .update({
            'name': nameController.text.trim(),
            'description': descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
            'prep_time': prepTimeController.text.trim(),
            'cook_time': cookTimeController.text.trim(),
            'servings': servingsController.text.trim(),
            'image_url': imageUrlController.text.trim(),
            'directions': directionsController.text.trim(),
            'notes': notesController.text.trim(),
            'ingredients': ingredientsControllers.map((controller) => controller.text.trim()).toList(),
          })
          .eq('id', widget.recipe.id)
          .select();

      LoggerService.logger.i('Update successful');
      Navigator.pushAndRemoveUntil(context, Dashboard.route(), (route) => false);
    } catch (e) {
      LoggerService.logger.i('Exception during update: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error during update: $e')));
    }
  }
}
