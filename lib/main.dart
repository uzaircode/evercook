import 'package:evercook/core/common/pages/splash_screen.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/observer/bloc_observer.dart';
import 'package:evercook/core/theme/bloc/theme_bloc.dart';
import 'package:evercook/core/theme/theme.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evercook/features/auth/presentation/pages/auth_pages/login_page.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/init_dependencies.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await GetStorage.init();
  await initDependencies();

  Bloc.observer = MyBlocObserver();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<RecipeBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ThemeCubit>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, CustomThemeMode>(
      builder: (context, themeMode) {
        ThemeMode materialThemeMode;
        ThemeData themeData;

        switch (themeMode) {
          case CustomThemeMode.light:
            materialThemeMode = ThemeMode.light;
            themeData = lightTheme;
            break;
          case CustomThemeMode.dark:
            materialThemeMode = ThemeMode.dark;
            themeData = darkTheme;
            break;
          case CustomThemeMode.pink:
            materialThemeMode = ThemeMode.light; // Pink theme will be used as a light theme
            themeData = pinkTheme;
            break;
          case CustomThemeMode.system:
          default:
            materialThemeMode = ThemeMode.system;
            themeData = MediaQuery.of(context).platformBrightness == Brightness.dark ? darkTheme : lightTheme;
            break;
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Evercook',
          themeMode: materialThemeMode,
          theme: themeData,
          darkTheme: darkTheme,
          home: _isLoading
              ? SplashScreen()
              : BlocSelector<AppUserCubit, AppUserState, bool>(
                  selector: (state) {
                    return state is AppUserLoggedIn;
                  },
                  builder: (context, isLoggedIn) {
                    return isLoggedIn ? const Dashboard() : const LoginPage();
                  },
                ),
        );
      },
    );
  }
}
