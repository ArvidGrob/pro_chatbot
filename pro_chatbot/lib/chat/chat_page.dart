import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'chat_message_model.dart';
import 'attachment_service.dart';
import 'attachment_widget.dart';
import 'speech_to_text_dialog.dart';
import 'attachment_prompt_dialog.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const ChatPage(),
  ));
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _viewHistoryPressed = false;
  bool _showPlusMenu = false;

  @override
  void initState() {
    super.initState();
    // Add initial message
    _messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Hallo! Hoe kan ik u helpen?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response with delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'AI not yet implemented. Please try again later.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
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
    }
  }

  // Handle microphone - speech to text
  Future<void> _handleMicrophone() async {
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

      setState(() {
        _messages.add(message);
        _showPlusMenu = false; // Close the menu
      });
      _scrollToBottom();

      // Simulate upload progress
      await for (final progress in AttachmentService.simulateUpload()) {
        final index = _messages.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          setState(() {
            _messages[index] = _messages[index].copyWith(
              uploadProgress: progress,
            );
          });
        }
      }

      // Mark as uploaded
      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        setState(() {
          _messages[index] = _messages[index].copyWith(
            isUploading: false,
            uploadProgress: 1.0,
          );
        });
      }

      _scrollToBottom();

      // Simulate AI response after attachment is uploaded
      setState(() {
        _isTyping = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: 'AI not yet implemented. Please try again later.',
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
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
                  ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
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
                                onTap: () async {
                                  print('Photo clicked!!!');
                                  await _handleCamera();
                                },
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
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () async {
                                  print('Microphone clicked!!!');
                                  await _handleMicrophone();
                                },
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
      child: Row(
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

          // Title (centered with more space)
          Expanded(
            flex: 8,
            child: Transform.translate(
              offset: const Offset(20, 0),
              child: const Text(
                'Chat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF2323AD),
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // View History button
          GestureDetector(
            onTapDown: (_) {
              setState(() => _viewHistoryPressed = true);
            },
            onTapUp: (_) {
              setState(() => _viewHistoryPressed = false);
              // TODO: Implement view history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('View History - To be implemented'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            onTapCancel: () {
              setState(() => _viewHistoryPressed = false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _viewHistoryPressed
                    ? const Color(0xFF4545BD)
                    : const Color(0xFF6464FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'View History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
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
              ? const Color(0xFFD9D9D9)
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
              Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.black87 : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
        if (mounted && _isTyping) {
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
