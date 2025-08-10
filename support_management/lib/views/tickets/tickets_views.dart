import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({super.key});

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCreationOption;

  @override
  void initState() {
    super.initState();
    // Load tickets when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketController>(context, listen: false).loadTickets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateTicketModal() {
    setState(() {
      _selectedCreationOption = null;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/ticketresolu.png',
                        width: 24,
                        height: 24,
                        color: const Color(0xFF14B8A6),
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.confirmation_number,
                            size: 24,
                            color: Color(0xFF14B8A6),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Création ticket',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Création simple
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        _selectedCreationOption = 'creation_simple';
                      });
                      Future.delayed(const Duration(milliseconds: 10), () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/main/tickets/create');
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _selectedCreationOption == 'creation_simple'
                            ? const Color(0xFF14B8A6).withOpacity(0.1)
                            : Colors.grey[50],
                        border: _selectedCreationOption == 'creation_simple'
                            ? Border.all(
                                color: const Color(0xFF14B8A6),
                                width: 2,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 24,
                            color: _selectedCreationOption == 'creation_simple'
                                ? const Color(0xFF14B8A6)
                                : Colors.black,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Création simple',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Record Audio option
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        _selectedCreationOption = 'record_audio';
                      });
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Audio recording coming soon!')),
                        );
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _selectedCreationOption == 'record_audio'
                            ? const Color(0xFF14B8A6).withOpacity(0.1)
                            : Colors.grey[50],
                        border: _selectedCreationOption == 'record_audio'
                            ? Border.all(
                                color: const Color(0xFF14B8A6),
                                width: 2,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mic,
                            size: 24,
                            color: _selectedCreationOption == 'record_audio'
                                ? const Color(0xFF14B8A6)
                                : Colors.black,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Record Audio',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Record Video option
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        _selectedCreationOption = 'record_video';
                      });
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Video recording coming soon!')),
                        );
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _selectedCreationOption == 'record_video'
                            ? const Color(0xFF14B8A6).withOpacity(0.1)
                            : Colors.grey[50],
                        border: _selectedCreationOption == 'record_video'
                            ? Border.all(
                                color: const Color(0xFF14B8A6),
                                width: 2,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.videocam,
                            size: 24,
                            color: _selectedCreationOption == 'record_video'
                                ? const Color(0xFF14B8A6)
                                : Colors.black,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Record vidéo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              // Title
              const Text(
                'Tickets',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gérer et suivez tous les tickets de support client',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Search bar and Filter button
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
                          hintText: 'Recherche un ticket, client ou ID',
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

                  // Filter button
                  GestureDetector(
                    onTap: () {
                      // Navigate to tickets filter page
                      Navigator.pushNamed(context, '/main/tickets/filter');
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Add ticket button
        GestureDetector(
          onTap: () {
            _showCreateTicketModal();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Ajouter un nouveau ticket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Tickets List
        Expanded(
          child: Consumer<TicketController>(
            builder: (context, ticketController, child) {
              if (ticketController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4ECDC4)),
                );
              }

              if (ticketController.tickets.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: ticketController.tickets.length,
                itemBuilder: (context, index) {
                  final ticket = ticketController.tickets[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                      statusIcon: _getStatusIcon(ticket.status),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
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

  Widget _buildTicketItem({
    required String title,
    required String ticketId,
    required String date,
    required String time,
    required String status,
    required String priority,
    required String description,
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
              // Status with orange background like home view
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6).withOpacity(1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (statusIcon != null)
                      Image.asset(
                        statusIcon,
                        width: 19,
                        height: 19,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.grey[600],
                          );
                        },
                      )
                    else
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.grey[600],
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

  String? _getStatusIcon(dynamic status) {
    final statusStr = status.toString().toLowerCase();
    if (statusStr.contains('open')) return 'assets/images/stickernouveau.png';
    if (statusStr.contains('progress')) {
      return 'assets/images/stickerOuvert.png';
    }
    if (statusStr.contains('resolved')) {
      return 'assets/images/stickerResolu.png';
    }
    if (statusStr.contains('closed')) return 'assets/images/stickerRejeter.png';
    return 'assets/images/stickernouveau.png';
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
