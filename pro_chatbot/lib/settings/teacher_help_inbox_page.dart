import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '/models/help_request.dart';
import '/api/help_request_service.dart';
import 'teacher_help_detail_page.dart';
import 'settings_page_hulp.dart';

class TeacherHelpInboxPage extends StatefulWidget {
  const TeacherHelpInboxPage({super.key});

  @override
  State<TeacherHelpInboxPage> createState() => _TeacherHelpInboxPageState();
}

class _TeacherHelpInboxPageState extends State<TeacherHelpInboxPage> {
  final HelpRequestService _helpRequestService = HelpRequestService();
  List<HelpRequest> _helpRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHelpRequests();
  }

  Future<void> _loadHelpRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final requests = await _helpRequestService.getAllHelpRequests();

      setState(() {
        _helpRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _helpRequests = [];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading requests: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    if (difference.inDays == 0) {
      return 'Vandaag om $hour:$minute';
    } else if (difference.inDays == 1) {
      return 'Gisteren om $hour:$minute';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dagen';
    } else {
      return '$day/$month/$year';
    }
  }

  Color _getStatusColor(HelpRequestStatus status) {
    switch (status) {
      case HelpRequestStatus.pending:
        return const Color(0xFFFF6B6B); // Rood voor in afwachting
      case HelpRequestStatus.responded:
        return const Color(0xFFFFD93D); // Geel voor beantwoord
      case HelpRequestStatus.resolved:
        return const Color(0xFF6BCF7F); // Groen voor opgelost
    }
  }

  String _getStatusText(HelpRequestStatus status) {
    switch (status) {
      case HelpRequestStatus.pending:
        return 'In afwachting';
      case HelpRequestStatus.responded:
        return 'Beantwoord';
      case HelpRequestStatus.resolved:
        return 'Opgelost';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Title
              const Text(
                'Berichten inbox',
                style: TextStyle(
                  color: Color(0xFF2A2AFF),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                'Hulpverzoeken van studenten',
                style: TextStyle(
                  color: themeManager.subtitleTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              // List of help requests
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2A2AFF),
                        ),
                      )
                    : _helpRequests.isEmpty
                        ? Center(
                            child: Text(
                              'Geen hulpverzoeken',
                              style: TextStyle(
                                color: themeManager.subtitleTextColor,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadHelpRequests,
                            color: const Color(0xFF2A2AFF),
                            child: ListView.builder(
                              itemCount: _helpRequests.length,
                              itemBuilder: (context, index) {
                                final request = _helpRequests[index];
                                return _buildHelpRequestCard(
                                  request,
                                  themeManager,
                                );
                              },
                            ),
                          ),
              ),

              const SizedBox(height: 20),

              // Return button
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPageHulp(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/return.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpRequestCard(
    HelpRequest request,
    ThemeManager themeManager,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherHelpDetailPage(
                helpRequest: request,
              ),
            ),
          ).then((_) => _loadHelpRequests()); // Vernieuwen na terugkeer
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Student name and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.studentName,
                        style: const TextStyle(
                          color: Color(0xFF2A2AFF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _formatDate(request.createdAt),
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Subject
                Text(
                  request.subject,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Message preview
                Text(
                  request.message,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Status indicator
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(request.status),
                        style: TextStyle(
                          color: _getStatusColor(request.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF888888),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
