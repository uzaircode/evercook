import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/common/widgets/snackbar/show_fail_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart' as auth_bloc;
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/auth_pages/recover_page.dart';
import 'package:evercook/features/auth/presentation/pages/auth_pages/signup_page.dart';
import 'package:evercook/features/auth/presentation/widgets/auth_button.dart';
import 'package:evercook/features/auth/presentation/widgets/auth_field.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
        child: BlocConsumer<auth_bloc.AuthBloc, auth_bloc.AuthState>(
          listener: (context, state) {
            if (state is auth_bloc.AuthFailure) {
              showFailSnackbar(context, state.message);
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
                  Expanded(
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        AuthField(
                          controller: _emailController,
                          hintText: 'Email',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 15),
                        AuthField(
                          controller: _passwordController,
                          hintText: 'Password',
                          isObscureText: true,
                          icon: Icons.lock,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              RecoverPasswordPage.route(),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Colors.black87, // Customize the color if needed
                                  fontWeight: FontWeight.bold, // Customize the font weight if needed
                                ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: AuthButton(
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
                            buttonText: 'Login',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).dividerColor,
                                thickness: 0.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "or",
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).dividerColor,
                                thickness: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: AuthButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                SignUpPage.route(),
                              );
                            },
                            buttonText: 'Signup',
                            isReversed: true, // Set to true to reverse the colors
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 55), // Adjust the height as needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36),
                                side: BorderSide(color: const Color.fromARGB(255, 186, 185, 185)), //
                              ),
                            ),
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context).add(AuthUserSignInWithGoogle());
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                  image: AssetImage("assets/images/google_icon.png"),
                                  height: 36.0,
                                  width: 41,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
