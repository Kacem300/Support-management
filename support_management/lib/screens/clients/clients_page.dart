import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Client> _filteredClients = [];
  List<Client> _allClients = [];

  @override
  void initState() {
    super.initState();
    _initializeClients();
    _filteredClients = _allClients;
  }

  void _initializeClients() {
    _allClients = [
      Client(
        id: 'CL001',
        name: 'Kacem BenBrahim',
        joinDate: 'Client depuis 2025',
        isActive: true,
        ticketsInProgress: 3,
        ticketsResolved: 3,
        avatar: 'assets/images/profile.png',
      ),
      Client(
        id: 'CL002',
        name: 'Kacem Ben Brahim',
        joinDate: 'Client depuis 2023',
        isActive: true,
        ticketsInProgress: 12,
        ticketsResolved: 34,
        avatar: 'assets/images/profile.png',
      ),
      Client(
        id: 'CL003',
        name: 'Kacem Ben Brahim',
        joinDate: 'Client depuis 2023',
        isActive: true,
        ticketsInProgress: 12,
        ticketsResolved: 34,
        avatar: 'assets/images/profile.png',
      ),
      Client(
        id: 'CL004',
        name: 'Kacem Ben Brahim',
        joinDate: 'Client depuis 2023',
        isActive: true,
        ticketsInProgress: 12,
        ticketsResolved: 34,
        avatar: 'assets/images/profile.png',
      ),
    ];
  }

  void _filterClients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClients = _allClients;
      } else {
        _filteredClients = _allClients
            .where((client) =>
                client.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Nos clients',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE9ECEF),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterClients,
                      decoration: InputDecoration(
                        hintText: 'Recherche client',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/images/Search.png',
                            width: 20,
                            height: 20,
                            color: Colors.grey[400],
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
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE9ECEF),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          // Clients list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _filteredClients.length,
              itemBuilder: (context, index) {
                final client = _filteredClients[index];
                return _buildClientCard(client);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(Client client) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/main/clients/details',
          arguments: {
            'clientId': client.id,
            'clientName': client.name,
            'joinDate': client.joinDate,
            'isActive': client.isActive,
            'ticketsInProgress': client.ticketsInProgress,
            'ticketsResolved': client.ticketsResolved,
            'avatar': client.avatar,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client info row
            Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(client.avatar),
                      backgroundColor: Colors.grey[300],
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: client.avatar.isEmpty
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
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D68F),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Client details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        client.joinDate,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Active status positioned under the date
                      if (client.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4F7DC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              color: Color(0xFF00B341),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Divider line
            const SizedBox(height: 20),
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            // Tickets statistics
            Row(
              children: [
                Expanded(
                  child: _buildTicketStat(
                    'Ticket en cours',
                    client.ticketsInProgress.toString(),
                    'assets/images/ticketencour.png',
                    const Color(0xFFFF9500),
                  ),
                ),
                // Vertical divider
                Container(
                  height: 60,
                  width: 2,
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: _buildTicketStat(
                    'Ticket résolu',
                    client.ticketsResolved.toString(),
                    'assets/images/ticketresolu.png',
                    const Color(0xFF00D68F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketStat(
      String title, String count, String iconPath, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    color: color,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        title.contains('cours')
                            ? Icons.access_time
                            : Icons.check_circle,
                        size: 20,
                        color: color,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$count TICKETS',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class Client {
  final String id;
  final String name;
  final String joinDate;
  final bool isActive;
  final int ticketsInProgress;
  final int ticketsResolved;
  final String avatar;

  Client({
    required this.id,
    required this.name,
    required this.joinDate,
    required this.isActive,
    required this.ticketsInProgress,
    required this.ticketsResolved,
    required this.avatar,
  });
}
