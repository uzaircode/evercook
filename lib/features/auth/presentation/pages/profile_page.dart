import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart' as auth_bloc;
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocListener<auth_bloc.AuthBloc, auth_bloc.AuthState>(
        listener: (context, state) {
          if (state is auth_bloc.AuthSignedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              LoginPage.route(),
              (route) => false,
            );
          } else if (state is auth_bloc.AuthFailure) {
            showSnackBar(context, state.message);
          }
        },
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<auth_bloc.AuthBloc>().add(AuthSignOut());
                },
                child: const Text('Sign Out'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  LoggerService.logger.i('delete account button trigger');
                  final currentUserState = context.read<AppUserCubit>().state;
                  LoggerService.logger.i(currentUserState);
                  if (currentUserState is AppUserLoggedIn) {
                    LoggerService.logger.i('executing...');
                    LoggerService.logger.i(currentUserState.user.id);
                    context.read<auth_bloc.AuthBloc>().add(AuthDeleteAccount(userId: currentUserState.user.id));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text(
                  'Delete User Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
