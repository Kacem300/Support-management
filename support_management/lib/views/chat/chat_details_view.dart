import 'package:flutter/material.dart';

class ChatDetailsView extends StatefulWidget {
  final String contactName;
  final String contactAvatar;
  final bool isOnline;
  final String contactId;

  const ChatDetailsView({
    super.key,
    required this.contactName,
    required this.contactAvatar,
    required this.isOnline,
    required this.contactId,
  });

  @override
  State<ChatDetailsView> createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetailsView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample chat messages
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Bonjour, comment puis-je vous aider ?',
      'isMe': false,
      'time': '09:00',
      'type': 'text',
    },
    {
      'text': 'Bonjour ! J’ai une question sur ma commande.',
      'isMe': true,
      'time': '09:01',
      'type': 'text',
    },
    {
      'text': 'Bien sûr, quel est votre numéro de commande ?',
      'isMe': false,
      'time': '09:02',
      'type': 'text',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time': TimeOfDay.now().format(context),
        'type': 'text',
      });
    });
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(widget.contactAvatar),
              backgroundColor: Colors.grey[300],
              onBackgroundImageError: (e, s) {},
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.isOnline
                            ? const Color(0xFF4CAF50)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.isOnline ? 'En ligne' : 'Hors ligne',
                      style: TextStyle(
                        color: widget.isOnline
                            ? const Color(0xFF4CAF50)
                            : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Phone icon
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/images/Phone.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.phone,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              onPressed: () {
                // Handle phone call
              },
            ),
          ),
          // Camera icon
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/images/Camera.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.videocam,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              onPressed: () {
                // Handle video call
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: msg['isMe']
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 192.4170684814453,
                        constraints: const BoxConstraints(
                          minHeight: 38.48341369628906,
                        ),
                        padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
                        decoration: BoxDecoration(
                          color: msg['isMe']
                              ? const Color(0xFFD0ECE8)
                              : const Color(0xE4E4E4D4),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(19.24),
                            topRight: Radius.circular(19.24),
                            bottomRight: Radius.circular(19.24),
                            bottomLeft: Radius.circular(0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: msg['isMe']
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg['text'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              msg['time'],
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Message input field
                Expanded(
                  child: Container(
                    width: 288.6255798339844,
                    height: 48.10426712036133,
                    padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(26.94),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 15.39,
                        height: 1.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Send Message',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 15.39,
                          height: 1.0,
                          color: Color(0xFFC5BDBD),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: GestureDetector(
                          onTap: _sendMessage,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/images/Send.png',
                              width: 24,
                              height: 24,
                              color: const Color(0xFFC5BDBD),
                              colorBlendMode: BlendMode.srcIn,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.send,
                                color: Color(0xFFC5BDBD),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Microphone button
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF55A99D), Color(0xFF007665)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/Microphone.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    onPressed: () {
                      // Handle voice recording
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
