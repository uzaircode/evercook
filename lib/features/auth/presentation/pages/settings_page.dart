import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SettingsPage());
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Feedback'),
              onTap: () async {
                await launchUrl(
                  Uri.parse('mailto:nikuzairsc@gmail.com?subject=Feedback'),
                );
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 55,
              // TODO UI: ask for confirmation popup
              child: ElevatedButton(
                onPressed: () async {
                  LoggerService.logger.i('Button Clicked');
                  await Supabase.instance.client.rpc('delete_user_account', params: {'user_id': userId});
                  //! AUTH SIGN OUT MIGHT NOT BE SUITABLE, POTENTIAL BUG!
                  //** user can go back prev page */
                  if (mounted) {
                    // Safely use context
                    context.read<AuthBloc>().add(AuthSignOut());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // background color
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
