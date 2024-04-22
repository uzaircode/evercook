import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/utils/pick_image.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/pages/home_page.dart';
import 'package:evercook/features/recipe/presentation/widgets/recipe_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class UpdateRecipePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const UpdateRecipePage(),
      );

  const UpdateRecipePage({super.key});

  @override
  State<UpdateRecipePage> createState() => _UpdateRecipePage();
}

class _UpdateRecipePage extends State<UpdateRecipePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final prepTimeController = TextEditingController();
  final cookTimeController = TextEditingController();
  final servingsController = TextEditingController();
  final imageUrlController = TextEditingController();
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
            RecipeUpdate(
              userId: userId,
              title: titleController.text,
              description: descriptionController.text,
              prepTime: prepTimeController.text,
              cookTime: cookTimeController.text,
              servings: int.parse(servingsController.text),
              image: image!,
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
    servingsController.dispose();
    imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update a Recipe'),
        actions: [
          IconButton(
            onPressed: () => uploadRecipe(),
            icon: const Icon(Icons.done_all_outlined),
          ),
        ],
      ),
      body: BlocConsumer<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is RecipeFailure) {
            showSnackBar(context, state.error);
          } else if (state is RecipeUpdateSuccess) {
            Navigator.pushAndRemoveUntil(context, HomePage.route(), (route) => false);
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
                    RecipeEditor(
                      controller: titleController,
                      hintText: 'Title',
                    ),
                    const SizedBox(height: 10),
                    RecipeEditor(controller: descriptionController, hintText: 'Description'),
                    const SizedBox(height: 10),
                    RecipeEditor(controller: cookTimeController, hintText: 'Cook Time'),
                    const SizedBox(height: 10),
                    RecipeEditor(controller: prepTimeController, hintText: 'Prep Time'),
                    const SizedBox(height: 10),
                    RecipeEditor(controller: servingsController, hintText: 'Servings'),
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
