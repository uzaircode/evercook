import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart' as auth_bloc;
import 'package:evercook/features/auth/presentation/pages/recover_page.dart';
import 'package:evercook/features/auth/presentation/pages/signup_page.dart';
import 'package:evercook/features/auth/presentation/widgets/auth_button.dart';
import 'package:evercook/features/auth/presentation/widgets/auth_field.dart';
import 'package:evercook/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<auth_bloc.AuthBloc, auth_bloc.AuthState>(
          listener: (context, state) {
            if (state is auth_bloc.AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is auth_bloc.AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                Dashboard.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is auth_bloc.AuthLoading) {
              return const Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                children: [
                  AuthField(controller: _emailController, hintText: 'Email'),
                  const SizedBox(height: 15),
                  AuthField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isObscureText: true,
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        RecoverPasswordPage.route(),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Forgot Password? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Recover Password',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  AuthButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<auth_bloc.AuthBloc>().add(
                                auth_bloc.AuthLogin(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                      buttonText: 'Sign In'),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        SignUpPage.route(),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      const webClientId = '908468362758-rdalsblfhdl2nbnh9bui78ubgmhdboi3.apps.googleusercontent.com';
                      const iosClientId = '908468362758-m5a317hnbtj1ji5mqrrj30ehr34k9bs4.apps.googleusercontent.com';

                      final GoogleSignIn googleSignIn = GoogleSignIn(
                        clientId: iosClientId,
                        serverClientId: webClientId,
                      );
                      final googleUser = await googleSignIn.signIn();
                      final googleAuth = await googleUser!.authentication;
                      final accessToken = googleAuth.accessToken;
                      final idToken = googleAuth.idToken;

                      if (accessToken == null) {
                        throw 'No Access Token found.';
                      }
                      if (idToken == null) {
                        throw 'No ID Token found.';
                      }

                      await Supabase.instance.client.auth.signInWithIdToken(
                        provider: OAuthProvider.google,
                        idToken: idToken,
                        accessToken: accessToken,
                      );
                      if (Supabase.instance.client.auth.currentUser == null) {
                        throw 'Failed to sign in with Google.';
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          Dashboard.route(),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text('Sign in with google'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
