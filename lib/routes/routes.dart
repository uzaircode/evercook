import 'package:evercook/features/auth/presentation/pages/signup_page.dart';
import 'package:evercook/pages/dashboard/dashboard_binding.dart';
import 'package:evercook/pages/dashboard/dashboard_page.dart';
import 'package:evercook/features/auth/presentation/pages/login_page.dart';
import 'package:evercook/middleware/splash_page.dart';
import 'package:evercook/pages/recipe/recipe_details.dart';
import 'package:get/get.dart';

class RoutesClass {
  static String home = '/';
  static String login = '/login';
  static String dashboard = '/dashboard';
  static String recipeDetails = '/recipeDetails';

  static String getHomeRoute() => login;
  static String getLoginRoute() => login;
  static String getDashboardRoute() => dashboard;
  static String getRecipeDetailsRoute() => recipeDetails;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const SplashPage()),
    GetPage(name: login, page: () => SignUpPage()),
    GetPage(name: dashboard, page: () => const DashboardPage(), binding: DashboardBinding()),
    GetPage(name: recipeDetails, page: () => const RecipeDetails()),
  ];
}
