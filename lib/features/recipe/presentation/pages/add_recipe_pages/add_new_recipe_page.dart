import 'dart:io';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/utils/domain_validator.dart';
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
  final formKey = GlobalKey<FormState>();
  File? image;

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
                      style: TextStyle(
                        color: const Color.fromARGB(255, 54, 54, 54),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
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
                    buildTextField(
                      'Notes',
                      hintText: 'Add tips or tricks for this recipe',
                      notesController,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Sources',
                      hintText: 'URL source',
                      sourcesController,
                      validator: DomainValidator.validate,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
