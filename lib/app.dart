
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class TacAnProjectApp extends StatelessWidget {
  const TacAnProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-FORECAST',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
