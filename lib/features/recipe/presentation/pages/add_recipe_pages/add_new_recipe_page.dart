import 'dart:io';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/utils/domain_validator.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/pick_image.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/widgets/add_new_recipe_page_widget.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AddNewRecipePage extends StatefulWidget {
  static route({
    String? name,
    String? description,
    String? servings,
    String? imageUrl,
    String? prepTime,
    String? cookTime,
    List<String>? ingredients,
    String? directions,
    String? notes,
    String? sources,
    String? utensils,
    bool? public,
  }) =>
      MaterialPageRoute(
        builder: (context) => AddNewRecipePage(
          imageUrl: imageUrl,
          name: name,
          description: description,
          prepTime: prepTime,
          cookTime: cookTime,
          servings: servings,
          ingredients: ingredients,
          directions: directions,
          notes: notes,
          sources: sources,
          utensils: utensils,
          public: public,
        ),
      );

  final String? imageUrl;
  final String? name;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final String? servings;
  final List<String>? ingredients;
  final String? directions;
  final String? notes;
  final String? sources;
  final String? utensils;
  final bool? public;

  const AddNewRecipePage({
    super.key,
    this.imageUrl,
    this.name,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.ingredients,
    this.directions,
    this.notes,
    this.sources,
    this.utensils,
    this.public,
  });

  @override
  State<AddNewRecipePage> createState() => _AddNewRecipePageState();
}

class _AddNewRecipePageState extends State<AddNewRecipePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final prepTimeController = TextEditingController();
  final cookTimeController = TextEditingController();
  final servingsController = TextEditingController();
  final imageUrlController = TextEditingController();
  final directionsController = TextEditingController();
  final notesController = TextEditingController();
  final sourcesController = TextEditingController();
  final utensilsController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;
  bool? isPublic = true;
  List<TextEditingController> ingredientsControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null) imageUrlController.text = widget.imageUrl!;
    if (widget.name != null) nameController.text = widget.name!;
    if (widget.description != null) descriptionController.text = widget.description!;
    if (widget.prepTime != null) prepTimeController.text = widget.prepTime!;
    if (widget.cookTime != null) cookTimeController.text = widget.cookTime!;
    if (widget.servings != null) servingsController.text = widget.servings!;
    if (widget.directions != null) directionsController.text = widget.directions!;
    if (widget.notes != null) notesController.text = widget.notes!;
    if (widget.sources != null) sourcesController.text = widget.sources!;
    LoggerService.logger.d(widget.ingredients);
    if (widget.ingredients != null) {
      ingredientsControllers = widget.ingredients!.map((ingredient) {
        return TextEditingController(text: ingredient);
      }).toList();
    } else {
      ingredientsControllers.add(TextEditingController());
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

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
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

  void uploadRecipe() async {
    if (formKey.currentState!.validate()) {
      final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

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
      LoggerService.logger.d(isPublic);

      context.read<RecipeBloc>().add(
            RecipeUpload(
              userId: userId,
              name: nameController.text.trim().isEmpty ? null : nameController.text.trim(),
              description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
              servings: servingsController.text.trim().isEmpty ? null : servingsController.text.trim(),
              image: imageFile,
              prepTime: prepTimeController.text.trim().isEmpty ? null : prepTimeController.text.trim(),
              cookTime: cookTimeController.text.trim().isEmpty ? null : cookTimeController.text.trim(),
              ingredients: widget.ingredients,
              directions: directionsController.text.isEmpty ? null : directionsController.text,
              notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
              sources: sourcesController.text.trim().isEmpty ? null : sourcesController.text.trim(),
              utensils: utensilsController.text.trim().isEmpty ? null : utensilsController.text.trim(),
              public: isPublic,
            ),
          );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    prepTimeController.dispose();
    cookTimeController.dispose();
    imageUrlController.dispose();
    servingsController.dispose();
    directionsController.dispose();
    notesController.dispose();
    sourcesController.dispose();
    for (var controller in ingredientsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //todo standardize for all
      appBar: AppBar(
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
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () => uploadRecipe(),
              icon: const Icon(Icons.done_rounded),
            ),
          ),
        ],
      ),
      body: BlocConsumer<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is RecipeFailure) {
            showSnackBar(context, state.error);
          } else if (state is RecipeUploadSuccess) {
            Navigator.pushAndRemoveUntil(context, Dashboard.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Recipe',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 20),
                    buildImageField(),
                    SizedBox(height: 20),
                    buildTextField(
                      'Name',
                      hintText: 'Type your recipe name here',
                      nameController,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Description',
                      descriptionController,
                      hintText: "What’s special about your recipe?",
                      isExpanded: true,
                      maxLines: 2,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Prep Time',
                      hintText: '12 minutes',
                      prepTimeController,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Cook Time',
                      hintText: '50 minutes',
                      cookTimeController,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Servings',
                      hintText: '4 servings',
                      servingsController,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Directions',
                      directionsController,
                      hintText: 'Add one or multiple steps (e.g. "transfer to a small bowl")',
                      isExpanded: true,
                      maxLines: 2,
                    ),
                    SizedBox(height: 20),
                    buildEditableIngredientsList(),
                    SizedBox(height: 20),
                    buildTextField(
                      'Notes',
                      hintText: 'Add tips or tricks for this recipe',
                      notesController,
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    buildTextField(
                      'Sources',
                      hintText: 'URL source',
                      sourcesController,
                      validator: DomainValidator.validate,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Utensils',
                      hintText: 'Utensils',
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
                                      fontWeight: FontWeight.bold, // Bold text for "Private"
                                      color: Colors.black87, // Black color text
                                      fontSize: 16, // Size of the text
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' - Visible to everyone',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 64, 64, 64),
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
                                      fontWeight: FontWeight.bold, // Bold text for "Private"
                                      color: Colors.black87, // Black color text
                                      fontSize: 16, // Size of the text
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' - Not visible to others',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 64, 64, 64),
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
          );
        },
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
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
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

  //todo move this widget to widget page
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
          : imageUrlController.text.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrlController.text,
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
