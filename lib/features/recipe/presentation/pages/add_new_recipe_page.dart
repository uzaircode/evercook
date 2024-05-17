import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/utils/pick_image.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AddNewRecipePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewRecipePage(),
      );

  const AddNewRecipePage({super.key});

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
  final notesController = TextEditingController();
  final sourcesController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadRecipe() {
    if (formKey.currentState!.validate() && image != null) {
      final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

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
              image: image,
            ),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    prepTimeController.dispose();
    cookTimeController.dispose();
    imageUrlController.dispose();
    servingsController.dispose();
    notesController.dispose();
    sourcesController.dispose();
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
                    // RecipeEditor(controller: titleController, hintText: 'Title'),
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
                    // RecipeEditor(controller: descriptionController, hintText: 'Description'),
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
                    // RecipeEditor(controller: cookTimeController, hintText: 'Cook Time'),
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
                    // RecipeEditor(controller: prepTimeController, hintText: 'Prep Time'),
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
                    // RecipeEditor(controller: servingsController, hintText: 'Servings'),
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
                    // RecipeEditor(controller: notesController, hintText: 'Notes'),
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
                    // RecipeEditor(controller: sourcesController, hintText: 'Sources'),
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
