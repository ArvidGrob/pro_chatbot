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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Administrator",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6464FF),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardButton(
                    count: '880',
                    label: 'Student',
                    backgroundColor: const Color(0xFF6464FF),
                    iconBackgroundColor: const Color(0xFF8989FF),
                    icon: Icons.school,
                    onPressed: () {
                      print('Student button pressed');
                      // Navigate to Student page
                    },
                  ),
                  const SizedBox(height: 50),
                  DashboardButton(
                    count: '25',
                    label: 'Admin',
                    backgroundColor: const Color(0xFFFF6464),
                    iconBackgroundColor: const Color(0xFFFF898B),
                    icon: Icons.headset_mic,
                    onPressed: () {
                      print('Admins button pressed');
                      // Navigate to Admins page
                    },
                  ),
                  const SizedBox(height: 50),
                  DashboardButton(
                    count: '32',
                    label: 'Beheer',
                    backgroundColor: const Color(0xFF64FFC1),
                    iconBackgroundColor: const Color(0xFF89FFDF),
                    icon: Icons.description,
                    onPressed: () {
                      print('Beheer button pressed');
                      // Navigate to Beheer page
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF6464FF),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    print('Back button pressed');
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print('Profile button pressed');
                  },
                  icon: const Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String count;
  final String label;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final IconData icon;
  final VoidCallback onPressed;

  const DashboardButton({
    super.key,
    required this.count,
    required this.label,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 53,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Icon(
                icon,
                size: 115,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
