import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      );
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    final bio = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.bio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthUpdateUserSuccess) {
            LoggerService.logger.i('triggered!');
            showSnackBar(context, 'User Updated');
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundColor: AppPallete.gradient3,
                        child: Center(
                          child: Text(
                            'No Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                      ),
                      validator: (value) {
                        return value;
                      },
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        hintText: 'Bio',
                      ),
                      validator: (value) {
                        return value;
                      },
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthUpdateUser(
                            name: _usernameController.text.trim(),
                            bio: _bioController.text.trim(),
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 244, 118, 160),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
