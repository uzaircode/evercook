import 'package:email_validator/email_validator.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/recover_page_details.dart';
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
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: 'Email',
                ),
                validator: (value) => !EmailValidator.validate(value!) ? 'Invalid Email Format!' : null,
              ),
              const SizedBox(width: 16, height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        content: Text(
                          'Please Check Your Email & Spam Folder for the TOKEN if Not Found in Inbox!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    // await Supabase.instance.client.auth.resetPasswordForEmail(
                    //   emailController.text,
                    // );
                    BlocProvider.of<AuthBloc>(context).add(AuthRecoverPassword(email: emailController.text));

                    LoggerService.logger.i('Password Reset Token Sent to ${emailController.text}');
                  } else {
                    null;
                  }
                },
                child: const Text('Send Password Reset Token'),
              ),
              const SizedBox(width: 16, height: 16),
              TextButton(
                child: const Text('Already Have the Token? Reset Your Password'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    RecoverPasswordDetailsPage.route(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
