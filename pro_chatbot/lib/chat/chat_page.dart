import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_chatbot/tts_setting.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'chat_message_model.dart';
import 'chat_controller.dart';
import 'attachment_service.dart';
import 'attachment_widget.dart';
import 'speech_to_text_dialog.dart';
import 'attachment_prompt_dialog.dart';
import 'platform_helper.dart';
import '../history/chat_history_page.dart';
import '../api/api_services.dart';
import '../api/user_provider.dart';
import '../models/conversation.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatPage(),
  ));
}

class ChatPage extends StatefulWidget {
  final Conversation? conversation;

  const ChatPage({super.key, this.conversation});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatController _chatController;
  bool _viewHistoryPressed = false;
  bool _showPlusMenu = false;
  bool _newChatPressed = false;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _chatController = ChatController();

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        _chatController.stopSpeaking();
      }
    });

    // Set user ID for API service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.currentUser != null) {
        ApiService().setUserId(userProvider.currentUser!.id);
      }

      // Load existing conversation if provided
      if (widget.conversation != null) {
        _loadConversation(widget.conversation!);
      }
    });

    // Add initial message only if no conversation provided
    if (widget.conversation == null) {
      _chatController.addMessage(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Hallo! Hoe kan ik u helpen?',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  void _loadConversation(Conversation conversation) {
    // Convert conversation messages to ChatMessage format
    final messages = conversation.messages.map((msg) {
      return ChatMessage(
        id: msg.timestamp.millisecondsSinceEpoch.toString(),
        text: msg.content,
        isUser: msg.role == 'user',
        timestamp: msg.timestamp,
      );
    }).toList();

    _chatController.loadMessages(messages);

    // Set the conversation ID in API service to continue this conversation
    // Note: The conversation ID will be set automatically when sending next message

    // Scroll to bottom after loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _startNewChat() {
    _chatController.startNewConversation();

    // Reset conversation ID to start a new conversation
    ApiService().resetConversation();

    // Scroll to bottom after loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  String _stripMarkdown(String text) {
    // Remove code blocks first (```code```) to avoid processing their content
    text = text.replaceAll(RegExp(r'```[\s\S]*?```'), '');

    // Remove inline code (`code`)
    text = text.replaceAllMapped(
        RegExp(r'`([^`]+)`'), (match) => match.group(1) ?? '');

    // Remove images ![alt](url)
    text = text.replaceAllMapped(
        RegExp(r'!\[([^\]]*)\]\([^\)]+\)'), (match) => match.group(1) ?? '');

    // Remove links [text](url) - keep the text
    text = text.replaceAllMapped(
        RegExp(r'\[([^\]]+)\]\([^\)]+\)'), (match) => match.group(1) ?? '');

    // Remove strikethrough (~~text~~)
    text = text.replaceAllMapped(
        RegExp(r'~~(.+?)~~'), (match) => match.group(1) ?? '');

    // Remove bold (**text** or __text__) - must be before italic
    text = text.replaceAllMapped(
        RegExp(r'\*\*(.+?)\*\*'), (match) => match.group(1) ?? '');
    text = text.replaceAllMapped(
        RegExp(r'__(.+?)__'), (match) => match.group(1) ?? '');

    // Remove italic (*text* or _text_)
    text = text.replaceAllMapped(
        RegExp(r'\*(.+?)\*'), (match) => match.group(1) ?? '');
    text = text.replaceAllMapped(
        RegExp(r'_(.+?)_'), (match) => match.group(1) ?? '');

    // Remove headers (# ## ### etc)
    text = text.replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '');

    // Remove blockquotes (> text)
    text = text.replaceAll(RegExp(r'^>\s+', multiLine: true), '');

    // Remove horizontal rules (---, ***, ___)
    text = text.replaceAll(RegExp(r'^[\-\*_]{3,}$', multiLine: true), '');

    // Remove bullet points (- or * at start of line)
    text = text.replaceAll(RegExp(r'^[\*\-\+]\s+', multiLine: true), '');

    // Remove numbered lists (1. 2. etc)
    text = text.replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '');

    return text.trim();
  }

  Future<void> _toggleSpeak(String messageId, String text) async {
    if (_chatController.currentlySpeakingMessageId == messageId) {
      await _stopSpeaking();
      return;
    }

    await _stopSpeaking();
    await Future.delayed(Duration(milliseconds: 100));

    _chatController.startSpeaking(messageId);

    await flutterTts.setLanguage("nl-NL");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(TtsSettings.speechRate);
    await flutterTts.setVolume(1.0);

    // Strip markdown formatting before speaking
    final cleanText = _stripMarkdown(text);
    await flutterTts.speak(cleanText);
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
    _chatController.stopSpeaking();
  }

  void _retryMessage(String message) {
    ApiService().sendChatMessage(message).then((response) {
      if (!mounted) return;
      _chatController.setTyping(false);
      _chatController.addMessage(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    }).catchError((error) {
      if (!mounted) return;
      _chatController.setTyping(false);
      _chatController.addMessage(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Erreur de connexion: ${error.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    });
  }

  void _startNewConversation() {
    _chatController.startNewConversation();
    ApiService().resetConversation();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nieuwe conversatie gestart'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _chatController.addMessage(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _chatController.setTyping(true);

    _messageController.clear();
    _scrollToBottom();

    ApiService().sendChatMessage(userMessage).then((response) {
      if (!mounted) return;
      _chatController.setTyping(false);
      _chatController.addMessage(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    }).catchError((error) {
      if (!mounted) return;

      // If error 500, reset conversation and retry
      if (error.toString().contains('500')) {
        ApiService().resetConversation();
        _retryMessage(userMessage);
        return;
      }

      _chatController.setTyping(false);
      _chatController.addMessage(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Erreur: ${error.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Handle file picker
  Future<void> _handleFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Check file size
        if (!AttachmentService.validateFileSize(file.size)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File size exceeds 10 MB limit'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        await _addMessageWithAttachment(
          file.path!,
          AttachmentType.file,
        );
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  // Handle image picker from gallery
  Future<void> _handleGalleryPicker() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        final size = await AttachmentService.getFileSize(image.path);
        if (!AttachmentService.validateFileSize(size)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size exceeds 10 MB limit'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        await _addMessageWithAttachment(
          image.path,
          AttachmentType.image,
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Handle camera photo
  Future<void> _handleCamera() async {
    // Check platform support
    if (!PlatformHelper.isCameraAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Camera not available on ${PlatformHelper.platformName}',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        final size = await AttachmentService.getFileSize(photo.path);
        if (!AttachmentService.validateFileSize(size)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photo size exceeds 10 MB limit'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        await _addMessageWithAttachment(
          photo.path,
          AttachmentType.photo,
        );
      }
    } catch (e) {
      print('Error taking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Handle microphone - speech to text
  Future<void> _handleMicrophone() async {
    // Check platform support
    if (!PlatformHelper.isSpeechToTextAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Speech recognition not available on ${PlatformHelper.platformName}',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      print('Starting speech to text...');
      final transcribedText = await speechToText(context);

      print('Transcribed text: $transcribedText');

      if (transcribedText != null && transcribedText.isNotEmpty) {
        // Add transcribed text to message input
        print('Adding text to controller: $transcribedText');
        setState(() {
          _messageController.text = transcribedText;
        });
        print('Controller text is now: ${_messageController.text}');
      } else {
        print('No text transcribed or text is empty');
      }
    } catch (e) {
      print('Error with speech to text: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Add message with attachment
  Future<void> _addMessageWithAttachment(
    String filePath,
    AttachmentType type,
  ) async {
    try {
      // Create attachment
      final attachment = await AttachmentService.createAttachment(
        filePath: filePath,
        type: type,
      );

      // Show dialog to add prompt/message with attachment
      if (!mounted) return;
      final String? promptText = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AttachmentPromptDialog(
          attachment: attachment,
        ),
      );

      // If user cancelled, don't send
      if (promptText == null) {
        return;
      }

      // Create message with attachment and uploading state
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final message = ChatMessage(
        id: messageId,
        text: promptText, // Use the prompt from dialog
        isUser: true,
        timestamp: DateTime.now(),
        attachment: attachment,
        isUploading: true,
        uploadProgress: 0.0,
      );

      _chatController.addMessage(message);
      setState(() {
        _showPlusMenu = false; // Close the menu
      });
      _scrollToBottom();

      // Simulate upload progress
      await for (final progress in AttachmentService.simulateUpload()) {
        _chatController.updateMessageProgress(messageId, progress);
      }

      // Mark as uploaded
      _chatController.markMessageUploaded(messageId);

      _scrollToBottom();

      // Simulate AI response after attachment is uploaded
      _chatController.setTyping(true);

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _chatController.setTyping(false);
        _chatController.addMessage(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'AI not yet implemented. Please try again later.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _scrollToBottom();
      });
    } catch (e) {
      print('Error adding attachment: $e');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Messages list
            Expanded(
              child: Stack(
                children: [
                  // Luminara logo in background with opacity
                  Center(
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/images/luminara_logo.png',
                        width: 350,
                        height: 350,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Messages
                  ListenableBuilder(
                    listenable: _chatController,
                    builder: (context, _) {
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: _chatController.messages.length +
                            (_chatController.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _chatController.messages.length &&
                              _chatController.isTyping) {
                            return _buildTypingIndicator();
                          }
                          return _buildMessageBubble(
                              _chatController.messages[index]);
                        },
                      );
                    },
                  ),

                  // Plus menu bubble positioned here instead of in input area
                  if (_showPlusMenu)
                    Positioned(
                      bottom: 20,
                      right: 12,
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6464FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await _handleFilePicker();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/file.png',
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () async {
                                  print('Gallery picker clicked!!!');
                                  await _handleGalleryPicker();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/gallery.png',
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: PlatformHelper.isCameraAvailable
                                    ? () async {
                                        print('Photo clicked!!!');
                                        await _handleCamera();
                                      }
                                    : null,
                                child: Opacity(
                                  opacity: PlatformHelper.isCameraAvailable
                                      ? 1.0
                                      : 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/photo.png',
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: PlatformHelper.isSpeechToTextAvailable
                                    ? () async {
                                        print('Microphone clicked!!!');
                                        await _handleMicrophone();
                                      }
                                    : null,
                                child: Opacity(
                                  opacity:
                                      PlatformHelper.isSpeechToTextAvailable
                                          ? 1.0
                                          : 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/microphone.png',
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Input area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Title (absolutely centered)
          const Center(
            child: Text(
              'Chat',
              style: TextStyle(
                color: Color(0xFF2323AD),
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Row with back button and action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/images/return_2.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),

              // Right side buttons (stacked vertically)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // View History button
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() => _viewHistoryPressed = true);
                    },
                    onTapUp: (_) async {
                      setState(() => _viewHistoryPressed = false);
                      // Navigate to chat history page
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatHistoryPage(),
                        ),
                      );

                      // If a conversation was selected, load it
                      if (result is Conversation) {
                        _loadConversation(result);
                      } else if (result == 'start_new_chat') {
                        // User clicked return after possibly deleting - start fresh
                        _startNewChat();
                      }
                    },
                    onTapCancel: () {
                      setState(() => _viewHistoryPressed = false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: _viewHistoryPressed
                            ? const Color(0xFF4545BD)
                            : const Color(0xFF6464FF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Geschiedenis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // New Chat button
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() => _newChatPressed = true);
                    },
                    onTapUp: (_) {
                      setState(() => _newChatPressed = false);
                      _startNewConversation();
                    },
                    onTapCancel: () {
                      setState(() => _newChatPressed = false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: _newChatPressed
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF66BB6A),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Nieuw',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color.fromARGB(255, 123, 123, 123)
              : const Color(0xFF6464FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show attachment if present
            if (message.attachment != null) ...[
              AttachmentWidget(
                attachment: message.attachment!,
                isUploading: message.isUploading,
                uploadProgress: message.uploadProgress,
              ),
              if (message.text.isNotEmpty) const SizedBox(height: 8),
            ],
            // Show text if present
            if (message.text.isNotEmpty)
              message.isUser
                  ? Text(
                      message.text,
                      style: const TextStyle(
                        color: Color.fromARGB(221, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : MarkdownBody(
                      data: message.text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        strong: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        em: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        listBullet: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        blockquote: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        code: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                        ),
                        h1: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        h3: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        h4: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        h5: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        h6: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            if (!message.isUser && message.text.isNotEmpty)
              ListenableBuilder(
                listenable: _chatController,
                builder: (context, _) {
                  return IconButton(
                    icon: Icon(
                      _chatController.currentlySpeakingMessageId == message.id
                          ? Icons.volume_off
                          : Icons.volume_up,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => _toggleSpeak(message.id, message.text),
                  );
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF6464FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value - delay).clamp(0.0, 1.0);
        return Opacity(
          opacity: animValue,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted && _chatController.isTyping) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
      ),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      autocorrect: true,
                      enableSuggestions: true,
                      spellCheckConfiguration: const SpellCheckConfiguration(
                        misspelledTextStyle: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.red,
                        ),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Vraag het aan Luminara',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  // Send button inside the text field
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        'assets/images/arrow.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Plus button on the right
          GestureDetector(
            onTap: () {
              setState(() => _showPlusMenu = !_showPlusMenu);
              print('Plus button clicked, menu is now: $_showPlusMenu');
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color:
                    _showPlusMenu ? const Color(0xFF6464FF) : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: _showPlusMenu ? Colors.white : Colors.black54,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
