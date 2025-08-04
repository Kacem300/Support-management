import 'package:flutter/material.dart';
import '../home/filter_page.dart';

class ClientDetailsPage extends StatefulWidget {
  final String clientId;
  final String clientName;
  final String joinDate;
  final bool isActive;
  final int ticketsInProgress;
  final int ticketsResolved;
  final String avatar;

  const ClientDetailsPage({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.joinDate,
    required this.isActive,
    required this.ticketsInProgress,
    required this.ticketsResolved,
    required this.avatar,
  });

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  bool _isInfoExpanded = true; // Initially expanded as shown in first image
  bool _isScrolled = false; // Track scroll state
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Change layout when user scrolls down more than 100 pixels
    final isScrolled = _scrollController.offset > 500;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
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
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Détail client',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Header section with subtitle
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: const Text(
                    'Expliquez votre problème, nous le résolvons.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // Add top padding when scrolled to make space for sticky header
                if (_isScrolled) const SizedBox(height: 700),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      // Client Profile Card - Only show when not scrolled
                      if (!_isScrolled) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Client Avatar and Info
                              Row(
                                children: [
                                  // Avatar with online indicator
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            AssetImage(widget.avatar),
                                        backgroundColor: Colors.grey[300],
                                        onBackgroundImageError:
                                            (exception, stackTrace) {},
                                        child: widget.avatar.isEmpty
                                            ? Text(
                                                widget.clientName
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : null,
                                      ),
                                      if (widget.isActive)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
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
                                  // Client Info and Buttons
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.clientName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.joinDate,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6B7280),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Action Buttons Row - Smaller and under info
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // TODO: Open chat functionality
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  elevation: 0,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                                  minimumSize:
                                                      const Size(0, 32),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    side: const BorderSide(
                                                      color: Color(0xFFFF6B35),
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/openchat.png',
                                                      width: 14,
                                                      height: 14,
                                                      color: const Color(
                                                          0xFFFF6B35),
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                          Icons
                                                              .chat_bubble_outline,
                                                          color:
                                                              Color(0xFFFF6B35),
                                                          size: 14,
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Flexible(
                                                      child: Text(
                                                        'Open chat',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xFFFF6B35),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              flex: 1,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // TODO: New ticket functionality
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  elevation: 0,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                                  minimumSize:
                                                      const Size(0, 32),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    side: BorderSide(
                                                      color: Colors.grey[300]!,
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.add,
                                                      color: Color(0xFF6B7280),
                                                      size: 14,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Flexible(
                                                      child: Text(
                                                        'New ticket',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xFF6B7280),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // General Information Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Expandable header
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isInfoExpanded = !_isInfoExpanded;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Informations générale',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    AnimatedRotation(
                                      turns: _isInfoExpanded ? 0.5 : 0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[400],
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Animated expandable content
                              AnimatedCrossFade(
                                firstChild: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    // Contact Information
                                    _buildInfoRow(
                                      Icons.email_outlined,
                                      'Email',
                                      'alwissuryatmaja@gmail.com',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      Icons.phone_outlined,
                                      'Phone',
                                      '+6282283386756',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      Icons.language,
                                      'Website',
                                      'www.aftercode.tn',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      Icons.calendar_today_outlined,
                                      'Client depuis',
                                      '12 August 2024',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      Icons.location_on_outlined,
                                      '',
                                      '2464 Royal Ln. Mesa, New Jersey',
                                    ),
                                  ],
                                ),
                                secondChild: const SizedBox.shrink(),
                                crossFadeState: _isInfoExpanded
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                duration: const Duration(milliseconds: 300),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Ticket Statistics Grid
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.3,
                          children: [
                            _buildTicketStatCard(
                              'Tickets résolu',
                              '03',
                              'assets/images/ticketresolu.png',
                              const Color(0xFF10B981),
                              const Color(0xFFD1FAE5),
                            ),
                            _buildTicketStatCard(
                              'Tickets rjeter',
                              '03',
                              'assets/images/ticketrejeter.png',
                              const Color(0xFFEF4444),
                              const Color(0xFFFEE2E2),
                            ),
                            _buildTicketStatCard(
                              'Nouveau tickets',
                              '08',
                              'assets/images/ticketnouveau.png',
                              const Color(0xFF3B82F6),
                              const Color(0xFFDBEAFE),
                            ),
                            _buildTicketStatCard(
                              'Tickets en cours',
                              '03',
                              'assets/images/ticketencour.png',
                              const Color(0xFFF59E0B),
                              const Color(0xFFFEF3C7),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],

                      // Recent Tickets Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add extra spacing when scrolled
                          if (_isScrolled) const SizedBox(height: 24),
                          const Text(
                            'Tickets récents',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildRecentTicketItem(
                            'Design NFT landing page shot',
                            'Ticket# 2023-CS123',
                            '13.08.2023 / 10:55',
                            'Urgente',
                            'Design a simple home pages with clean layout and color based on the guidelin to...',
                            'Nouveau',
                            const Color(0xFF3B82F6),
                          ),
                          const SizedBox(height: 16),
                          _buildRecentTicketItem(
                            'Design NFT landing page shot',
                            'Ticket# 2023-CS123',
                            '13.08.2023 / 10:55',
                            'Urgente',
                            'Design a simple home pages with clean layout and color based on the guidelin to...',
                            'Nouveau',
                            const Color(0xFF3B82F6),
                          ),
                          const SizedBox(height: 16),
                          _buildRecentTicketItem(
                            'Design NFT landing page shot',
                            'Ticket# 2023-CS123',
                            '13.08.2023 / 10:55',
                            'Urgente',
                            'Design a simple home pages with clean layout and color based on the guidelin to...',
                            'Nouveau',
                            const Color(0xFF3B82F6),
                          ),
                          const SizedBox(height: 16),
                          _buildRecentTicketItem(
                            'Design NFT landing page shot',
                            'Ticket# 2023-CS123',
                            '13.08.2023 / 10:55',
                            'Urgente',
                            'Design a simple home pages with clean layout and color based on the guidelin to...',
                            'Nouveau',
                            const Color(0xFF3B82F6),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky header when scrolled - Fixed at top
          if (_isScrolled)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Client name only
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(widget.avatar),
                          backgroundColor: Colors.grey[300],
                          child: widget.avatar.isEmpty
                              ? Text(
                                  widget.clientName
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.clientName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Divider
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                      height: 1,
                    ),

                    const SizedBox(height: 16),

                    // Horizontally scrollable tickets
                    SizedBox(
                      height: 60,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 100,
                              child: _buildCompactTicketStatCard(
                                'Nouveau',
                                '08',
                                'assets/images/ticketnouveau.png',
                                const Color(0xFF3B82F6),
                                const Color(0xFFDBEAFE),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 100,
                              child: _buildCompactTicketStatCard(
                                'En cours',
                                '03',
                                'assets/images/ticketencour.png',
                                const Color(0xFFF59E0B),
                                const Color(0xFFFEF3C7),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 100,
                              child: _buildCompactTicketStatCard(
                                'Résolu',
                                '03',
                                'assets/images/ticketresolu.png',
                                const Color(0xFF10B981),
                                const Color(0xFFD1FAE5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 100,
                              child: _buildCompactTicketStatCard(
                                'Rejeté',
                                '03',
                                'assets/images/ticketrejeter.png',
                                const Color(0xFFEF4444),
                                const Color(0xFFFEE2E2),
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Search bar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.grey[400],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Recherche client',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Navigate to filter page
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FilterPage(),
                                ),
                              );

                              // Handle filter results if needed
                              if (result != null) {
                                // Apply filters to client tickets
                                print('Applied filters: $result');
                              }
                            },
                            child: Icon(
                              Icons.tune,
                              color: Colors.grey[400],
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      // The following block is a duplicate and should be removed.
      // Remove this entire children: [ ... ] block.
      bottomNavigationBar: Stack(
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
              currentIndex: 3, // Clients tab
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
                Navigator.pushNamed(context, '/messages');
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
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label.isNotEmpty)
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              if (label.isNotEmpty) const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketStatCard(
    String title,
    String count,
    String iconPath,
    Color iconColor,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced from 16 to 12
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Added to prevent overflow
        children: [
          Container(
            width: 28, // Reduced from 32
            height: 28, // Reduced from 32
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 16, // Reduced from 18
                height: 16, // Reduced from 18
                color: iconColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.circle,
                    size: 16, // Reduced from 18
                    color: iconColor,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8), // Reduced from 12
          Text(
            count,
            style: const TextStyle(
              fontSize: 18, // Reduced from 20
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2), // Reduced from 4
          Flexible(
            // Added to prevent overflow
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11, // Reduced from 12
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTicketStatCard(
    String title,
    String count,
    String iconPath,
    Color iconColor,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: iconColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 12,
                height: 12,
                color: iconColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.confirmation_number,
                    size: 12,
                    color: iconColor,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTicketItem(
    String title,
    String ticketNumber,
    String dateTime,
    String priority,
    String description,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ticketNumber,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 8),
              Text(
                dateTime,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.flag,
                size: 16,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                priority,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(String assetPath, int index) {
    final isSelected = index == 3; // Current page is clients (index 3)
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
      case 3:
        return Icons.people;
      case 4:
        return Icons.person;
      default:
        return Icons.circle;
    }
  }
}
