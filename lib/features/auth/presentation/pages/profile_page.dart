import 'package:evercook/core/common/entities/user.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userName = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocConsumer<AppUserCubit, AppUserState>(
        listener: (context, state) {
          if (state is AppUserInitial) {
            Navigator.pushReplacement(
              context,
              LoginPage.route(),
            );
          }
        },
        builder: (context, state) {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(userName),
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 80,
                    backgroundColor: AppPallete.gradient3,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        EditProfilePage.route(),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthSignOut());
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
