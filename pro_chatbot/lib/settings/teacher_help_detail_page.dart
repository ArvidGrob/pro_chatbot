import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '/models/help_request.dart';
import '/models/help_request_message.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final HelpRequestService _helpRequestService = HelpRequestService();
  List<HelpRequestMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    setState(() => _isLoading = true);

    try {
      final messages = await _helpRequestService
          .getConversationMessages(widget.helpRequest.id);

      // AJOUT : Insérer le message initial s'il n'existe pas déjà
      final List<HelpRequestMessage> allMessages = [];

      // Vérifier si le message initial existe déjà dans la liste
      final hasInitialMessage = messages.any((msg) =>
          msg.message == widget.helpRequest.message &&
          msg.sender == MessageSender.student);

      if (!hasInitialMessage && widget.helpRequest.message.isNotEmpty) {
        // Créer le message initial
        final initialMessage = HelpRequestMessage(
          id: 0, // ID fictif
          helpRequestId: widget.helpRequest.id,
          sender: MessageSender.student,
          senderId: widget.helpRequest.studentId,
          senderName: widget.helpRequest.studentName,
          message: widget.helpRequest.message,
          createdAt: widget.helpRequest.createdAt,
        );
        allMessages.add(initialMessage);
      }

      allMessages.addAll(messages);

      setState(() {
        _messages = allMessages;
        _isLoading = false;
      });

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading conversation: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a message'),
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
      await _helpRequestService.addConversationMessage(
        helpRequestId: widget.helpRequest.id,
        sender: 'teacher',
        senderId: currentUser.id,
        senderName: '${currentUser.firstname} ${currentUser.lastname}',
        message: _messageController.text.trim(),
      );

      _messageController.clear();
      await _loadConversation();

      setState(() => _isSending = false);
    } catch (e) {
      setState(() => _isSending = false);

      if (mounted) {
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
              // Title and subject
              Column(
                children: [
                  const Text(
                    'Conversatie',
                    style: TextStyle(
                      color: Color(0xFF2A2AFF),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color(0xFF2A2AFF),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.helpRequest.studentName,
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.helpRequest.subject,
                      style: const TextStyle(
                        color: Color(0xFF2A2AFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Messages list
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2A2AFF),
                        ),
                      )
                    : _messages.isEmpty
                        ? Center(
                            child: Text(
                              'Nog geen berichten',
                              style: TextStyle(
                                color: themeManager.subtitleTextColor,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              final isTeacher =
                                  message.sender == MessageSender.teacher;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment: isTeacher
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (!isTeacher) ...[
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2A2AFF),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: isTeacher
                                              ? const Color(0xFF6BCF7F)
                                              : Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(20),
                                            topRight: const Radius.circular(20),
                                            bottomLeft: Radius.circular(
                                                isTeacher ? 20 : 4),
                                            bottomRight: Radius.circular(
                                                isTeacher ? 4 : 20),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (!isTeacher)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4),
                                                child: Text(
                                                  message.senderName,
                                                  style: const TextStyle(
                                                    color: Color(0xFF2A2AFF),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            Text(
                                              message.message,
                                              style: TextStyle(
                                                color: isTeacher
                                                    ? Colors.white
                                                    : const Color(0xFF333333),
                                                fontSize: 15,
                                                height: 1.4,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              _formatTime(message.createdAt),
                                              style: TextStyle(
                                                color: isTeacher
                                                    ? Colors.white70
                                                    : const Color(0xFF888888),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (isTeacher) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6BCF7F),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.school,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
              ),

              const SizedBox(height: 12),

              // Message input
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Typ je antwoord...',
                          hintStyle: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: 1, // ✅ BELANGRIJK
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.send, // ✅
                        onSubmitted: (_) {
                          if (!_isSending) {
                            _sendMessage();
                          }
                        },
                      ),

                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _isSending ? null : _sendMessage,
                    child: _isSending
                        ? Container(
                            width: 45,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Color(0xFF888888),
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Image.asset(
                            'assets/images/arrow.png',
                            width: 45,
                            height: 45,
                            fit: BoxFit.contain,
                          ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Return button
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/return.png',
                    width: 60,
                    height: 60,
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

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    if (difference.inDays == 0) {
      return 'Vandaag $hour:$minute';
    } else if (difference.inDays == 1) {
      return 'Gisteren $hour:$minute';
    } else {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day/$month $hour:$minute';
    }
  }
}
