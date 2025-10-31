import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Function to record audio with device microphone
/// Shows a dialog with recording controls and returns the audio file path
Future<String?> recordAudio(BuildContext context) async {
  try {
    final AudioRecorder recorder = AudioRecorder();

    // Check if microphone permission is granted
    if (!await recorder.hasPermission()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return null;
    }

    // Get temporary directory for audio file
    final Directory tempDir = await getTemporaryDirectory();
    final String audioPath =
        '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    // Show recording dialog
    if (context.mounted) {
      return await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) => _RecordingDialog(
          recorder: recorder,
          audioPath: audioPath,
        ),
      );
    }
    return null;
  } catch (e) {
    print('Error recording audio: $e');
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

/// Dialog widget for audio recording with controls
class _RecordingDialog extends StatefulWidget {
  final AudioRecorder recorder;
  final String audioPath;

  const _RecordingDialog({
    required this.recorder,
    required this.audioPath,
  });

  @override
  State<_RecordingDialog> createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<_RecordingDialog> {
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  late Stream<RecordState> _recordStateStream;

  @override
  void initState() {
    super.initState();
    _recordStateStream = widget.recorder.onStateChanged();
    _startRecording();
  }

  Future<void> _startRecording() async {
    try {
      await widget.recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: widget.audioPath,
      );
      setState(() {
        _isRecording = true;
      });

      // Update duration counter
      _updateDuration();
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  void _updateDuration() {
    if (_isRecording && !_isPaused) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isRecording && !_isPaused) {
          setState(() {
            _recordDuration++;
          });
          _updateDuration();
        }
      });
    }
  }

  Future<void> _pauseRecording() async {
    await widget.recorder.pause();
    setState(() {
      _isPaused = true;
    });
  }

  Future<void> _resumeRecording() async {
    await widget.recorder.resume();
    setState(() {
      _isPaused = false;
    });
    _updateDuration();
  }

  Future<void> _stopAndSave() async {
    final String? path = await widget.recorder.stop();
    if (mounted) {
      Navigator.of(context).pop(path);
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio upload in app must be implemented'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _cancelRecording() async {
    await widget.recorder.stop();
    // Delete the temporary file
    try {
      final file = File(widget.audioPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting audio file: $e');
    }
    if (mounted) {
      Navigator.of(context).pop(null);
    }
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    widget.recorder.dispose();
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
            const Icon(
              Icons.mic,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _isPaused ? 'Recording Paused' : 'Recording...',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel button
                IconButton(
                  onPressed: _cancelRecording,
                  icon: const Icon(Icons.close, size: 32),
                  color: Colors.grey,
                  tooltip: 'Cancel',
                ),
                // Pause/Resume button
                IconButton(
                  onPressed: _isPaused ? _resumeRecording : _pauseRecording,
                  icon: Icon(
                    _isPaused ? Icons.play_arrow : Icons.pause,
                    size: 32,
                  ),
                  color: Colors.orange,
                  tooltip: _isPaused ? 'Resume' : 'Pause',
                ),
                // Save button
                IconButton(
                  onPressed: _stopAndSave,
                  icon: const Icon(Icons.check, size: 32),
                  color: Colors.green,
                  tooltip: 'Save',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
