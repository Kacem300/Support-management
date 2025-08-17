import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecordDialog extends StatefulWidget {
  final void Function(String? path) onRecordingComplete;
  const AudioRecordDialog({required this.onRecordingComplete, super.key});

  @override
  State<AudioRecordDialog> createState() => _AudioRecordDialogState();
}

class _AudioRecordDialogState extends State<AudioRecordDialog> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isSaving = false;
  String? _audioPath;

  @override
  void dispose() {
    if (_isRecording) {
      _recorder.stop();
    }
    super.dispose();
  }

  Future<void> _startRecording() async {
    setState(() => _isSaving = true);
    try {
      if (await _recorder.hasPermission()) {
        // Create a config for recording
        final config = RecordConfig(
          encoder: AudioEncoder.aacLc, // mp4 format
          bitRate: 128000,
          sampleRate: 44100,
        );
        // Use path_provider to get a temporary directory
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(config, path: filePath);
        setState(() {
          _isRecording = true;
          _isSaving = false;
        });
      } else {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission micro refusée.")),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors du démarrage de l'enregistrement.")),
      );
    }
  }

  Future<void> _stopRecording() async {
    setState(() => _isSaving = true);
    try {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
        _isSaving = false;
      });
      widget.onRecordingComplete(path);
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'arrêt de l'enregistrement.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enregistrer un audio'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isRecording ? Icons.mic : Icons.mic_none,
            color: _isRecording ? Colors.red : Colors.grey,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(_isRecording ? 'Enregistrement...' : 'Prêt à enregistrer'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () async {
                  if (_isRecording) {
                    await _recorder.stop();
                  }
                  widget.onRecordingComplete(null);
                  Navigator.of(context).pop();
                },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isSaving
              ? null
              : () async {
                  if (!_isRecording) {
                    await _startRecording();
                  } else {
                    await _stopRecording();
                  }
                },
          child: Text(_isRecording ? 'Arrêter' : 'Démarrer'),
        ),
      ],
    );
  }
}
