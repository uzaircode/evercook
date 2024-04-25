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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSignedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              LoginPage.route(),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            if (state is AppUserLoggedIn) {
              final User user = state.user;
              return _buildProfile(user, context);
            } else {
              // Handle other states if needed
              return Container();
            }
          },
        ),
      ),
    );
  }

  Align _buildProfile(User user, BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(user.name),
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
  }
}
