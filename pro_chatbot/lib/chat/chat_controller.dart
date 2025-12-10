import 'package:flutter/foundation.dart';
import 'chat_message_model.dart';

class ChatController extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _currentlySpeakingMessageId;

  // Read-only access to state
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  String? get currentlySpeakingMessageId => _currentlySpeakingMessageId;

  /// Add a new message to the chat
  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  /// Clear all messages
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  /// Set typing indicator state
  void setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  /// Start speaking a message (for TTS)
  void startSpeaking(String messageId) {
    _currentlySpeakingMessageId = messageId;
    notifyListeners();
  }

  /// Stop speaking (for TTS)
  void stopSpeaking() {
    _currentlySpeakingMessageId = null;
    notifyListeners();
  }

  /// Update a specific message (for upload progress, etc.)
  void updateMessage(String messageId, ChatMessage updatedMessage) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messages[index] = updatedMessage;
      notifyListeners();
    }
  }

  /// Update message upload progress
  void updateMessageProgress(String messageId, double progress) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(uploadProgress: progress);
      notifyListeners();
    }
  }

  /// Mark message as uploaded
  void markMessageUploaded(String messageId) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(
        isUploading: false,
        uploadProgress: 1.0,
      );
      notifyListeners();
    }
  }

  /// Start a new conversation with initial greeting
  void startNewConversation() {
    _messages.clear();
    _messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Hallo! Hoe kan ik u helpen?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  /// Load messages from a conversation
  void loadMessages(List<ChatMessage> messages) {
    _messages.clear();
    _messages.addAll(messages);
    notifyListeners();
  }

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}
