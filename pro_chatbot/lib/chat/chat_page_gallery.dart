import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Function to pick an image from device gallery
/// Returns the selected image path or null if cancelled
Future<XFile?> pickImageFromGallery(BuildContext context) async {
  try {
    final ImagePicker picker = ImagePicker();

    // Pick an image from gallery
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Compress to 85% quality
    );

    if (image != null) {
      // Show message that upload must be implemented
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image upload in app must be implemented'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return image;
    }
    return null;
  } catch (e) {
    print('Error picking image from gallery: $e');
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

/// Function to pick multiple images from gallery
/// Returns a list of selected image paths
Future<List<XFile>?> pickMultipleImagesFromGallery(BuildContext context) async {
  try {
    final ImagePicker picker = ImagePicker();

    // Pick multiple images from gallery
    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 85, // Compress to 85% quality
    );

    if (images.isNotEmpty) {
      // Show message that upload must be implemented
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${images.length} image(s) selected. Upload must be implemented'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return images;
    }
    return null;
  } catch (e) {
    print('Error picking multiple images: $e');
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
