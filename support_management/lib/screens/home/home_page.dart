import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    Row(
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
                            const Text(
                              'Hamdi ben hbhb',
                              style: TextStyle(
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
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Search bar and Add button in same row
                    Row(
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
                                    /* color: Colors.grey[400], */
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
                                    Navigator.pushNamed(
                                        context, '/main/home/filter');
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
                        Container(
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
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Ticket Status Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildStatusCard(
                      title: 'Tickets résolu',
                      count: '03',
                      icon: 'assets/images/ticketresolu.png',
                      color: const Color(0xFF4ECDC4),
                      backgroundColor: const Color(0xFF4ECDC4).withOpacity(0.1),
                    ),
                    _buildStatusCard(
                      title: 'Tickets rjeter',
                      count: '03',
                      icon: 'assets/images/ticketrejeter.png',
                      color: const Color(0xFFE74C3C),
                      backgroundColor: const Color(0xFFE74C3C).withOpacity(0.1),
                    ),
                    _buildStatusCard(
                      title: 'Nouveau tickets',
                      count: '08',
                      icon: 'assets/images/ticketnouveau.png',
                      color: const Color(0xFF3498DB),
                      backgroundColor: const Color(0xFF3498DB).withOpacity(0.1),
                    ),
                    _buildStatusCard(
                      title: 'Tickets en cours',
                      count: '03',
                      icon: 'assets/images/ticketencour.png',
                      color: const Color(0xFFF39C12),
                      backgroundColor: const Color(0xFFF39C12).withOpacity(0.1),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Tickets List
              Column(
                children: [
                  // First ticket item
                  Container(
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
                      title: 'Design NFT landing page shot',
                      ticketId: 'Ticket# 2023-CS123',
                      date: '13.08.2023',
                      time: '10:55',
                      status: 'Nouveau',
                      statusColor: const Color(0xFFF39C12),
                      priority: 'Urgente',
                      priorityColor: const Color(0xFFE74C3C),
                      description:
                          'Design a simple home pages with clean layout and color based on the guidelin to...',
                      isFirst: true,
                      statusIcon: 'assets/images/stickernouveau.png',
                    ),
                  ),

                  const SizedBox(height: 16), // Space between ticket items

                  // Second ticket item
                  Container(
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
                      title: 'Design NFT landing page shot',
                      ticketId: 'Ticket# 2023-CS123',
                      date: '13.08.2023',
                      time: '10:55',
                      status: 'Nouveau',
                      statusColor: const Color(0xFFF39C12),
                      priority: 'Urgente',
                      priorityColor: const Color(0xFFE74C3C),
                      description:
                          'Design a simple home pages with clean layout and color based on the guidelin to...',
                      isFirst: false,
                      statusIcon: 'assets/images/stickernouveau.png',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  icon,
                  width: 24,
                  height: 24,
                  color: color,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.confirmation_number,
                      size: 24,
                      color: color,
                    );
                  },
                ),
              ),
              const Spacer(),
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketItem({
    required String title,
    required String ticketId,
    required String date,
    required String time,
    required String status,
    required Color statusColor,
    required String priority,
    required Color priorityColor,
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
                        fontSize: 12,
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
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (statusIcon != null)
                      Image.asset(
                        statusIcon,
                        width: 12,
                        height: 12,
                        color: statusColor,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
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
              const SizedBox(width: 16),
              Image.asset(
                'assets/images/flag.png',
                width: 16,
                height: 16,
                color: priorityColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.flag,
                    size: 16,
                    color: priorityColor,
                  );
                },
              ),
              const SizedBox(width: 4),
              Text(
                priority,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: priorityColor,
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
}
