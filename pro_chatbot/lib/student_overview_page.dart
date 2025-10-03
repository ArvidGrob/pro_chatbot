import 'package:flutter/material.dart';

// Temporary main function for debugging/preview
void main() {
  runApp(const StudentOverviewApp());
}

class StudentOverviewApp extends StatelessWidget {
  const StudentOverviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Overview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StudentOverviewPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentOverviewPage extends StatefulWidget {
  const StudentOverviewPage({super.key});

  @override
  State<StudentOverviewPage> createState() => _StudentOverviewPageState();
}

class _StudentOverviewPageState extends State<StudentOverviewPage> {
  // Search controller for student search functionality
  final _searchController = TextEditingController();

  // List of students - will be populated from database later
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with title
            _buildHeader(),

            // Search section
            _buildSearchSection(),

            // Students list
            Expanded(
              child: _buildStudentsList(),
            ),
          ],
        ),
      ),
    );
  }

  // Build header section
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text(
            'Studentenoverzicht',
            style: TextStyle(
              color: Color(0xFF4F46E5),
              fontSize: 20,
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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterStudents,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Een student zoeken',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[500],
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ),
    );
  }

  // Build students list
  Widget _buildStudentsList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4F46E5),
        ),
      );
    }

    if (_filteredStudents.isEmpty && _students.isEmpty) {
      return _buildEmptyState();
    }

    if (_filteredStudents.isEmpty && _searchController.text.isNotEmpty) {
      return _buildNoSearchResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];
        return _buildStudentItem(student);
      },
    );
  }

  // Build individual student item (following exact design)
  Widget _buildStudentItem(Student student) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Student name
          Expanded(
            child: Text(
              student.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4F46E5),
              ),
            ),
          ),

          // Online/Offline status
          Text(
            student.isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: student.isOnline ? Colors.green : Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Build empty state when no students
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Geen studenten gevonden',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Studenten worden hier weergegeven wanneer ze beschikbaar zijn.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build no search results state
  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Geen resultaten gevonden',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Probeer een andere zoekterm.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Load students from database (placeholder for future implementation)
  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Replace with actual database call
    // Example: _students = await DatabaseService.getStudents();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      // Empty list - ready for database integration
      _students = [];
      _filteredStudents = _students;
      _isLoading = false;
    });
  }

  // Filter students based on search query
  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = _students;
      } else {
        _filteredStudents = _students
            .where((student) =>
                student.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Refresh students list (for pull-to-refresh or manual refresh)
  // Future implementation: _refreshStudents() for manual refresh
}

// Student model class - ready for database integration
class Student {
  final String id;
  final String name;
  final bool isOnline;
  final DateTime? lastSeen;

  Student({
    required this.id,
    required this.name,
    required this.isOnline,
    this.lastSeen,
  });

  // Factory constructor for creating Student from database/API response
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isOnline: json['isOnline'] ?? false,
      lastSeen:
          json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
    );
  }

  // Convert Student to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }
}
