import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/client_controller.dart';
import '../../models/client_model.dart';
import 'client_filter_view.dart';
import 'client_details_view.dart'; // Import the ClientDetailsView

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
                              child: Opacity(
                                opacity: 1,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: Image.asset(
                                    'assets/images/Search.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.search,
                                        color: Colors.grey[400],
                                        size: 24,
                                      );
                                    },
                                  ),
                                ),
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClientDetailsView(
              clientId: client.id, // Pass the client ID
              clientName: client.name, // Pass the client name
              joinDate: client.joinDate
                  .toIso8601String(), // Convert DateTime to String
              isActive: client.isActive, // Pass the active status
              ticketsInProgress:
                  client.ticketsInProgress, // Pass tickets in progress
              ticketsResolved: client.ticketsResolved, // Pass resolved tickets
              avatar: client.avatar ??
                  'assets/images/default_avatar.png', // Provide default value if null
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000), // 8% opacity black
              blurRadius: 8, // Reduced from 20
              offset: Offset(0, 2), // Reduced offset
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
            const SizedBox(height: 10),
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildTicketStat(
                      'Ticket en cours',
                      client.ticketsInProgress.toString(),
                      'assets/images/clientIcon1.png',
                      const Color(0xFFFF9500),
                    ),
                  ),
                ),
                // Vertical divider
                Container(
                  height: 70,
                  width: 2,
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: _buildTicketStat(
                      'Ticket résolu',
                      client.ticketsResolved.toString(),
                      'assets/images/clientIcon2.png',
                      const Color(0xFF00B341),
                    ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    double iconBox = screenWidth * 0.15;
    double iconSize = screenWidth * 0.11;
    double fontSizeTitle =
        screenWidth < 350 ? 9 : (screenWidth < 400 ? 10 : 12);
    double fontSizeCount =
        screenWidth < 350 ? 10 : (screenWidth < 400 ? 11 : 13);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Responsive Icon on the left
          SizedBox(
            width: iconBox,
            height: iconBox,
            child: Center(
              child: Image.asset(
                iconPath,
                width: iconSize,
                height: iconSize,
                color: color,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    title.contains('cours')
                        ? Icons.access_time
                        : Icons.check_circle,
                    size: iconSize,
                    color: color,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 0),
          // Texts stacked vertically, aligned left, both forced to single line
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$count TICKETS',
                  style: TextStyle(
                    fontSize: fontSizeCount,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
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
}
