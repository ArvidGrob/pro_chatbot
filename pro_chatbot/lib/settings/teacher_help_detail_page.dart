import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '/models/help_request.dart';
import '/api/help_request_service.dart';
import '/api/user_provider.dart';

class TeacherHelpDetailPage extends StatefulWidget {
  final HelpRequest helpRequest;

  const TeacherHelpDetailPage({
    super.key,
    required this.helpRequest,
  });

  @override
  State<TeacherHelpDetailPage> createState() => _TeacherHelpDetailPageState();
}

class _TeacherHelpDetailPageState extends State<TeacherHelpDetailPage> {
  final TextEditingController _responseController = TextEditingController();
  final HelpRequestService _helpRequestService = HelpRequestService();
  bool _isSending = false;
  String _pressedButton = '';

  @override
  void initState() {
    super.initState();
    // Als al beantwoord, toon het antwoord
    if (widget.helpRequest.teacherResponse != null) {
      _responseController.text = widget.helpRequest.teacherResponse!;
    }
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year à $hour:$minute';
  }

  Future<void> _sendResponse() async {
    if (_responseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a response'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      await _helpRequestService.respondToHelpRequest(
        requestId: widget.helpRequest.id,
        teacherId: currentUser.id,
        response: _responseController.text.trim(),
      );

      if (mounted) {
        setState(() => _isSending = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Response sent successfully!'),
            backgroundColor: Color(0xFF6BCF7F),
          ),
        );

        // Terug naar inbox na korte vertraging
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                'Hulpverzoek',
                style: TextStyle(
                  color: Color(0xFF2A2AFF),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student info card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Student name
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color(0xFF2A2AFF),
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.helpRequest.studentName,
                                    style: const TextStyle(
                                      color: Color(0xFF2A2AFF),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Date
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Color(0xFF888888),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _formatDateTime(widget.helpRequest.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Subject
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E8FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Onderwerp:',
                              style: TextStyle(
                                color: Color(0xFF2A2AFF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.helpRequest.subject,
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Message
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bericht:',
                              style: TextStyle(
                                color: Color(0xFF2A2AFF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.helpRequest.message,
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Response section
                      Text(
                        widget.helpRequest.status == HelpRequestStatus.pending
                            ? 'Uw antwoord:'
                            : 'Antwoord verzonden:',
                        style: const TextStyle(
                          color: Color(0xFF2A2AFF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Response text field
                      TextField(
                        controller: _responseController,
                        maxLines: 6,
                        enabled: widget.helpRequest.status ==
                            HelpRequestStatus.pending,
                        decoration: InputDecoration(
                          hintText: 'Schrijf hier uw antwoord...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: widget.helpRequest.status ==
                                  HelpRequestStatus.pending
                              ? const Color(0xFFD9D9D9)
                              : const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 16,
                        ),
                      ),

                      if (widget.helpRequest.status ==
                          HelpRequestStatus.pending) ...[
                        const SizedBox(height: 20),

                        // Send button
                        _buildButton(
                          themeManager,
                          buttonId: 'send',
                          label: _isSending ? 'Verzenden...' : 'Verzenden',
                          baseColor: const Color(0xFF6BCF7F),
                          onTap: _isSending ? () {} : _sendResponse,
                        ),
                      ],

                      if (widget.helpRequest.respondedAt != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Beantwoord op ${_formatDateTime(widget.helpRequest.respondedAt!)}',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Return button
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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

  Widget _buildButton(
    ThemeManager themeManager, {
    required String buttonId,
    required String label,
    required VoidCallback onTap,
    required Color baseColor,
  }) {
    bool isPressed = _pressedButton == buttonId;
    Color buttonColor =
        themeManager.getButtonColor(baseColor, isPressed: isPressed);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedButton = buttonId),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 80), () {
          if (mounted) {
            setState(() => _pressedButton = '');
            onTap();
          }
        });
      },
      onTapCancel: () => setState(() => _pressedButton = ''),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: isPressed ? 6 : 8,
              offset: Offset(0, isPressed ? 4 : 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
