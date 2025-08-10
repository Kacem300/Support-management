enum RecordingState { idle, recording, paused, stopped }

class AudioRecordingModel {
  final String? filePath;
  final Duration duration;
  final RecordingState state;
  final double amplitude;
  final int sampleRate;
  final String? errorMessage;

  const AudioRecordingModel({
    this.filePath,
    this.duration = Duration.zero,
    this.state = RecordingState.idle,
    this.amplitude = 0.0,
    this.sampleRate = 44100,
    this.errorMessage,
  });

  factory AudioRecordingModel.fromJson(Map<String, dynamic> json) {
    return AudioRecordingModel(
      filePath: json['filePath'],
      duration: Duration(milliseconds: json['duration'] ?? 0),
      state: RecordingState.values.firstWhere(
        (e) => e.toString() == 'RecordingState.${json['state']}',
        orElse: () => RecordingState.idle,
      ),
      amplitude: json['amplitude']?.toDouble() ?? 0.0,
      sampleRate: json['sampleRate'] ?? 44100,
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'duration': duration.inMilliseconds,
      'state': state.toString().split('.').last,
      'amplitude': amplitude,
      'sampleRate': sampleRate,
      'errorMessage': errorMessage,
    };
  }

  AudioRecordingModel copyWith({
    String? filePath,
    Duration? duration,
    RecordingState? state,
    double? amplitude,
    int? sampleRate,
    String? errorMessage,
  }) {
    return AudioRecordingModel(
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      state: state ?? this.state,
      amplitude: amplitude ?? this.amplitude,
      sampleRate: sampleRate ?? this.sampleRate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isRecording => state == RecordingState.recording;
  bool get isPaused => state == RecordingState.paused;
  bool get isStopped => state == RecordingState.stopped;
  bool get isIdle => state == RecordingState.idle;
  bool get hasError => errorMessage != null;
}
