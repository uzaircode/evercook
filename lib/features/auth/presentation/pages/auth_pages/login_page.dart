import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
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
      appBar: AppBar(),
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
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60.0,
                              height: 60.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1.0),
                                child: Image.asset(
                                  'assets/images/ic_launcher.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Evercook',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Please login to continue.',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
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
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 65,
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
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                thickness: 1.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("or"),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                thickness: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 65,
                          child: ElevatedButton(
                            onPressed: () async {
                              BlocProvider.of<AuthBloc>(context).add(AuthUserSignInWithGoogle());
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Sign in with google'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
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
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
