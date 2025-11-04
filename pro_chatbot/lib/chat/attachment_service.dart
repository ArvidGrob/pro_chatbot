import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'chat_message_model.dart';

/// Service to manage file attachments in chat
class AttachmentService {
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB

  /// Validate file size
  static bool validateFileSize(int sizeInBytes) {
    return sizeInBytes <= maxFileSizeBytes;
  }

  /// Get file size from path
  static Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    return await file.length();
  }

  /// Copy file to app's storage directory
  static Future<String> saveAttachment(String sourcePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory('${appDir.path}/attachments');

      // Create attachments directory if it doesn't exist
      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }

      // Generate unique filename with timestamp
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(sourcePath)}';
      final destPath = '${attachmentsDir.path}/$fileName';

      // Copy file
      final sourceFile = File(sourcePath);
      await sourceFile.copy(destPath);

      return destPath;
    } catch (e) {
      print('Error saving attachment: $e');
      rethrow;
    }
  }

  /// Create MessageAttachment from file path
  static Future<MessageAttachment> createAttachment({
    required String filePath,
    required AttachmentType type,
    String? mimeType,
  }) async {
    final file = File(filePath);
    final fileName = path.basename(filePath);
    final fileSize = await file.length();

    return MessageAttachment(
      path: filePath,
      name: fileName,
      sizeInBytes: fileSize,
      type: type,
      mimeType: mimeType,
    );
  }

  /// Get icon for attachment type
  static IconData getIconForAttachment(MessageAttachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
      case AttachmentType.photo:
        return Icons.image;
      case AttachmentType.audio:
        return Icons.audio_file;
      case AttachmentType.file:
        return _getFileIcon(attachment.extension);
      default:
        return Icons.attach_file;
    }
  }

  /// Get specific icon based on file extension
  static IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Simulate upload progress (for demonstration)
  static Stream<double> simulateUpload() async* {
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 50));
      yield i / 100;
    }
  }
}
