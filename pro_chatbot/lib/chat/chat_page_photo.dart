import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Function to take a photo with device camera
/// Returns the captured photo or null if cancelled
Future<XFile?> takePhoto(BuildContext context) async {
  try {
    final ImagePicker picker = ImagePicker();

    // Take a photo with camera
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85, // Compress to 85% quality
      preferredCameraDevice: CameraDevice.rear, // Use rear camera by default
    );

    if (photo != null) {
      // Show message that upload must be implemented
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo upload in app must be implemented'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return photo;
    }
    return null;
  } catch (e) {
    print('Error taking photo: $e');
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

/// Function to take a photo with front camera (selfie)
/// Returns the captured photo or null if cancelled
Future<XFile?> takeSelfie(BuildContext context) async {
  try {
    final ImagePicker picker = ImagePicker();

    // Take a selfie with front camera
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85, // Compress to 85% quality
      preferredCameraDevice: CameraDevice.front, // Use front camera
    );

    if (photo != null) {
      // Show message that upload must be implemented
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selfie upload in app must be implemented'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return photo;
    }
    return null;
  } catch (e) {
    print('Error taking selfie: $e');
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
