import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '/models/help_request.dart';
import '/api/help_request_service.dart';
import '/api/user_provider.dart';
import 'student_help_response_detail_page.dart';
import 'settings_page_hulp.dart';

class StudentHelpResponsesPage extends StatefulWidget {
  const StudentHelpResponsesPage({super.key});

  @override
  State<StudentHelpResponsesPage> createState() =>
      _StudentHelpResponsesPageState();
}

class _StudentHelpResponsesPageState extends State<StudentHelpResponsesPage> {
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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;

      if (currentUser != null) {
        final requests =
            await _helpRequestService.getStudentHelpRequests(currentUser.id);

        setState(() {
          _helpRequests = requests;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
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
      return '${difference.inDays} dagen geleden';
    } else {
      return '$day/$month/$year';
    }
  }

  Color _getStatusColor(HelpRequestStatus status) {
    switch (status) {
      case HelpRequestStatus.pending:
        return const Color(0xFFFF6B6B); // Rood voor in afwachting
      case HelpRequestStatus.responded:
        return const Color(0xFF6BCF7F); // Groen voor beantwoord
      case HelpRequestStatus.resolved:
        return const Color(0xFF888888); // Grijs voor opgelost
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

  IconData _getStatusIcon(HelpRequestStatus status) {
    switch (status) {
      case HelpRequestStatus.pending:
        return Icons.schedule;
      case HelpRequestStatus.responded:
        return Icons.check_circle;
      case HelpRequestStatus.resolved:
        return Icons.done_all;
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
                'Mijn hulpverzoeken',
                style: TextStyle(
                  color: Color(0xFF2A2AFF),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                'Je verzonden berichten en antwoorden',
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
                              'Geen hulpverzoeken verzonden',
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
    final hasResponse = request.status == HelpRequestStatus.responded ||
        request.status == HelpRequestStatus.resolved;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentHelpResponseDetailPage(
                helpRequest: request,
              ),
            ),
          ).then((_) => _loadHelpRequests()); // Vernieuwen na terugkeer
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: hasResponse
                ? Border.all(
                    color: const Color(0xFF6BCF7F),
                    width: 2,
                  )
                : null,
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
                // Header: Subject and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.subject,
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

                if (hasResponse) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.reply,
                          color: Color(0xFF6BCF7F),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            request.teacherResponse ?? 'Antwoord ontvangen',
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Status indicator
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(request.status),
                      size: 16,
                      color: _getStatusColor(request.status),
                    ),
                    const SizedBox(width: 6),
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
