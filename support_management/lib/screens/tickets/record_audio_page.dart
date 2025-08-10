import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:io';
// import 'package:record/record.dart';  // Temporarily disabled
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class RecordAudioPage extends StatefulWidget {
  const RecordAudioPage({super.key});

  @override
  State<RecordAudioPage> createState() => _RecordAudioPageState();
}

class _RecordAudioPageState extends State<RecordAudioPage>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  late AnimationController _pulseAnimationController;
  late AnimationController _waveAnimationController;
  late Animation<double> _pulseAnimation;

  // Audio recording - temporarily disabled
  // final AudioRecorder _audioRecorder = AudioRecorder();
  String? _audioPath;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _requestPermissions();
  }

  void _initializeAnimations() {
    // Pulse animation for the record button
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    // Wave animation controller
    _waveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  Future<void> _requestPermissions() async {
    final microphonePermission = await Permission.microphone.request();
    // Note: Storage permission is not needed for app's documents directory on Android 10+

    setState(() {
      _hasPermission = microphonePermission == PermissionStatus.granted;
    });

    if (!_hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required for recording'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseAnimationController.dispose();
    _waveAnimationController.dispose();
    // _audioRecorder.dispose();  // Temporarily disabled
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!_hasPermission) {
      await _requestPermissions();
      if (!_hasPermission) return;
    }

    try {
      // Create a file path for the recording
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'ticket_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final filePath = '${directory.path}/$fileName';

      // Start recording - temporarily disabled
      /*
      await _audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );
      */

      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
        _audioPath = filePath;
      });

      // Start pulse animation
      _pulseAnimationController.repeat(reverse: true);
      _waveAnimationController.repeat();

      // Start timer
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          _recordingDuration = Duration(milliseconds: timer.tick * 10);
        });
      });

      print('Recording started: $filePath');
    } catch (e) {
      print('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      // Stop recording - temporarily disabled
      // final path = await _audioRecorder.stop();
      String? path = _audioPath; // Use existing path for now

      setState(() {
        _isRecording = false;
      });

      // Stop animations
      _pulseAnimationController.stop();
      _waveAnimationController.stop();

      // Stop timer
      _timer?.cancel();

      if (path != null) {
        setState(() {
          _audioPath = path;
        });
        print('Recording saved: $path');

        // Check file size
        final file = File(path);
        if (await file.exists()) {
          final fileSize = await file.length();
          print('File size: $fileSize bytes');
        }
      }
    } catch (e) {
      print('Error stopping recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to stop recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cancelRecording() async {
    if (_isRecording) {
      await _stopRecording();
    }

    // Delete the recorded file if it exists
    if (_audioPath != null) {
      try {
        final file = File(_audioPath!);
        if (await file.exists()) {
          await file.delete();
          print('Deleted audio file: $_audioPath');
        }
      } catch (e) {
        print('Error deleting file: $e');
      }
    }

    setState(() {
      _recordingDuration = Duration.zero;
      _audioPath = null;
    });
    Navigator.of(context).pop();
  }

  Future<void> _createTicket() async {
    if (_isRecording) {
      await _stopRecording();
    }

    if (_audioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No audio recording found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verify the file exists
    final file = File(_audioPath!);
    if (!await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio file not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final fileSize = await file.length();
    print('Creating ticket with audio file: $_audioPath ($fileSize bytes)');

    // TODO: Upload audio file to server or save locally
    // For now, we'll just show success message

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Ticket audio créé avec succès! (${(fileSize / 1024).round()} KB)'),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
    );

    // Navigate back to tickets page
    Navigator.of(context).pop();
    // Optionally navigate to ticket creation page with audio file
    // Navigator.pushNamed(context, '/main/tickets/create', arguments: {'audioPath': _audioPath});
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = (duration.inMilliseconds.remainder(1000) / 10)
        .round()
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds.$milliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Record Audio',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Waveform visualization area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  // Background waveform
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WaveformPainter(
                        isRecording: _isRecording,
                        animationValue: _waveAnimationController.value,
                      ),
                    ),
                  ),

                  // Timer display
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _formatDuration(_recordingDuration),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[700],
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Controls area
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Recording controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Video camera button (disabled for audio recording)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      // Record button with pulse animation
                      GestureDetector(
                        onTap: _hasPermission
                            ? (_isRecording ? _stopRecording : _startRecording)
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Microphone permission required'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isRecording ? _pulseAnimation.value : 1.0,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF4ECDC4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4ECDC4)
                                          .withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                    ),
                                    if (_isRecording) ...[
                                      BoxShadow(
                                        color: const Color(0xFF4ECDC4)
                                            .withOpacity(0.2),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF4ECDC4)
                                            .withOpacity(0.1),
                                        blurRadius: 60,
                                        spreadRadius: 20,
                                      ),
                                    ],
                                  ],
                                ),
                                child: Icon(
                                  _isRecording ? Icons.stop : Icons.mic,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Edit button
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),

                  // Action buttons
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: GestureDetector(
                          onTap: _cancelRecording,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Annuler',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Create button
                      Expanded(
                        child: GestureDetector(
                          onTap: (_recordingDuration.inSeconds > 0 ||
                                  _audioPath != null)
                              ? _createTicket
                              : null,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: (_recordingDuration.inSeconds > 0 ||
                                      _audioPath != null)
                                  ? Colors.black
                                  : Colors.grey[400],
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Créer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final bool isRecording;
  final double animationValue;

  WaveformPainter({required this.isRecording, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final random = Random(42); // Fixed seed for consistent waveform

    // Draw waveform
    final waveWidth = size.width;
    final waveHeight = size.height * 0.6;

    // Create a path for the waveform
    final path = Path();

    // Generate wave points
    final points = <Offset>[];
    for (int i = 0; i < waveWidth; i += 4) {
      final x = i.toDouble();
      final baseAmplitude = isRecording
          ? sin((i * 0.02) + (animationValue * 20)) * (waveHeight * 0.3)
          : sin(i * 0.01) * (waveHeight * 0.1);

      // Add some randomness for more realistic waveform
      final amplitude =
          baseAmplitude + (random.nextDouble() - 0.5) * (isRecording ? 50 : 20);

      final y = centerY + amplitude;
      points.add(Offset(x, y));
    }

    // Draw the waveform as a smooth curve
    if (points.isNotEmpty) {
      path.moveTo(0, centerY);

      for (int i = 0; i < points.length - 1; i++) {
        final current = points[i];
        final next = points[i + 1];

        // Create smooth curve between points
        final controlPoint1 = Offset(
          current.dx + (next.dx - current.dx) * 0.5,
          current.dy,
        );
        final controlPoint2 = Offset(
          current.dx + (next.dx - current.dx) * 0.5,
          next.dy,
        );

        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          next.dx,
          next.dy,
        );
      }

      // Close the path to create a filled area
      path.lineTo(waveWidth, centerY + waveHeight);
      path.lineTo(0, centerY + waveHeight);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return isRecording != oldDelegate.isRecording ||
        animationValue != oldDelegate.animationValue;
  }
}
