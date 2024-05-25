import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/pick_image.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AddNewRecipePage extends StatefulWidget {
  static route({
    String? imageUrl,
    String? title,
    String? description,
    String? prepTime,
    String? cookTime,
    String? servings,
    String? directions,
    String? notes,
    String? sources,
  }) =>
      MaterialPageRoute(
        builder: (context) => AddNewRecipePage(
          imageUrl: imageUrl,
          title: title,
          description: description,
          prepTime: prepTime,
          cookTime: cookTime,
          servings: servings,
          directions: directions,
          notes: notes,
          sources: sources,
        ),
      );

  final String? imageUrl;
  final String? title;
  final String? description;
  final String? prepTime;
  final String? cookTime;
  final String? servings;
  final String? directions;
  final String? notes;
  final String? sources;

  const AddNewRecipePage({
    super.key,
    this.imageUrl,
    this.title,
    this.description,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.directions,
    this.notes,
    this.sources,
  });

  @override
  State<AddNewRecipePage> createState() => _AddNewRecipePageState();
}

class _AddNewRecipePageState extends State<AddNewRecipePage> {
  final titleController = TextEditingController();
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
    if (widget.title != null) titleController.text = widget.title!;
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
              title: titleController.text.trim().isEmpty ? null : titleController.text.trim(),
              description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
              prepTime: prepTimeController.text.trim().isEmpty ? null : prepTimeController.text.trim(),
              cookTime: cookTimeController.text.trim().isEmpty ? null : cookTimeController.text.trim(),
              servings: int.tryParse(servingsController.text.trim()),
              notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
              sources: sourcesController.text.trim().isEmpty ? null : sourcesController.text.trim(),
              image: imageFile,
            ),
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
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

  Future<void> fetchRecipe() async {
    var url = Uri.parse(
        'https://54df-2001-f40-94e-2131-c1a-d0af-5d36-c566.ngrok-free.app/recipe?url=https://resepichenom.com/resepi/laksam-lembut-kuah-berlemak-sedap/show');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        setState(() {
          titleController.text = jsonResponse['title'] ?? '';
          descriptionController.text = jsonResponse['description'] ?? '';
          prepTimeController.text = jsonResponse['prepTime'] ?? '';
          cookTimeController.text = jsonResponse['cookTime'] ?? '';
          servingsController.text = jsonResponse['servings'] ?? '';
          directionsController.text = jsonResponse['instructions'] ?? '';
          notesController.text = jsonResponse['notes'] ?? '';
          sourcesController.text = jsonResponse['sources'] ?? '';
          imageUrlController.text = jsonResponse['imageUrl'] ?? '';
        });

        LoggerService.logger.i(jsonResponse.toString());
      } else {
        LoggerService.logger.e('Request failed with status: ${response.statusCode}');
        showSnackBar(context, 'Failed to load recipes: Server error ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.logger.e('Error fetching recipes: $e');
      showSnackBar(context, 'Failed to load recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Recipe'),
        actions: [
          IconButton(
            onPressed: () => uploadRecipe(),
            icon: const Icon(Icons.done_rounded),
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
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : imageUrlController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Logger().d('Image selected');
                                  selectImage();
                                },
                                child: DottedBorder(
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
                                        Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Select your image',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: cookTimeController,
                      decoration: const InputDecoration(
                        hintText: 'Cook Time',
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: prepTimeController,
                      decoration: const InputDecoration(
                        hintText: 'Prep Time',
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: servingsController,
                      decoration: const InputDecoration(
                        hintText: 'Servings',
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: directionsController,
                      decoration: const InputDecoration(
                        hintText: 'Directions',
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        hintText: 'Notes',
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: sourcesController,
                      decoration: const InputDecoration(
                        hintText: 'Sources',
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
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
}
