import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

/// Function to pick a file from device storage
/// Returns the selected file or null if cancelled
Future<PlatformFile?> pickFile(BuildContext context) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      // Show message that upload must be implemented
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File upload in app must be implemented'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return result.files.first;
    }
    return null;
  } catch (e) {
    print('Error picking file: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
    return null;
  }
}
