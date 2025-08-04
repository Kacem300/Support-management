import 'package:flutter/material.dart';

class ChatDetailsPage extends StatefulWidget {
  final String contactName;
  final String contactAvatar;
  final bool isOnline;
  final String contactId;

  const ChatDetailsPage({
    super.key,
    required this.contactName,
    required this.contactAvatar,
    required this.isOnline,
    required this.contactId,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample chat messages
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: 'Are you still travelling?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: MessageType.text,
    ),
    ChatMessage(
      id: '2',
      text: 'Yes, i\'m at Istanbul..',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
      type: MessageType.text,
    ),
    ChatMessage(
      id: '3',
      text: 'OoOo, Thats so Cool!',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
      type: MessageType.text,
    ),
    ChatMessage(
      id: '4',
      text: 'Raining??',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      type: MessageType.text,
    ),
    ChatMessage(
      id: '5',
      text: '',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)),
      type: MessageType.voice,
      voiceDuration: 15,
    ),
    ChatMessage(
      id: '6',
      text: 'Hi, Did you heared?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: MessageType.text,
    ),
    ChatMessage(
      id: '7',
      text: '',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1, minutes: 5)),
      type: MessageType.voice,
      voiceDuration: 25,
    ),
    ChatMessage(
      id: '8',
      text: 'Ok!',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1, minutes: 10)),
      type: MessageType.text,
    ),
    ChatMessage(
      id: '9',
      text: '',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1, minutes: 15)),
      type: MessageType.voice,
      voiceDuration: 30,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.insert(
            0,
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: _messageController.text.trim(),
              isMe: true,
              timestamp: DateTime.now(),
              type: MessageType.text,
            ));
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${_getWeekday(date.weekday)} ${date.day}, ${date.year}';
    }
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(widget.contactAvatar),
                  backgroundColor: Colors.grey[300],
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: widget.contactAvatar.isEmpty
                      ? Text(
                          widget.contactName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                if (widget.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  if (widget.isOnline)
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Active Now',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black, size: 24),
            onPressed: () {
              // Handle call
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.black, size: 24),
            onPressed: () {
              // Handle video call
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final previousMessage =
                    index < _messages.length - 1 ? _messages[index + 1] : null;

                // Show date separator if this is the first message of a new day
                bool showDateSeparator = false;
                if (previousMessage == null ||
                    !_isSameDay(message.timestamp, previousMessage.timestamp)) {
                  showDateSeparator = true;
                }

                return Column(
                  children: [
                    if (showDateSeparator)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          _formatDate(message.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    _buildMessageBubble(message),
                  ],
                );
              },
            ),
          ),
          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(widget.contactAvatar),
              backgroundColor: Colors.grey[300],
              child: widget.contactAvatar.isEmpty
                  ? Text(
                      widget.contactName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    message.isMe ? const Color(0xFF4ECDC4) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: message.type == MessageType.text
                  ? Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: message.isMe ? Colors.white : Colors.black,
                      ),
                    )
                  : _buildVoiceMessage(message),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF4ECDC4),
              child: const Text(
                'M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVoiceMessage(ChatMessage message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: message.isMe
                ? Colors.white.withOpacity(0.2)
                : const Color(0xFF4ECDC4),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow,
            color: message.isMe ? Colors.white : Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Voice waveform visualization
              Row(
                children: List.generate(20, (index) {
                  final heights = [
                    2.0,
                    8.0,
                    4.0,
                    12.0,
                    6.0,
                    10.0,
                    3.0,
                    14.0,
                    5.0,
                    9.0,
                    7.0,
                    11.0,
                    4.0,
                    13.0,
                    8.0,
                    6.0,
                    2.0,
                    10.0,
                    5.0,
                    12.0
                  ];
                  return Container(
                    width: 2,
                    height: heights[index % heights.length],
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFF4ECDC4).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '${message.voiceDuration}s',
                style: TextStyle(
                  fontSize: 12,
                  color: message.isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Send Message',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF4ECDC4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF4ECDC4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Message model
class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageType type;
  final int? voiceDuration; // in seconds

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.type,
    this.voiceDuration,
  });
}

enum MessageType {
  text,
  voice,
}
