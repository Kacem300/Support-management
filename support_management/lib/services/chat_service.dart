import '../models/models.dart';

abstract class ChatServiceInterface {
  Future<List<ChatModel>> getMessagesForTicket(String ticketId);
  Future<ChatModel> sendMessage({
    required String ticketId,
    required String content,
    required MessageType type,
  });
  Future<ChatModel> sendAudioMessage({
    required String ticketId,
    required String audioPath,
  });
  Future<ChatModel> sendImageMessage({
    required String ticketId,
    required String imagePath,
  });
  Future<ChatModel> sendFileMessage({
    required String ticketId,
    required String filePath,
    required String fileName,
  });
  Future<void> markMessagesAsRead(String ticketId);
  Future<void> deleteMessage(String messageId);
}

class ChatService implements ChatServiceInterface {
  // Mock implementation - replace with real API calls

  @override
  Future<List<ChatModel>> getMessagesForTicket(String ticketId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock chat messages for the ticket
    return [
      ChatModel(
        id: 'msg_1',
        ticketId: ticketId,
        senderName: 'John Doe',
        senderId: 'client_123',
        content: 'Bonjour, j\'ai un problème avec mon compte.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isFromClient: true,
        isRead: true,
      ),
      ChatModel(
        id: 'msg_2',
        ticketId: ticketId,
        senderName: 'Support Agent',
        senderId: 'agent_456',
        content:
            'Bonjour, je vais vous aider. Pouvez-vous me donner plus de détails?',
        type: MessageType.text,
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isFromClient: false,
        isRead: true,
      ),
      ChatModel(
        id: 'msg_3',
        ticketId: ticketId,
        senderName: 'John Doe',
        senderId: 'client_123',
        content: 'Voici une capture d\'écran du problème.',
        type: MessageType.image,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isFromClient: true,
        imagePath: 'assets/images/screenshot.png',
        isRead: false,
      ),
    ];
  }

  @override
  Future<ChatModel> sendMessage({
    required String ticketId,
    required String content,
    required MessageType type,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Create new message
    return ChatModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticketId,
      senderName: 'Support Agent',
      senderId: 'current_user',
      content: content,
      type: type,
      timestamp: DateTime.now(),
      isFromClient: false,
      isRead: true,
    );
  }

  @override
  Future<ChatModel> sendAudioMessage({
    required String ticketId,
    required String audioPath,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    return ChatModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticketId,
      senderName: 'Support Agent',
      senderId: 'current_user',
      content: 'Audio message',
      type: MessageType.audio,
      timestamp: DateTime.now(),
      isFromClient: false,
      audioPath: audioPath,
      isRead: true,
    );
  }

  @override
  Future<ChatModel> sendImageMessage({
    required String ticketId,
    required String imagePath,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));

    return ChatModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticketId,
      senderName: 'Support Agent',
      senderId: 'current_user',
      content: 'Image sent',
      type: MessageType.image,
      timestamp: DateTime.now(),
      isFromClient: false,
      imagePath: imagePath,
      isRead: true,
    );
  }

  @override
  Future<ChatModel> sendFileMessage({
    required String ticketId,
    required String filePath,
    required String fileName,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 700));

    return ChatModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticketId,
      senderName: 'Support Agent',
      senderId: 'current_user',
      content: 'File: $fileName',
      type: MessageType.file,
      timestamp: DateTime.now(),
      isFromClient: false,
      fileName: fileName,
      isRead: true,
    );
  }

  @override
  Future<void> markMessagesAsRead(String ticketId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // In a real app, this would mark messages as read on the server
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 400));

    // In a real app, this would delete the message from the server
  }
}
