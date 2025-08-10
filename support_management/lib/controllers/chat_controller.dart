import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class ChatController extends ChangeNotifier {
  final ChatService _chatService;

  ChatController({ChatService? chatService})
      : _chatService = chatService ?? ChatService();

  List<ChatModel> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;
  String _currentTicketId = '';

  // Getters
  List<ChatModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get error => _error;
  String get currentTicketId => _currentTicketId;
  int get unreadCount => _messages.where((m) => !m.isRead).length;

  // Initialize chat for a specific ticket
  Future<void> initializeChat(String ticketId) async {
    _currentTicketId = ticketId;
    await loadMessages();
  }

  // Load messages for current ticket
  Future<void> loadMessages() async {
    if (_currentTicketId.isEmpty) return;

    _setLoading(true);
    try {
      _messages = await _chatService.getMessagesForTicket(_currentTicketId);
      _clearError();
    } catch (e) {
      _setError('Failed to load messages: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Send a text message
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || _currentTicketId.isEmpty) return;

    _setSending(true);
    try {
      final message = await _chatService.sendMessage(
        ticketId: _currentTicketId,
        content: content,
        type: MessageType.text,
      );

      _messages.add(message);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to send message: $e');
    } finally {
      _setSending(false);
    }
  }

  // Send an audio message
  Future<void> sendAudioMessage(String audioPath) async {
    if (audioPath.isEmpty || _currentTicketId.isEmpty) return;

    _setSending(true);
    try {
      final message = await _chatService.sendAudioMessage(
        ticketId: _currentTicketId,
        audioPath: audioPath,
      );

      _messages.add(message);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to send audio message: $e');
    } finally {
      _setSending(false);
    }
  }

  // Send an image message
  Future<void> sendImageMessage(String imagePath) async {
    if (imagePath.isEmpty || _currentTicketId.isEmpty) return;

    _setSending(true);
    try {
      final message = await _chatService.sendImageMessage(
        ticketId: _currentTicketId,
        imagePath: imagePath,
      );

      _messages.add(message);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to send image: $e');
    } finally {
      _setSending(false);
    }
  }

  // Send a file message
  Future<void> sendFileMessage(String filePath, String fileName) async {
    if (filePath.isEmpty || _currentTicketId.isEmpty) return;

    _setSending(true);
    try {
      final message = await _chatService.sendFileMessage(
        ticketId: _currentTicketId,
        filePath: filePath,
        fileName: fileName,
      );

      _messages.add(message);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to send file: $e');
    } finally {
      _setSending(false);
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead() async {
    if (_currentTicketId.isEmpty) return;

    try {
      await _chatService.markMessagesAsRead(_currentTicketId);

      // Update local messages
      for (int i = 0; i < _messages.length; i++) {
        if (!_messages[i].isRead) {
          _messages[i] = _messages[i].copyWith(isRead: true);
        }
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to mark messages as read: $e');
    }
  }

  // Delete a message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _chatService.deleteMessage(messageId);
      _messages.removeWhere((m) => m.id == messageId);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete message: $e');
    }
  }

  // Refresh messages
  Future<void> refresh() async {
    await loadMessages();
  }

  // Clear chat
  void clearChat() {
    _messages.clear();
    _currentTicketId = '';
    _clearError();
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSending(bool sending) {
    _isSending = sending;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
