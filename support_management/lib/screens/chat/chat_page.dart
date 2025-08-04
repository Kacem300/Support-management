import 'package:flutter/material.dart';
import 'chat_details_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
      backgroundColor: const Color(0xFFF5F5F5),
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
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: const Color(0xFF4ECDC4),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => _filterChats(),
                          decoration: const InputDecoration(
                            hintText: 'Recherche',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
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
      bottomNavigationBar: _buildBottomNavigationBar(),
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
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
            builder: (context) => ChatDetailsPage(
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        chat.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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

  Widget _buildBottomNavigationBar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main navigation bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: 2, // Messages tab (center position)
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main/home',
                    (route) => false,
                  );
                  break;
                case 1:
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main/tickets',
                    (route) => false,
                  );
                  break;
                case 3:
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main/clients',
                    (route) => false,
                  );
                  break;
                case 4:
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main/menu',
                    (route) => false,
                  );
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF4ECDC4),
            unselectedItemColor: Colors.grey[600],
            selectedFontSize: 12,
            unselectedFontSize: 11,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon('assets/images/home.png', 0),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon('assets/images/ticket.png', 1),
                label: 'Tickets',
              ),
              // Empty space for center icon
              const BottomNavigationBarItem(
                icon: SizedBox(height: 40),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon('assets/images/Clients.png', 3),
                label: 'Clients',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon('assets/images/Menu.png', 4),
                label: 'Menu',
              ),
            ],
          ),
        ),
        // Floating center icon
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 30,
          top: -15,
          child: GestureDetector(
            onTap: () {
              // Already on messages page, do nothing or refresh
            },
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/afterIconRemove.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4ECDC4),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'ac',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF4ECDC4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavIcon(String assetPath, int index) {
    final isSelected = index == 2; // Messages is at index 2 (center)
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey[600],
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            _getDefaultIcon(index),
            size: 24,
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey[600],
          );
        },
      ),
    );
  }

  IconData _getDefaultIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.confirmation_number;
      case 2:
        return Icons.message;
      case 3:
        return Icons.people;
      case 4:
        return Icons.person;
      default:
        return Icons.circle;
    }
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
