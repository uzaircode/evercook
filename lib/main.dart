import 'package:evercook/pages/account_page.dart';
import 'package:evercook/pages/login_page.dart';
import 'package:evercook/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://kgsxuikuszgctqdlwbfu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtnc3h1aWt1c3pnY3RxZGx3YmZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE4MDYwMjYsImV4cCI6MjAyNzM4MjAyNn0.BEOCoC67fb9xSuT9fQZUKGR6NOd7zhhKLdssZGDdZbk',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/account': (context) => const AccountPage(),
      },
    );
  }
}
