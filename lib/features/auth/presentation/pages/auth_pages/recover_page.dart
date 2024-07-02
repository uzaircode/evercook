import 'package:email_validator/email_validator.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/common/widgets/snackbar/show_fail_snackbar.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/auth_pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecoverPasswordPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const RecoverPasswordPage());

  const RecoverPasswordPage({Key? key}) : super(key: key);

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final emailController = TextEditingController();
  final resetTokenController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool? isLoading;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          onPressed: () {
            Future.delayed(
              Duration.zero,
              () {
                Navigator.pop(context);
              },
            );
          },
          icon: const Icon(
            CupertinoIcons.left_chevron,
          ),
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot Password',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  filled: true,
                  hintText: 'Type your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 4.0, top: 1.0, bottom: 1.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        showSuccessSnackBar(context, 'Check your email and spam folder for the token.');
                        BlocProvider.of<AuthBloc>(context).add(AuthRecoverPassword(email: emailController.text));
                        LoggerService.logger.i('Send Token to ${emailController.text}');
                      },
                      child: const Text('Send Token'),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 192, 191, 191), // Same color as focusedBorder for consistency
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 192, 191, 191),
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                validator: (value) => !EmailValidator.validate(value!) ? 'Invalid Email Format' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: resetTokenController,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  filled: true,
                  hintText: 'Type the token',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 192, 191, 191), // Same color as focusedBorder for consistency
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 192, 191, 191),
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Invalid token!';
                  }
                  return null;
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  filled: true,
                  hintText: 'Type your new password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 192, 191, 191), // Same color as focusedBorder for consistency
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 192, 191, 191),
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters!';
                  }
                  return null;
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                      side: BorderSide.none,
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) => const Center(child: Loader()),
                      );
                      try {
                        //todo separate to business logic
                        final recovery = await Supabase.instance.client.auth.verifyOTP(
                          email: emailController.text,
                          token: resetTokenController.text,
                          type: OtpType.recovery,
                        );
                        LoggerService.logger.d(recovery);
                        //todo separate to business logic
                        await Supabase.instance.client.auth.updateUser(
                          UserAttributes(password: passwordController.text),
                        );
                        isLoading = false;
                        Navigator.pushAndRemoveUntil(
                          context,
                          LoginPage.route(),
                          (route) => false,
                        );
                        showSuccessSnackBar(context, 'Password Successfully Changed');
                      } catch (e) {
                        showFailSnackbar(context, e.toString());
                      }
                    }
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
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
