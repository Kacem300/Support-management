enum MessageType { text, audio, image, file }

class ChatModel {
  final String id;
  final String ticketId;
  final String senderName;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isFromClient;
  final String? audioPath;
  final String? imagePath;
  final String? fileName;
  final bool isRead;

  const ChatModel({
    required this.id,
    required this.ticketId,
    required this.senderName,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isFromClient = false,
    this.audioPath,
    this.imagePath,
    this.fileName,
    this.isRead = false,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? '',
      ticketId: json['ticketId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isFromClient: json['isFromClient'] ?? false,
      audioPath: json['audioPath'],
      imagePath: json['imagePath'],
      fileName: json['fileName'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketId': ticketId,
      'senderName': senderName,
      'senderId': senderId,
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isFromClient': isFromClient,
      'audioPath': audioPath,
      'imagePath': imagePath,
      'fileName': fileName,
      'isRead': isRead,
    };
  }

  ChatModel copyWith({
    String? id,
    String? ticketId,
    String? senderName,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isFromClient,
    String? audioPath,
    String? imagePath,
    String? fileName,
    bool? isRead,
  }) {
    return ChatModel(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isFromClient: isFromClient ?? this.isFromClient,
      audioPath: audioPath ?? this.audioPath,
      imagePath: imagePath ?? this.imagePath,
      fileName: fileName ?? this.fileName,
      isRead: isRead ?? this.isRead,
    );
  }
}
