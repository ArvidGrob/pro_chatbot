import 'dart:io';

/// Type of attachment in a chat message
enum AttachmentType {
  none,
  file,
  image,
  photo,
  audio,
}

/// Model for chat message attachments
class MessageAttachment {
  final String path;
  final String name;
  final int sizeInBytes;
  final AttachmentType type;
  final String? mimeType;

  MessageAttachment({
    required this.path,
    required this.name,
    required this.sizeInBytes,
    required this.type,
    this.mimeType,
  });

  /// Get file size in human readable format
  String get formattedSize {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Check if file size is within limit (10 MB)
  bool get isWithinSizeLimit => sizeInBytes <= 10 * 1024 * 1024;

  /// Get file extension
  String get extension {
    return name.split('.').last.toUpperCase();
  }
}

/// Model for a chat message
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageAttachment? attachment;
  final bool isUploading;
  final double uploadProgress;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.attachment,
    this.isUploading = false,
    this.uploadProgress = 0.0,
  });

  /// Create a copy with updated values
  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    MessageAttachment? attachment,
    bool? isUploading,
    double? uploadProgress,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      attachment: attachment ?? this.attachment,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}
