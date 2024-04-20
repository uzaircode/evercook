import 'package:evercook/main.dart';
import 'package:evercook/routes/routes.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await Future.delayed(Duration.zero);
    // final session = supabase.auth.currentSession;
    // if (session != null) {
    //   Navigator.of(context).pushReplacementNamed(RoutesClass.dashboard);
    // } else {
    //   Navigator.of(context).pushReplacementNamed(RoutesClass.login);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
