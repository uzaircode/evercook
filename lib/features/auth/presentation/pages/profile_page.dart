import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:evercook/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ProfilePage());
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userName = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    final userEmail = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    final userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AppUserCubit, AppUserState>(
          listener: (context, state) {
            if (state is AppUserInitial) {
              Navigator.pushReplacement(
                context,
                LoginPage.route(),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: const Color.fromARGB(255, 238, 198, 202),
                    backgroundImage: NetworkImage(
                      'https://robohash.org/$userId',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          EditProfilePage.route(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 244, 118, 160),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        _buildListTile('Help Center', Icons.help_outline_outlined, Colors.black, () {}),
                        _buildListTile('Rate the App', Icons.star_outline, Colors.black, () {}),
                        _buildListTile('Privacy Policy', Icons.privacy_tip_outlined, Colors.black, () {}),
                        _buildListTile('Logout', Icons.exit_to_app_outlined, Colors.red, () {
                          context.read<AuthBloc>().add(AuthSignOut());
                        }),
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

  Widget _buildListTile(String title, IconData icon, Color textColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(247, 241, 241, 240),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: FaIcon(
                  icon,
                  color: textColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const FaIcon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 152, 151, 151),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//   child: ElevatedButton(
//     onPressed: () async {
//       LoggerService.logger.i('Button Clicked');
//       await Supabase.instance.client.rpc('delete_user_account', params: {'user_id': userId});
//       if (mounted) {
//         // Safely use context
//         context.read<AuthBloc>().add(AuthSignOut());
//       }
