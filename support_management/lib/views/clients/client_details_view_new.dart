import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/client_controller.dart';
import '../../models/client_model.dart';
import '../../models/ticket_model.dart';

class ClientDetailsView extends StatefulWidget {
  final ClientModel client;

  const ClientDetailsView({
    super.key,
    required this.client,
  });

  @override
  State<ClientDetailsView> createState() => _ClientDetailsViewState();
}

class _ClientDetailsViewState extends State<ClientDetailsView> {
  bool _isInfoExpanded = true; // Initially expanded as shown in first image
  bool _isScrolled = false; // Track scroll state
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load client details after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadClientDetails();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Enter scroll mode when scrolling down more than 200 pixels
    // Exit scroll mode when scrolling back to top (offset < 50)
    if (!_isScrolled && _scrollController.offset > 200) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_isScrolled && _scrollController.offset < 50) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  Future<void> _loadClientDetails() async {
    try {
      final clientController =
          Provider.of<ClientController>(context, listen: false);
      await clientController.getClientById(widget.client.id);
      if (mounted) {
        setState(() {
          // Client details loaded successfully
        });
      }
    } catch (e) {
      // Handle errors locally without affecting global controller state
      if (mounted) {
        print('Error loading client details: $e');
        // You could set a local error state here if needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = widget.client;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Dynamic SliverAppBar that changes based on scroll state
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: _isScrolled ? 2 : 0,
            automaticallyImplyLeading: false,
            expandedHeight: _isScrolled ? 140 : 80,
            flexibleSpace: SafeArea(
              child: _isScrolled
                  ? _buildScrollModeHeader(client)
                  : _buildNormalModeHeader(client),
            ),
          ),

          // Content that disappears when scrolled
          if (!_isScrolled) ...[
            SliverToBoxAdapter(
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

                  // Main content
                  Column(
                    children: [
                      // Client profile section
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: _buildProfileSection(client),
                      ),
                      const SizedBox(height: 16),

                      // Client information section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: _buildInfoSection(client),
                      ),
                      const SizedBox(height: 24),

                      // Tickets statistics section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: _buildTicketsSection(client),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Recent tickets section - always visible
          SliverToBoxAdapter(
            child: _buildRecentTicketsSection(),
          ),
        ],
      ),
    );
  }

  // Normal mode header (when not scrolled)
  Widget _buildNormalModeHeader(ClientModel client) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundImage:
                client.avatar != null ? NetworkImage(client.avatar!) : null,
            backgroundColor: Colors.grey[300],
            child: client.avatar == null
                ? Text(
                    client.name.substring(0, 1).toUpperCase(),
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
            client.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Scroll mode header (when scrolled)
  Widget _buildScrollModeHeader(ClientModel client) {
    return Column(
      children: [
        // Top row with back button and profile
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 16,
                backgroundImage:
                    client.avatar != null ? NetworkImage(client.avatar!) : null,
                backgroundColor: Colors.grey[300],
                child: client.avatar == null
                    ? Text(
                        client.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                client.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        // Compact ticket stats row
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildCompactTicketStatCard(
                  'Nouveau',
                  client.ticketsNew.toString().padLeft(2, '0'),
                  'assets/images/ticketnouveau.png',
                  const Color(0xFF3498DB),
                  const Color(0xFF3498DB).withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCompactTicketStatCard(
                  'En cours',
                  client.ticketsInProgress.toString().padLeft(2, '0'),
                  'assets/images/ticketencour.png',
                  const Color(0xFFF39C12),
                  const Color(0xFFF39C12).withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCompactTicketStatCard(
                  'Résolu',
                  client.ticketsResolved.toString().padLeft(2, '0'),
                  'assets/images/ticketresolu.png',
                  const Color(0xFF27AE60),
                  const Color(0xFF27AE60).withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCompactTicketStatCard(
                  'Rejeter',
                  client.ticketsRejected.toString().padLeft(2, '0'),
                  'assets/images/ticketrejeter.png',
                  const Color(0xFFE74C3C),
                  const Color(0xFFE74C3C).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE9ECEF),
                width: 1,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Recherche client',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/Search.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 20,
                      );
                    },
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(ClientModel client) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: client.avatar != null
                        ? AssetImage(client.avatar!)
                        : const AssetImage('assets/images/default_avatar.png'),
                    backgroundColor: Colors.grey[300],
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: (client.avatar?.isEmpty ?? true)
                        ? Text(
                            client.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  if (client.isActive)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D68F),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${client.joinDate.day}/${client.joinDate.month}/${client.joinDate.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9500),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Open chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '+ New ticket',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }

  Widget _buildInfoSection(ClientModel client) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isInfoExpanded = !_isInfoExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: Column(
              children: [
                const SizedBox(height: 20),
                _buildInfoRow(Icons.email_outlined, 'Email', client.email),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.phone_outlined, 'Phone',
                    client.phoneNumber ?? '+6282283386756'),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.language, 'Website',
                    client.website ?? 'www.aftercode.tn'),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.calendar_today_outlined, 'Client depuis',
                    '${client.joinDate.day}/${client.joinDate.month}/${client.joinDate.year}'),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on_outlined, 'Adresse',
                    client.address ?? '2464 Royal Ln. Mesa, New Jersey'),
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
    );
  }

  Widget _buildTicketsSection(ClientModel client) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistiques tickets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildTicketStatCard(
                'Tickets résolu',
                client.ticketsResolved.toString().padLeft(2, '0'),
                'assets/images/ticketresolu.png',
                const Color(0xFF27AE60), // Green like in home_view
                const Color(0xFF27AE60).withOpacity(0.1),
              ),
              _buildTicketStatCard(
                'Tickets rejeter',
                client.ticketsRejected.toString().padLeft(2, '0'),
                'assets/images/ticketrejeter.png',
                const Color(0xFFE74C3C), // Red like in home_view
                const Color(0xFFE74C3C).withOpacity(0.1),
              ),
              _buildTicketStatCard(
                'Nouveau tickets',
                client.ticketsNew.toString().padLeft(2, '0'),
                'assets/images/ticketnouveau.png',
                const Color(0xFF3498DB), // Blue like in home_view
                const Color(0xFF3498DB).withOpacity(0.1),
              ),
              _buildTicketStatCard(
                'Tickets en cours',
                client.ticketsInProgress.toString().padLeft(2, '0'),
                'assets/images/ticketencour.png',
                const Color(0xFFF39C12), // Orange like in home_view
                const Color(0xFFF39C12).withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTicketsSection() {
    return FutureBuilder<List<TicketModel>>(
      future: Provider.of<ClientController>(context, listen: false)
          .getClientTickets(widget.client.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No tickets available');
        }
        final tickets = snapshot.data!;
        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tickets récents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ...tickets.map((ticket) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildRecentTicketItem(
                      ticket.title,
                      'Ticket# ${ticket.id}',
                      _formatDate(ticket.createdAt),
                      _getPriorityText(ticket.priority),
                      ticket.description,
                      _getStatusText(ticket.status),
                      _getStatusColor(ticket.status),
                    ),
                  )),
            ],
          ),
        );
      },
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category name at the top
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.33,
              fontWeight: FontWeight.w600,
              color: Color(0xFF595757),
            ),
          ),
          const Spacer(),
          // Bottom row with icon and number next to each other
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Icon on the left
              Image.asset(
                iconPath,
                width: 32, // Bigger icon size
                height: 32,
                color: iconColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.confirmation_number,
                    size: 32,
                    color: iconColor,
                  );
                },
              ),
              const SizedBox(width: 8), // Space between icon and number
              // Number next to the icon
              Text(
                count,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3A3F51),
                ),
              ),
            ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 16,
            height: 16,
            color: iconColor,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.confirmation_number,
                size: 16,
                color: iconColor,
              );
            },
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: iconColor,
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
    // Parse dateTime to get date and time components
    final parts = dateTime.split(' ');
    final datePart = parts.isNotEmpty ? parts[0] : dateTime;
    final timePart = parts.length > 1 ? parts[1] : '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticketNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Use the appropriate status icon
                    Image.asset(
                      _getStatusIcon(status),
                      width: 19,
                      height: 19,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.circle,
                          size: 19,
                          color: statusColor,
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF39C12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date, time, and priority row
          Row(
            children: [
              // Date/Time in gray box
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timePart.isNotEmpty ? '$datePart / $timePart' : datePart,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Priority in gray box
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      _getPriorityIcon(priority),
                      width: 16,
                      height: 16,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.flag,
                          size: 16,
                          color: Colors.grey[600],
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      priority,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for ticket data formatting
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    }
  }

  String _getPriorityText(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return 'Basse';
      case TicketPriority.medium:
        return 'Moyenne';
      case TicketPriority.high:
        return 'Haute';
      case TicketPriority.urgent:
        return 'Urgente';
    }
  }

  String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Nouveau';
      case TicketStatus.inProgress:
        return 'En cours';
      case TicketStatus.resolved:
        return 'Résolu';
      case TicketStatus.closed:
        return 'Fermé';
    }
  }

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return const Color(0xFF3B82F6);
      case TicketStatus.inProgress:
        return const Color(0xFFF59E0B);
      case TicketStatus.resolved:
        return const Color(0xFF10B981);
      case TicketStatus.closed:
        return const Color(0xFF6B7280);
    }
  }

  // Get priority icon based on priority level
  String _getPriorityIcon(String priority) {
    final priorityStr = priority.toLowerCase();
    if (priorityStr.contains('urgente')) {
      return 'assets/images/flag.png'; // Urgente - red flag
    } else if (priorityStr.contains('haute')) {
      return 'assets/images/flagHaute.png'; // Haute - orange flag
    } else if (priorityStr.contains('moyenne')) {
      return 'assets/images/flagMoyenne.png'; // Moyenne - yellow flag
    } else if (priorityStr.contains('basse')) {
      return 'assets/images/flagBasse.png'; // Basse - blue flag
    }
    return 'assets/images/flag.png'; // Default
  }

  // Get status icon based on status
  String _getStatusIcon(String status) {
    final statusStr = status.toLowerCase();
    if (statusStr.contains('nouveau')) {
      return 'assets/images/stickernouveau.png'; // Nouveau
    } else if (statusStr.contains('ouvert') || statusStr.contains('en cours')) {
      return 'assets/images/stickerOuvert.png'; // Ouvert/En cours
    } else if (statusStr.contains('rejeter') || statusStr.contains('fermé')) {
      return 'assets/images/StickerRejeter.png'; // Rejeter/Fermé
    } else if (statusStr.contains('résolu') || statusStr.contains('resolu')) {
      return 'assets/images/StickerResolu.png'; // Résolu
    }
    return 'assets/images/stickernouveau.png'; // Default
  }
}
