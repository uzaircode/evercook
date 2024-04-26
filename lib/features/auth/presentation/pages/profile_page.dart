import 'package:evercook/core/utils/analytics_engine.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
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
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              AnalyticsEngine.triggerButton();
              context.read<AuthBloc>().add(AuthSignOut());
            },
            child: const Text('Sign Out'),
          ),
        ),
      ),
    );
  }
}
