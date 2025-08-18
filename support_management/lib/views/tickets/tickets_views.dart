import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({super.key});

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ticketController =
          Provider.of<TicketController>(context, listen: false);
      // Ensure we show unfiltered tickets when opening the Tickets page.
      // Clear any filters/search that may have been applied from Home.
      ticketController.clearFilters();
      // Clear the search input UI as well so it matches controller state.
      _searchController.clear();

      if (ticketController.allTickets.isEmpty) ticketController.loadTickets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFF6F6F6),
        child: Column(
          children: [
            // Header
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
                  const Text(
                    'Tickets',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Gérer et suivez tous les tickets de support client',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),

                  // Search + Add
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Rechercher',
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (v) =>
                                      Provider.of<TicketController>(context,
                                              listen: false)
                                          .searchTickets(v),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // open filter sheet if available
                                  Navigator.of(context).pushNamed('/filters');
                                },
                                icon:
                                    const Icon(Icons.tune, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/main/tickets/create'),
                        child: Container(
                          height: 44,
                          // reduced horizontal padding to make the button narrower
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.add, color: Colors.white, size: 18),
                              SizedBox(width: 2),
                              Text(
                                'Nouveau',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
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

            const SizedBox(height: 20),

            // Tickets list
            Expanded(
              child: Consumer<TicketController>(
                builder: (context, ticketController, child) {
                  if (ticketController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tickets = ticketController.tickets;
                  if (tickets.isEmpty) return _buildEmptyState();

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: tickets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final t = tickets[index];
                      return _buildTicketCard(t);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun ticket trouvé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre premier ticket de support',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(TicketModel t) {
    final statusColor = _statusColorFromEnum(t.status);
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // compact left spacing (no large sticker)
              const SizedBox(width: 8),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ticket# ${t.id}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF707070)),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        _statusIconFromEnum(t.status),
                        fit: BoxFit.contain,
                        // Tint the asset to match the status color. This works well for monochrome/png assets.
                        color: statusColor,
                        colorBlendMode: BlendMode.srcIn,
                        errorBuilder: (c, e, s) => Icon(
                          Icons.circle,
                          size: 10,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _statusLabelFromEnum(t.status),
                      style: TextStyle(
                          color: statusColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                        '${_formatDate(t.createdAt)} / ${_formatTime(t.createdAt)}',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      _getPriorityIcon(_getPriorityDisplay(t.priority.name)),
                      width: 16,
                      height: 16,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.flag, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(_getPriorityDisplay(t.priority.name),
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t.description,
            style:
                TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // Map TicketStatus enum to display label
  String _statusLabelFromEnum(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Nouveau';
      case TicketStatus.inProgress:
        return 'En cours';
      case TicketStatus.resolved:
        return 'Résolu';
      case TicketStatus.closed:
        return 'Rejeter';
    }
  }

  String _getPriorityDisplay(dynamic priority) {
    final priorityStr = priority.toString().toLowerCase();
    if (priorityStr.contains('urgent')) return 'Urgente';
    if (priorityStr.contains('high')) return 'Haute';
    if (priorityStr.contains('medium')) return 'Moyenne';
    if (priorityStr.contains('low')) return 'Basse';
    return 'Moyenne';
  }

  // Map enum to icon path
  String _statusIconFromEnum(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'assets/images/stickernouveau.png';
      case TicketStatus.inProgress:
        return 'assets/images/stickerEncour.png';
      case TicketStatus.resolved:
        return 'assets/images/StickerResolu.png';
      case TicketStatus.closed:
        return 'assets/images/StickerRejeter.png';
    }
  }

  Color _statusColorFromEnum(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return const Color(0xFF3498DB);
      case TicketStatus.inProgress:
        return const Color(0xFFF39C12);
      case TicketStatus.resolved:
        return const Color(0xFF27AE60);
      case TicketStatus.closed:
        return const Color(0xFFE74C3C);
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
}
