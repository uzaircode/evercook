import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/theme/theme_services.dart';
import 'package:evercook/core/theme_test/bloc/theme_test_bloc.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/auth_pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ProfilePage());
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedTheme = 'Light'; // Default theme
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      _nameController.text = appUserState.user.name;
      _emailController.text = appUserState.user.email;
      _avatarController.text = appUserState.user.avatar;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              alwaysShowMiddle: false,
              largeTitle: Text(
                'Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              middle: Text(
                'Profile',
                style: TextStyle(
                  fontFamily: GoogleFonts.notoSerif().fontFamily,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w700,
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    Dashboard.route(),
                    (route) => false,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: const Color.fromARGB(255, 96, 94, 94),
                    size: 22,
                  ),
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  _showModalBottomSheet(context, Supabase.instance.client.auth.currentSession!.user.id);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Icon(
                    Icons.more_vert_outlined,
                    color: const Color.fromARGB(255, 96, 94, 94),
                    size: 22,
                  ),
                ),
              ),
              // trailing: Switch(
              //   value: context.read<ThemeTestBloc>().state == ThemeMode.dark,
              //   onChanged: (value) {
              //     context.read<ThemeTestBloc>().add(ThemeChanged(value));
              //   },
              // ),
            ),
          ];
        },
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Info Container
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(22, 16, 22, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Personal Info', style: Theme.of(context).textTheme.titleMedium),
                                      Text(
                                        'Update your photo and personal details here',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                ClipOval(
                                  child: Image.network(
                                    _avatarController.text,
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Text(
                              'Full Name',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Password',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Primary Email',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: _emailController,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    // Features Container
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(22, 16, 22, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: 3),
                              Text(
                                'Customize your app interface',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'Active Theme',
                                  //   style: TextStyle(
                                  //     color: Theme.of(context).colorScheme.onBackground,
                                  //   ),
                                  // ),
                                  // SizedBox(height: 5),
                                  // Container(
                                  //   width: double.infinity,
                                  //   padding: EdgeInsets.symmetric(horizontal: 12),
                                  //   decoration: BoxDecoration(
                                  //     color: Theme.of(context).inputDecorationTheme.fillColor,
                                  //     borderRadius: BorderRadius.circular(8),
                                  //   ),
                                  //   child: DropdownButtonHideUnderline(
                                  //     child: DropdownButton<String>(
                                  //       isExpanded: true,
                                  //       value: selectedTheme,
                                  //       items: <String>['System', 'Light', 'Dark'].map((String value) {
                                  //         return DropdownMenuItem<String>(
                                  //           value: value,
                                  //           // Apply style to the text inside the dropdown
                                  //           child: Text(
                                  //             value,
                                  //             style: TextStyle(
                                  //               fontSize: 14,
                                  //               fontWeight: FontWeight.w600,
                                  //               color: Theme.of(context).colorScheme.onBackground,
                                  //             ),
                                  //           ), // Smaller text size
                                  //         );
                                  //       }).toList(),
                                  //       onChanged: (String? newValue) {
                                  //         if (newValue != null) {
                                  //           setState(() {
                                  //             selectedTheme = newValue;
                                  //             ThemeService().switchTheme(newValue);
                                  //           });
                                  //         }
                                  //       },
                                  //       dropdownColor: Theme.of(context).colorScheme.onBackground,
                                  //       underline: Container(
                                  //         height: 0,
                                  //       ),
                                  //       style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                                  //     ),
                                  //   ),
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Background Color',
                                        // style: Theme.of(context).c,
                                      ),
                                      Switch(
                                        value: context.read<ThemeTestBloc>().state == ThemeMode.dark,
                                        onChanged: (value) {
                                          context.read<ThemeTestBloc>().add(ThemeChanged(value));
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    // App Info Container
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(22, 16, 22, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Evercook',
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            Text(
                              'Version 1.0.0',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: 20),
                            ListView(
                              padding: EdgeInsetsDirectional.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsetsDirectional.zero,
                                  leading: Icon(Icons.feedback_outlined),
                                  title: Text(
                                    'Send Feedback',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onBackground,
                                    ),
                                  ),
                                  onTap: () async {
                                    await launchUrl(
                                      Uri.parse('mailto:nikuzairsc@gmail.com?subject=Feedback'),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> _showModalBottomSheet(BuildContext context, userId) {
    return showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.2),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.subdirectory_arrow_right_outlined),
                title: Text(
                  'Sign out',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 2),
                onTap: () {
                  context.read<AuthBloc>().add(AuthSignOut());
                },
              ),
              Divider(color: Colors.grey[300], thickness: 1),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete account',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                onTap: () async {
                  final bool? confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm Account Deletion'),
                        content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmed == true) {
                    LoggerService.logger.i('Button Clicked');
                    await Supabase.instance.client.rpc('delete_user_account', params: {'user_id': userId});
                    if (mounted) {
                      context.read<AuthBloc>().add(AuthSignOut());
                    }
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}





//todo separate to business logic
//   child: ElevatedButton(
//     onPressed: () async {
//       LoggerService.logger.i('Button Clicked');
//       await Supabase.instance.client.rpc('delete_user_account', params: {'user_id': userId});
//       if (mounted) {
//         context.read<AuthBloc>().add(AuthSignOut());
//       }
//                          context.read<AuthBloc>().add(AuthSignOut());
// leading: GestureDetector(
//   onTap: () {
//     ThemeService().switchTheme();
//   },
//   child: Icon(Icons.cloud),
// ),