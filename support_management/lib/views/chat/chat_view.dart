import 'package:flutter/material.dart';
import 'chat_details_view.dart';
import '../widgets/search_add.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Tout';

  // Sample chat data
  final List<ChatItem> _allChats = [
    ChatItem(
      id: '1',
      name: 'Smith Mathew',
      lastMessage: 'Hi, David. Hope you\'re doing....',
      time: '29 mar',
      avatar: 'assets/images/profile.png',
      isOnline: true,
      type: ChatType.client,
    ),
    ChatItem(
      id: '2',
      name: 'Merry An.',
      lastMessage: 'Are you ready for today\'s part..',
      time: '12 mar',
      avatar: 'assets/images/profile.png',
      isOnline: false,
      type: ChatType.client,
    ),
    ChatItem(
      id: '3',
      name: 'John Walton',
      lastMessage: 'I\'m sending you a parcel rece..',
      time: '08 Feb',
      avatar: 'assets/images/profile.png',
      isOnline: true,
      type: ChatType.groupe,
    ),
    ChatItem(
      id: '4',
      name: 'Monica Randawa',
      lastMessage: 'Hope you\'re doing well today..',
      time: '02 Feb',
      avatar: 'assets/images/profile.png',
      isOnline: false,
      type: ChatType.client,
    ),
    ChatItem(
      id: '5',
      name: 'Innoxent Jay',
      lastMessage: 'Let\'s get back to the work, You..',
      time: '25 Jan',
      avatar: 'assets/images/profile.png',
      isOnline: true,
      type: ChatType.equipe,
    ),
    ChatItem(
      id: '6',
      name: 'Harry Samit',
      lastMessage: 'Listen david, i have a problem..',
      time: '18 Jan',
      avatar: 'assets/images/profile.png',
      isOnline: false,
      type: ChatType.client,
    ),
  ];

  List<ChatItem> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = _allChats;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChats() {
    setState(() {
      List<ChatItem> filtered = _allChats;

      // Apply search filter
      final searchQuery = _searchController.text.toLowerCase();
      if (searchQuery.isNotEmpty) {
        filtered = filtered
            .where((chat) =>
                chat.name.toLowerCase().contains(searchQuery) ||
                chat.lastMessage.toLowerCase().contains(searchQuery))
            .toList();
      }

      // Apply type filter
      if (_selectedFilter != 'Tout') {
        ChatType filterType;
        switch (_selectedFilter) {
          case 'Client':
            filterType = ChatType.client;
            break;
          case 'Groupe':
            filterType = ChatType.groupe;
            break;
          case 'équipe':
            filterType = ChatType.equipe;
            break;
          default:
            filterType = ChatType.client;
        }
        filtered = filtered.where((chat) => chat.type == filterType).toList();
      }

      _filteredChats = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey[600],
              size: 24,
            ),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: const Color(0xFFF6F6F6),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                // Use shared SearchAndAdd widget
                SearchAndAdd(
                  controller: _searchController,
                  showAdd: false,
                  showFilter: false,
                ),

                const SizedBox(height: 18),

                // Filter Tabs
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterTab('Tout'),
                            const SizedBox(width: 7),
                            _buildFilterTab('Client'),
                            const SizedBox(width: 7),
                            _buildFilterTab('Groupe'),
                            const SizedBox(width: 7),
                            _buildFilterTab('équipe'),
                            const SizedBox(
                                width: 16), // Extra space before filter icon
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chat List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: _filteredChats.length,
              itemBuilder: (context, index) {
                final chat = _filteredChats[index];
                return _buildChatItem(chat);
              },
            ),
          ),
        ],
      ),
      // You can add a bottomNavigationBar here if needed
    );
  }

  Widget _buildFilterTab(String title) {
    final isSelected = _selectedFilter == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
        _filterChats();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2D3134) : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          border: isSelected
              ? null
              : Border.all(
                  color: const Color(0xFFEEEEEE),
                  width: 1,
                ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color:
                isSelected ? const Color(0xFFFFFFFF) : const Color(0xFFA39C9C),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(ChatItem chat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailsView(
              contactName: chat.name,
              contactAvatar: chat.avatar,
              isOnline: chat.isOnline,
              contactId: chat.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(chat.avatar),
                  backgroundColor: Colors.grey[300],
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: chat.avatar.isEmpty
                      ? Text(
                          chat.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                if (chat.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Chat details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 17.31,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        chat.time,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 13.46,
                          color: Color(0xFFC5BDBD),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.38,
                      color: Color(0xFF9C9797),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chat item model
class ChatItem {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatar;
  final bool isOnline;
  final ChatType type;

  ChatItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatar,
    required this.isOnline,
    required this.type,
  });
}

enum ChatType {
  client,
  groupe,
  equipe,
}
