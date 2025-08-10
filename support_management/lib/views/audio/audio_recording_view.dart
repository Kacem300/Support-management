import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';
import '../../constants/constants.dart';

class AudioRecordingView extends StatefulWidget {
  final String ticketId;

  const AudioRecordingView({
    super.key,
    this.ticketId = '',
  });

  @override
  State<AudioRecordingView> createState() => _AudioRecordingViewState();
}

class _AudioRecordingViewState extends State<AudioRecordingView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Initialize audio recording
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioRecordingController>().initialize();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startRecording() async {
    final controller = context.read<AudioRecordingController>();

    // Request permission first
    final hasPermission = await controller.requestPermission();
    if (!hasPermission) {
      _showPermissionDialog();
      return;
    }

    await controller.startRecording();
    _pulseController.repeat(reverse: true);
  }

  void _stopRecording() async {
    await context.read<AudioRecordingController>().stopRecording();
    _pulseController.stop();
    _pulseController.reset();
  }

  void _cancelRecording() async {
    await context.read<AudioRecordingController>().cancelRecording();
    _pulseController.stop();
    _pulseController.reset();
  }

  void _sendRecording() async {
    final controller = context.read<AudioRecordingController>();
    if (controller.hasRecording) {
      // Send the recording via chat controller
      await context.read<ChatController>().sendAudioMessage(
            controller.recording.filePath!,
          );

      // Close the recording screen
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Microphone permission is required to record audio messages. Please grant permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Record Audio'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Consumer<AudioRecordingController>(
        builder: (context, controller, child) {
          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.initialize(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // Header with recording status
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        _getStatusText(controller),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDuration(controller.recording.duration),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Waveform visualization (placeholder)
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      margin: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _buildWaveformVisualization(controller),
                    ),
                  ),
                ),

                // Control buttons
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: _buildControlButtons(controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaveformVisualization(AudioRecordingController controller) {
    return Center(
      child: controller.isRecording
          ? AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            )
          : controller.hasRecording
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.audio_file,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Recording Ready',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mic,
                      size: 64,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap to start recording',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildControlButtons(AudioRecordingController controller) {
    if (!controller.isInitialized) {
      return const CircularProgressIndicator(
        color: Colors.white,
      );
    }

    if (controller.isRecording) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cancel button
          _buildControlButton(
            onPressed: _cancelRecording,
            icon: Icons.close,
            color: Colors.red,
            label: 'Cancel',
          ),

          // Pause/Resume button
          _buildControlButton(
            onPressed: controller.isPaused
                ? () => controller.resumeRecording()
                : () => controller.pauseRecording(),
            icon: controller.isPaused ? Icons.play_arrow : Icons.pause,
            color: Colors.orange,
            label: controller.isPaused ? 'Resume' : 'Pause',
          ),

          // Stop button
          _buildControlButton(
            onPressed: _stopRecording,
            icon: Icons.stop,
            color: AppColors.primary,
            label: 'Stop',
          ),
        ],
      );
    }

    if (controller.hasRecording) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Delete button
          _buildControlButton(
            onPressed: () => controller.deleteRecording(),
            icon: Icons.delete,
            color: Colors.red,
            label: 'Delete',
          ),

          // Play button
          _buildControlButton(
            onPressed: () => controller.playRecording(),
            icon: Icons.play_arrow,
            color: Colors.green,
            label: 'Play',
          ),

          // Send button
          _buildControlButton(
            onPressed: _sendRecording,
            icon: Icons.send,
            color: AppColors.primary,
            label: 'Send',
          ),
        ],
      );
    }

    // Start recording button
    return Center(
      child: _buildControlButton(
        onPressed: _startRecording,
        icon: Icons.fiber_manual_record,
        color: Colors.red,
        label: 'Record',
        size: 80,
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required String label,
    double size = 60,
  }) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
              size: size * 0.4,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _getStatusText(AudioRecordingController controller) {
    if (controller.isRecording) {
      return controller.isPaused ? 'Recording Paused' : 'Recording...';
    } else if (controller.hasRecording) {
      return 'Recording Complete';
    } else {
      return 'Ready to Record';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
