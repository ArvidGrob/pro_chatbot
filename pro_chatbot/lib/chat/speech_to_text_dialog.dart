import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Function to start speech-to-text and return transcribed text
/// Returns the transcribed text or null if cancelled/error
Future<String?> speechToText(BuildContext context) async {
  try {
    final stt.SpeechToText speech = stt.SpeechToText();

    // Initialize speech recognition
    bool available = await speech.initialize(
      onError: (error) => print('Speech recognition error: $error'),
      onStatus: (status) => print('Speech recognition status: $status'),
    );

    if (!available) {
      if (context.mounted) {
        // Check if running on simulator
        bool isSimulator = false;
        if (!kIsWeb && Platform.isIOS) {
          // iOS simulator doesn't support speech recognition
          isSimulator = true;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSimulator
                  ? 'iOS-simulator ondersteunt geen spraakherkenning. Test op een echt apparaat.'
                  : 'Spraakherkenning niet beschikbaar',
            ),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return null;
    }

    // Show listening dialog
    if (context.mounted) {
      return await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) => _SpeechToTextDialog(
          speech: speech,
        ),
      );
    }
    return null;
  } catch (e) {
    print('Error in speech to text: $e');
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

/// Dialog widget for speech-to-text with real-time transcription
class _SpeechToTextDialog extends StatefulWidget {
  final stt.SpeechToText speech;

  const _SpeechToTextDialog({
    required this.speech,
  });

  @override
  State<_SpeechToTextDialog> createState() => _SpeechToTextDialogState();
}

class _SpeechToTextDialogState extends State<_SpeechToTextDialog> {
  String _transcribedText = '';
  bool _isListening = false;
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  Future<void> _startListening() async {
    if (mounted) {
      setState(() {
        _transcribedText = '';
        _isListening = true;
      });
    }

    await widget.speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _transcribedText = result.recognizedWords;
            _confidence = result.confidence;
          });
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
      localeId: 'nl-NL', // Néerlandais par défaut
      onDevice:
          false, // Utiliser le service cloud pour meilleur support multilingue
    );
  }

  Future<void> _stopListening() async {
    await widget.speech.stop();
    if (mounted) {
      setState(() {
        _isListening = false;
      });
    }
  }

  void _confirm() {
    _stopListening();
    Navigator.of(context).pop(_transcribedText.trim());
  }

  void _cancel() {
    _stopListening();
    Navigator.of(context).pop(null);
  }

  @override
  void dispose() {
    widget.speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated microphone icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _isListening ? Colors.red.shade100 : Colors.grey.shade200,
              ),
              child: Icon(
                Icons.mic,
                size: 40,
                color: _isListening ? Colors.red : Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isListening ? 'Luisteren...' : 'Verwerken...',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (_confidence > 0)
              Text(
                'Betrouwbaarheid: ${(_confidence * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            const SizedBox(height: 16),

            // Transcribed text display
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 80,
                maxHeight: 200,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _transcribedText.isEmpty
                      ? 'Begin met spreken...'
                      : _transcribedText,
                  style: TextStyle(
                    fontSize: 14,
                    color: _transcribedText.isEmpty
                        ? Colors.grey.shade500
                        : Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: _cancel,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Annuleren',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),

                // Confirm button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: _transcribedText.isNotEmpty ? _confirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Gebruiken',
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
