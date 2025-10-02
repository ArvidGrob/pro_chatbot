import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administrator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print('Button 1 pressed');
              },
              child: const Text('Button 1'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Button 2 pressed');
              },
              child: const Text('Button 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Button 3 pressed');
              },
              child: const Text('Button 3'),
            ),
          ],
        ),
      ),
    );
  }
}
