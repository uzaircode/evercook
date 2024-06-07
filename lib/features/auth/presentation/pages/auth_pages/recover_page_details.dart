import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/presentation/pages/auth_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecoverPasswordDetailsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const RecoverPasswordDetailsPage());
  const RecoverPasswordDetailsPage({super.key});

  @override
  State<RecoverPasswordDetailsPage> createState() => _RecoverPasswordDetailsPageState();
}

class _RecoverPasswordDetailsPageState extends State<RecoverPasswordDetailsPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetTokenController = TextEditingController();
  bool _passwordVisible = false;
  bool? isLoading;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: resetTokenController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Reset Token',
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
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                validator: (value) {
                  // Basic email validation
                  return value != null && value.contains('@') ? null : 'Enter a valid email';
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
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
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                      showSnackbar(context, 'Password Change', Colors.black);
                    } catch (e) {
                      showSnackbar(context, e.toString(), Colors.black);
                    }
                  } else {
                    showSnackbar(context, 'Isi dengan Benar!', Colors.black);
                  }
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
