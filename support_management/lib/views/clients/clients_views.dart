import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/client_controller.dart';
import '../../models/client_model.dart';
import 'client_filter_view.dart';
import 'client_details_view.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load clients when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      body: Consumer<ClientController>(
        builder: (context, clientController, child) {
          if (clientController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4ECDC4),
              ),
            );
          }

          if (clientController.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur lors du chargement des clients',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    clientController.error!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => clientController.loadClients(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                    ),
                    child: const Text(
                      'Réessayer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
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
                          onChanged: (query) {
                            clientController.searchClients(query);
                          },
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
                    GestureDetector(
                      onTap: () async {
                        // Navigate to client filter
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ClientFilterView(),
                          ),
                        );

                        // Handle filter results
                        if (result != null) {
                          print('Applied client filters: $result');
                          // TODO: Apply filters to client list using controller
                        }
                      },
                      child: Container(
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
                    ),
                  ],
                ),
              ),
              // Clients list
              Expanded(
                child: clientController.clients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun client trouvé',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: clientController.clients.length,
                        itemBuilder: (context, index) {
                          final client = clientController.clients[index];
                          return _buildClientCard(client);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildClientCard(ClientModel client) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientDetailsView(
              clientId: client.id,
              clientName: client.name,
              joinDate: 'Client depuis ${client.joinDate.year}',
              isActive: client.isActive,
              ticketsInProgress: client.ticketsInProgress,
              ticketsResolved: client.ticketsResolved,
              avatar: client.avatar ?? 'assets/images/profile.png',
            ),
          ),
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
                      backgroundImage: AssetImage(
                          client.avatar ?? 'assets/images/profile.png'),
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
                        'Client depuis ${client.joinDate.year}',
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
            const SizedBox(height: 5),
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 0),

            // Tickets statistics
            Row(
              children: [
                Expanded(
                  child: _buildTicketStat(
                    'Ticket en cours',
                    client.ticketsInProgress.toString(),
                    'assets/images/clientIcon1.png',
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
                    'assets/images/clientIcon2.png',
                    const Color(0xFF00B341),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon on the left
          SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Image.asset(
                iconPath,
                width: 32,
                height: 32,
                color: color,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    title.contains('cours')
                        ? Icons.access_time
                        : Icons.check_circle,
                    size: 32,
                    color: color,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Texts stacked vertically, aligned left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count TICKETS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
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
