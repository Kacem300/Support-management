import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial data using controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketController>(context, listen: false).loadTickets();
      Provider.of<ClientController>(context, listen: false).loadClients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with greeting and notification
                _buildHeaderSection(),

                const SizedBox(height: 20),

                // Search bar and Add button in same row
                _buildSearchAndAddSection(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Ticket Status Cards
          _buildStatusCardsSection(),

          const SizedBox(height: 30),

          // Recent Tickets List
          _buildRecentTicketsSection(),

          const SizedBox(height: 100), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  authController.user?.name ?? 'Hamdi ben hbhb',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // White background
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context,
                      '/notifications'); // Navigate to Notification page
                },
                icon: Image.asset(
                  'assets/images/notificationBell.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.notifications_outlined,
                      color: Colors.grey,
                      size: 24,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchAndAddSection() {
    return Row(
      children: [
        // Search bar
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Recherche ticket',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/Search.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 20,
                      );
                    },
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    // Navigate to filter page
                    Navigator.pushNamed(context, '/home/filter');
                  },
                  child: Icon(
                    Icons.tune,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                // Handle search query changes
                print('Search query: $value');
              },
              onFieldSubmitted: (value) {
                // Handle search submission
                print('Search submitted: $value');
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Add ticket button
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/main/tickets/create/continue');
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCardsSection() {
    return Consumer<TicketController>(
      builder: (context, ticketController, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5, // More rectangular like in Figma
            children: [
              _buildStatusCard(
                title: 'Tickets résolu',
                count: ticketController.resolvedTicketsCount
                    .toString()
                    .padLeft(2, '0'),
                icon: 'assets/images/ticketresolu.png',
                color: const Color(0xFF27AE60), // Green like in image
                backgroundColor: const Color(0xFF27AE60).withOpacity(0.1),
              ),
              _buildStatusCard(
                title: 'Tickets rejeter', // Match exact text from image
                count: ticketController.closedTicketsCount
                    .toString()
                    .padLeft(2, '0'),
                icon: 'assets/images/ticketrejeter.png',
                color: const Color(0xFFE74C3C), // Red like in image
                backgroundColor: const Color(0xFFE74C3C).withOpacity(0.1),
              ),
              _buildStatusCard(
                title: 'Nouveau tickets',
                count: ticketController.openTicketsCount
                    .toString()
                    .padLeft(2, '0'),
                icon: 'assets/images/ticketnouveau.png',
                color: const Color(0xFF3498DB), // Blue like in image
                backgroundColor: const Color(0xFF3498DB).withOpacity(0.1),
              ),
              _buildStatusCard(
                title: 'Tickets en cours',
                count: ticketController.inProgressTicketsCount
                    .toString()
                    .padLeft(2, '0'),
                icon: 'assets/images/ticketencour.png',
                color: const Color(0xFFF39C12), // Orange like in image
                backgroundColor: const Color(0xFFF39C12).withOpacity(0.1),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String count,
    required String icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            backgroundColor, // Use the background color with opacity instead of white
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
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
                icon,
                width: 32, // Bigger icon size
                height: 32,
                color: color,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.confirmation_number,
                    size: 32,
                    color: color,
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
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTicketsSection() {
    return Consumer<TicketController>(
      builder: (context, ticketController, child) {
        if (ticketController.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Color(0xFF4ECDC4)),
            ),
          );
        }

        final recentTickets = ticketController.tickets.take(2).toList();

        // Show mock tickets like in the original design when no data or few tickets
        if (recentTickets.isEmpty) {
          return Column(
            children: [
              _buildMockTicketContainer(
                title: 'Design NFT landing page shot',
                ticketId: 'Ticket# 2023-CS123',
                date: '13.08.2023',
                time: '10:55',
                status: 'Nouveau',
                priority: 'Urgente',
                description:
                    'Design a simple home pages with clean layout and color based on the guidelin to...',
                isFirst: true,
                statusIcon: _getStatusIcon('Nouveau'),
              ),
              const SizedBox(height: 16),
              _buildMockTicketContainer(
                title: 'Design NFT landing page shot',
                ticketId: 'Ticket# 2023-CS123',
                date: '13.08.2023',
                time: '10:55',
                status: 'Nouveau',
                priority: 'Urgente',
                description:
                    'Design a simple home pages with clean layout and color based on the guidelin to...',
                isFirst: false,
                statusIcon: _getStatusIcon('Nouveau'),
              ),
            ],
          );
        }

        return Column(
          children: [
            ...recentTickets.asMap().entries.map((entry) {
              final index = entry.key;
              final ticket = entry.value;

              return Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: index == recentTickets.length - 1 ? 0 : 16,
                ),
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
                child: _buildTicketItem(
                  title: ticket.title,
                  ticketId: 'Ticket# ${ticket.id}',
                  date:
                      '${ticket.createdAt.day}.${ticket.createdAt.month.toString().padLeft(2, '0')}.${ticket.createdAt.year}',
                  time:
                      '${ticket.createdAt.hour}:${ticket.createdAt.minute.toString().padLeft(2, '0')}',
                  status: _getStatusDisplay(ticket.status),
                  priority: _getPriorityDisplay(ticket.priority),
                  description: ticket.description.length > 100
                      ? '${ticket.description.substring(0, 100)}...'
                      : ticket.description,
                  isFirst: index == 0,
                  statusIcon: _getStatusIcon(_getStatusDisplay(ticket.status)),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildTicketItem({
    required String title,
    required String ticketId,
    required String date,
    required String time,
    required String status,
    /* required Color statusColor, */
    required String priority,
    /* required Color priorityColor, */
    required String description,
    required bool isFirst,
    String? statusIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                      ticketId,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
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
                          size: 8,
                          color: Colors.grey[600],
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
                      '$date / $time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
                          color: const Color(0xFF707070),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      priority,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF707070),
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

  Widget _buildMockTicketContainer({
    required String title,
    required String ticketId,
    required String date,
    required String time,
    required String status,
    required String priority,
    required String description,
    required bool isFirst,
    String? statusIcon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
      child: _buildTicketItem(
        title: title,
        ticketId: ticketId,
        date: date,
        time: time,
        status: status,
        priority: priority,
        description: description,
        isFirst: isFirst,
        statusIcon: statusIcon ?? _getStatusIcon(status),
      ),
    );
  }

  String _getStatusDisplay(dynamic status) {
    final statusStr = status.toString().toLowerCase();
    if (statusStr.contains('open')) return 'Nouveau';
    if (statusStr.contains('progress')) return 'En cours';
    if (statusStr.contains('resolved')) return 'Résolu';
    if (statusStr.contains('closed')) return 'Fermé';
    return 'Nouveau';
  }

  String _getPriorityDisplay(dynamic priority) {
    final priorityStr = priority.toString().toLowerCase();
    if (priorityStr.contains('urgent')) return 'Urgente';
    if (priorityStr.contains('high')) return 'Haute';
    if (priorityStr.contains('medium')) return 'Moyenne';
    if (priorityStr.contains('low')) return 'Basse';
    return 'Moyenne';
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
      return 'assets/images/stickerRejeter.png'; // Rejeter/Fermé
    } else if (statusStr.contains('résolu') || statusStr.contains('resolu')) {
      return 'assets/images/stickerResolu.png'; // Résolu
    }
    return 'assets/images/stickernouveau.png'; // Default
  }
}
