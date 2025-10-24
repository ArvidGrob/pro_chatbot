import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6464FF)),
        useMaterial3: true,
      ),
      home: const LoginPage(), // <- Startscreen
    );
  }
}
