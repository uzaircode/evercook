import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/common/widgets/snackbar/show_fail_snackbar.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/pick_image.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
  late TextEditingController utensilsController;
  late bool isPublic;
  late List<TextEditingController> ingredientsControllers;
  File? image;
  bool _isLoading = false; // Add this variable

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
    utensilsController = TextEditingController(text: widget.recipe.utensils ?? '');
    isPublic = widget.recipe.public ?? true;
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

  Future<File> convertUrlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath${rng.nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> uploadRecipe() async {
    File? imageFile;

    // Check if there's a locally picked image
    if (image != null) {
      imageFile = image;
    } else {
      // If no locally picked image, check if there's a URL provided and convert it
      if (imageUrlController.text.trim().isNotEmpty) {
        imageFile = await convertUrlToFile(imageUrlController.text.trim());
      }
    }

    LoggerService.logger.i('image file is null? : ${imageFile}');

    context.read<RecipeBloc>().add(
          RecipeEdit(
            id: widget.recipe.id,
            userId: Supabase.instance.client.auth.currentSession!.user.id,
            name: nameController.text.trim(),
            description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
            prepTime: prepTimeController.text.trim(),
            cookTime: cookTimeController.text.trim(),
            servings: servingsController.text.trim(),
            image: imageFile,
            directions: directionsController.text.trim(),
            notes: notesController.text.trim(),
            ingredients: ingredientsControllers.map((controller) => controller.text.trim()).toList(),
            sources: sourcesController.text.trim().isEmpty ? null : sourcesController.text.trim(),
            utensils: utensilsController.text.trim().isEmpty ? null : utensilsController.text.trim(),
            public: isPublic,
          ),
        );
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
    return BlocConsumer<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is RecipeDisplaySuccess) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            Dashboard.route(),
            (route) => false,
          );
          showSuccessSnackBar(context, 'Recipe updated successfully');
        } else if (state is RecipeFailure) {
          setState(() {
            _isLoading = false;
          });
          showFailSnackbar(context, state.error);
        } else if (state is RecipeLoading) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                leading: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () {
                      Future.delayed(Duration.zero, () {
                        Navigator.pop(context);
                      });
                    },
                    icon: const Icon(
                      CupertinoIcons.left_chevron,
                    ),
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                actions: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () async {
                        LoggerService.logger.i('button clicked');
                        await uploadRecipe(); // Wait for the uploadRecipe method
                      },
                      icon: Icon(
                        Icons.done_rounded,
                        color: Theme.of(context).colorScheme.onTertiary,
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
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    buildImageField(),
                    const SizedBox(height: 20),
                    buildTextField(
                      'Name',
                      context,
                      nameController,
                      hintText: widget.recipe.name,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      'Description',
                      context,
                      descriptionController,
                      hintText: widget.recipe.description,
                      isExpanded: true,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      'Prep Time',
                      context,
                      prepTimeController,
                      hintText: '12 minutes',
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      'Cook Time',
                      context,
                      cookTimeController,
                      hintText: widget.recipe.cookTime,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      'Servings',
                      context,
                      servingsController,
                      hintText: widget.recipe.servings,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      'Directions',
                      context,
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
                      context,
                      notesController,
                      hintText: widget.recipe.notes,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      'Sources',
                      context,
                      sourcesController,
                      hintText: widget.recipe.servings,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      'Utensils',
                      hintText: 'Utensils',
                      context,
                      utensilsController,
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sharing Option',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsetsDirectional.zero,
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Public',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' - Visible to everyone',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: isPublic,
                              activeColor: Color.fromARGB(255, 221, 56, 32),
                              onChanged: (bool? value) {
                                setState(() {
                                  isPublic = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsetsDirectional.zero,
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Private',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' - Not visible to others',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            leading: Radio<bool>(
                              value: false,
                              groupValue: isPublic,
                              activeColor: Color.fromARGB(255, 221, 56, 32),
                              onChanged: (bool? value) {
                                setState(() {
                                  isPublic = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              ModalBarrier(
                dismissible: false,
                color: Colors.black.withOpacity(0.5),
              ),
            if (_isLoading)
              Center(
                child: Loader(),
              ),
          ],
        );
      },
    );
  }

  Widget buildEditableIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: Theme.of(context).textTheme.titleSmall,
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
    BuildContext context,
    TextEditingController controller, {
    String? hintText,
    bool isExpanded = false,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (Optional)',
          style: Theme.of(context).textTheme.titleSmall,
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
          minLines: isExpanded ? (maxLines ?? 3) : null,
          keyboardType: isExpanded ? TextInputType.multiline : TextInputType.text,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
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
                  child: CachedNetworkImage(
                    imageUrl: widget.recipe.imageUrl!,
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
}
