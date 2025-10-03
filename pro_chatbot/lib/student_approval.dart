import 'package:flutter/material.dart';

// Temporary main function for debugging/preview
void main() {
  runApp(const StudentApprovalApp());
}

class StudentApprovalApp extends StatelessWidget {
  const StudentApprovalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Approval',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StudentApprovalPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentApprovalPage extends StatefulWidget {
  const StudentApprovalPage({super.key});

  @override
  State<StudentApprovalPage> createState() => _StudentApprovalPageState();
}

class _StudentApprovalPageState extends State<StudentApprovalPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6B5CE7), // Purple
              Color(0xFF4F46E5), // Blue purple
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section
              _buildHeader(), // Search section
              _buildSearchSection(),

              // Content sections
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Pending requests section
                      _buildPendingSection(),

                      const SizedBox(height: 30),

                      // Approved requests section
                      _buildApprovedSection(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // Build header with title
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Administrator',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Build search section
  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (query) {
            // TODO: Implement search functionality when database is connected
          },
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Zoeken...',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[500],
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  // Build pending requests section (empty structure ready for data)
  Widget _buildPendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with count placeholder
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Text(
                '0', // Will be replaced with actual count from database
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Niet goedgekeurd',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Empty state - ready for dynamic content
        _buildEmptyState('Geen aanvragen in behandeling'),
      ],
    );
  }

  // Build approved requests section (empty structure ready for data)
  Widget _buildApprovedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Goedgekeurd',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 12),

        // Empty state - ready for dynamic content
        _buildEmptyState('Geen goedgekeurde aanvragen'),
      ],
    );
  }

  // Build empty state message
  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Build bottom navigation
  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Avatar/Profile button
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Navigate to profile or show menu
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Model class ready for database integration
class ApprovalRequest {
  final String id;
  final String studentName;
  final String studentId;
  final DateTime requestDate;
  final bool isApproved;

  ApprovalRequest({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.requestDate,
    required this.isApproved,
  });

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) {
    return ApprovalRequest(
      id: json['id'] ?? '',
      studentName: json['studentName'] ?? '',
      studentId: json['studentId'] ?? '',
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : DateTime.now(),
      isApproved: json['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentName': studentName,
      'studentId': studentId,
      'requestDate': requestDate.toIso8601String(),
      'isApproved': isApproved,
    };
  }
}
