import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6464FF)),
      ),
      home: const MyHomePage(title: 'Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _buttonText = "Chat";

  void _ChangeButtonText() {
    setState(() {
      _buttonText = "Button was clicked";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 2, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _ChangeButtonText,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(300, 100),
            backgroundColor: const Color(0xFF6464FF),
          ),
          child: Text(_buttonText),
        ),
      ),
    );
  }
}
