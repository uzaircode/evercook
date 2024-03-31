import 'package:evercook/pages/dashboard/dashboard_binding.dart';
import 'package:evercook/pages/dashboard/dashboard_page.dart';
import 'package:evercook/pages/login_page.dart';
import 'package:evercook/middleware/splash_page.dart';
import 'package:get/get.dart';

class RoutesClass {
  static String home = '/';
  static String login = '/login';
  static String dashboard = '/dashboard';

  static String getHomeRoute() => home;
  static String getLoginRoute() => login;
  static String getDashboardRoute() => dashboard;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const SplashPage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: dashboard, page: () => const DashboardPage(), binding: DashboardBinding()),
  ];
}
