import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class AudioRecordingController extends ChangeNotifier {
  final AudioRecordingService _audioService;

  AudioRecordingController({AudioRecordingService? audioService})
      : _audioService = audioService ?? AudioRecordingService();

  AudioRecordingModel _recording = const AudioRecordingModel();
  bool _isInitialized = false;
  String? _error;

  // Getters
  AudioRecordingModel get recording => _recording;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  bool get isRecording => _recording.isRecording;
  bool get isPaused => _recording.isPaused;
  bool get isStopped => _recording.isStopped;
  bool get hasRecording =>
      _recording.filePath != null && _recording.filePath!.isNotEmpty;

  // Initialize audio recording service
  Future<void> initialize() async {
    try {
      await _audioService.initialize();
      _isInitialized = true;
      _clearError();
    } catch (e) {
      _setError('Failed to initialize audio recording: $e');
    }
    notifyListeners();
  }

  // Start recording
  Future<void> startRecording() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _audioService.startRecording();
      _recording = _recording.copyWith(state: RecordingState.recording);
      _clearError();

      // Start listening for updates
      _startRecordingUpdates();
    } catch (e) {
      _setError('Failed to start recording: $e');
    }
    notifyListeners();
  }

  // Stop recording
  Future<void> stopRecording() async {
    try {
      final filePath = await _audioService.stopRecording();
      _recording = _recording.copyWith(
        state: RecordingState.stopped,
        filePath: filePath,
      );
      _clearError();
    } catch (e) {
      _setError('Failed to stop recording: $e');
    }
    notifyListeners();
  }

  // Pause recording
  Future<void> pauseRecording() async {
    try {
      await _audioService.pauseRecording();
      _recording = _recording.copyWith(state: RecordingState.paused);
      _clearError();
    } catch (e) {
      _setError('Failed to pause recording: $e');
    }
    notifyListeners();
  }

  // Resume recording
  Future<void> resumeRecording() async {
    try {
      await _audioService.resumeRecording();
      _recording = _recording.copyWith(state: RecordingState.recording);
      _clearError();
    } catch (e) {
      _setError('Failed to resume recording: $e');
    }
    notifyListeners();
  }

  // Cancel recording
  Future<void> cancelRecording() async {
    try {
      await _audioService.cancelRecording();
      _recording = const AudioRecordingModel();
      _clearError();
    } catch (e) {
      _setError('Failed to cancel recording: $e');
    }
    notifyListeners();
  }

  // Play recorded audio
  Future<void> playRecording() async {
    if (!hasRecording) return;

    try {
      await _audioService.playRecording(_recording.filePath!);
      _clearError();
    } catch (e) {
      _setError('Failed to play recording: $e');
    }
  }

  // Stop playing audio
  Future<void> stopPlayback() async {
    try {
      await _audioService.stopPlayback();
      _clearError();
    } catch (e) {
      _setError('Failed to stop playback: $e');
    }
  }

  // Get recording permission
  Future<bool> requestPermission() async {
    try {
      final hasPermission = await _audioService.hasPermission();
      if (!hasPermission) {
        return await _audioService.requestPermission();
      }
      return true;
    } catch (e) {
      _setError('Failed to request permission: $e');
      return false;
    }
  }

  // Delete current recording
  Future<void> deleteRecording() async {
    if (!hasRecording) return;

    try {
      await _audioService.deleteRecording(_recording.filePath!);
      _recording = const AudioRecordingModel();
      _clearError();
    } catch (e) {
      _setError('Failed to delete recording: $e');
    }
    notifyListeners();
  }

  // Start listening for recording updates
  void _startRecordingUpdates() {
    // In a real implementation, this would listen to the audio service
    // for real-time updates like duration and amplitude
    // For now, we'll simulate with a simple timer
    if (_recording.isRecording) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_recording.isRecording) {
          _recording = _recording.copyWith(
            duration: _recording.duration + const Duration(seconds: 1),
            amplitude: 0.5 +
                (DateTime.now().millisecond % 100) / 200, // Mock amplitude
          );
          notifyListeners();
          _startRecordingUpdates(); // Continue updates
        }
      });
    }
  }

  // Reset controller state
  void reset() {
    _recording = const AudioRecordingModel();
    _clearError();
    notifyListeners();
  }

  // Dispose resources
  @override
  Future<void> dispose() async {
    await _audioService.dispose();
    super.dispose();
  }

  // Private helper methods
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
