import 'dart:io';
import 'dart:math';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/theme/bloc/theme_bloc.dart';
import 'package:evercook/core/theme/profile_theme.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/pick_image.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/auth_pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart' as auth_bloc;

class ProfilePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ProfilePage());
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedTheme = 'Light'; // Default theme
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();
  File? image;

  String _themeName(CustomThemeMode themeMode) {
    switch (themeMode) {
      case CustomThemeMode.system:
        return 'System preference';
      case CustomThemeMode.light:
        return 'Light Theme';
      case CustomThemeMode.dark:
        return 'Dark Theme';
      case CustomThemeMode.pink:
        return 'Pink Theme';
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  Future<File> convertUrlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath${rng.nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  void _saveProfile() {
    final username = _nameController.text.trim();
    final bio = _bioController.text.trim();

    context.read<AuthBloc>().add(
          AuthUpdateUser(
            name: username,
            bio: bio,
            image: image,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      _nameController.text = appUserState.user.name;
      _bioController.text = appUserState.user.bio;
      _emailController.text = appUserState.user.email;
      _avatarController.text = appUserState.user.avatar;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
  }

  CustomThemeMode _getCurrentThemeMode(Brightness brightness) {
    var _currentTheme = context.read<ThemeCubit>().state;
    if (_currentTheme == CustomThemeMode.system) {
      return brightness == Brightness.dark ? CustomThemeMode.dark : CustomThemeMode.light;
    }
    return _currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    var _currentTheme = context.watch<ThemeCubit>().state;
    CustomThemeMode effectiveThemeMode = _getCurrentThemeMode(MediaQuery.of(context).platformBrightness);

    return Scaffold(
      backgroundColor: profilePageTheme[effectiveThemeMode],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              alwaysShowMiddle: false,
              backgroundColor: profilePageTheme[effectiveThemeMode],
              border: Border(),
              largeTitle: Text(
                'Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              middle: Text(
                'Profile',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                    Dashboard.route(),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appBarBackgroundIconTheme[effectiveThemeMode],
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: appBarIconTheme[effectiveThemeMode],
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
                    color: appBarBackgroundIconTheme[effectiveThemeMode],
                  ),
                  child: Icon(
                    Icons.more_vert_outlined,
                    color: appBarIconTheme[effectiveThemeMode],
                    size: 22,
                  ),
                ),
              ),
            ),
          ];
        },
        body: BlocConsumer<AppUserCubit, AppUserState>(
          listener: (context, state) {
            if (state is AppUserInitial) {
              Navigator.pushAndRemoveUntil(
                context,
                LoginPage.route(),
                (route) => false,
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
                    BlocListener<AuthBloc, auth_bloc.AuthState>(
                      listener: (context, state) {
                        if (state is AuthUpdateUserSuccess) {
                          context.read<AppUserCubit>().updateUserData(state.updatedUser);
                          showSuccessSnackBar(context, 'Profile updated successfully');
                          _nameController.text = state.updatedUser.name;
                          _bioController.text = state.updatedUser.bio;
                          _emailController.text = state.updatedUser.email;
                        }
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: boxDecorationColorTheme[effectiveThemeMode],
                          //here
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
                                  SizedBox(width: 35),
                                  GestureDetector(
                                    onTap: selectImage,
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: image != null
                                          ? FileImage(image!)
                                          : (_avatarController.text.isNotEmpty
                                              ? NetworkImage(_avatarController.text)
                                              : AssetImage('assets/images/default_avatar.png')) as ImageProvider,
                                      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                  fillColor: inputFillColorTheme[effectiveThemeMode],
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Bio',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                              ),
                              SizedBox(height: 5),
                              TextField(
                                controller: _bioController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: inputFillColorTheme[effectiveThemeMode],
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
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
                                  fillColor: inputFillColorTheme[effectiveThemeMode],
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: BlocBuilder<AuthBloc, auth_bloc.AuthState>(
                                  builder: (context, state) {
                                    return ElevatedButton(
                                      onPressed: state is AuthLoading
                                          ? null
                                          : () {
                                              _saveProfile();
                                            },
                                      child: state is AuthLoading
                                          ? SizedBox(
                                              height: 13,
                                              width: 13,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context).colorScheme.background,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              'Save',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.background,
                                              ),
                                            ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    // Features Container
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: boxDecorationColorTheme[effectiveThemeMode],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(22, 16, 22, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: 5.0),
                              Text(
                                'Customize your app interface',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(height: 16.0),
                              PopupMenuButton<CustomThemeMode>(
                                initialValue: context.watch<ThemeCubit>().state,
                                onSelected: (theme) {
                                  context.read<ThemeCubit>().updateTheme(theme);
                                  setState(() {
                                    effectiveThemeMode = theme;
                                  });
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<CustomThemeMode>>[
                                  PopupMenuItem<CustomThemeMode>(
                                    value: CustomThemeMode.system,
                                    child: Text(
                                      'System preference',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onTertiary,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<CustomThemeMode>(
                                    value: CustomThemeMode.light,
                                    child: Text(
                                      'Light Theme',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onTertiary,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<CustomThemeMode>(
                                    value: CustomThemeMode.dark,
                                    child: Text(
                                      'Dark Theme',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onTertiary,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<CustomThemeMode>(
                                    value: CustomThemeMode.pink,
                                    child: Text(
                                      'Pink Theme',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onTertiary,
                                      ),
                                    ),
                                  ),
                                ],
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: const Color.fromARGB(255, 128, 127, 127)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _themeName(_currentTheme),
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      Icon(Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                ),
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
                        color: boxDecorationColorTheme[effectiveThemeMode],
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
                                  leading: FaIcon(FontAwesomeIcons.paperPlane),
                                  title: Text(
                                    'Send Feedback',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onBackground,
                                    ),
                                  ),
                                  onTap: () async {
                                    await launchUrl(
                                      Uri.parse('mailto:nikuzairsc@gmail.com?subject=Evercook Application - Feedback'),
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
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).dividerTheme.color!,
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
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  context.read<AuthBloc>().add(AuthSignOut());
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.account_circle_outlined,
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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delete Account',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        content: Text('Are you sure you want to delete your account?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Color.fromARGB(255, 221, 56, 32),
                              ),
                            ),
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
