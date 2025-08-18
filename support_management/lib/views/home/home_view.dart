import '../../models/models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../tickets/audio_record_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';
import '../widgets/widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial data using controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketController>(context, listen: false).loadTickets();
      Provider.of<ClientController>(context, listen: false).loadClients();
      // reset display limit when opening home
      Provider.of<TicketController>(context, listen: false)
          .resetDisplayLimit(2);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        // near bottom -> load more
        Provider.of<TicketController>(context, listen: false)
            .increaseDisplayLimit(10);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        color: const Color(0xFFF6F6F6), // page background #F6F6F6
        child: SingleChildScrollView(
          controller: _scrollController,
          // ensure extra bottom padding to account for device insets / nav bars
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with greeting and notification
                    const HomeHeader(),

                    const SizedBox(height: 20),

                    // Search bar and Add button in same row
                    SearchAndAdd(
                        controller: _searchController,
                        onAdd: _showCreateTicketModal),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Ticket Status Cards
              _buildStatusCardsSection(),

              const SizedBox(height: 30),

              // Recent Tickets List
              _buildRecentTicketsSection(),

              const SizedBox(height: 48), // reduced spacer to avoid overflow
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateTicketModal() {
    String? selectedCreationOption;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModalState) {
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
                        onTap: () => Navigator.of(ctx).pop(),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Creation simple
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        selectedCreationOption = 'creation_simple';
                      });
                      Future.delayed(const Duration(milliseconds: 10), () {
                        Navigator.of(ctx).pop();
                        Navigator.pushNamed(context, '/main/tickets/create');
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: selectedCreationOption == 'creation_simple'
                            ? const Color(0xFF14B8A6).withOpacity(0.1)
                            : Colors.grey[50],
                        border: selectedCreationOption == 'creation_simple'
                            ? Border.all(
                                color: const Color(0xFF14B8A6),
                                width: 2,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.edit,
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text('Création simple'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Record Audio option
                  GestureDetector(
                    onTap: () async {
                      setModalState(() {
                        selectedCreationOption = 'record_audio';
                      });
                      final status = await Permission.microphone.request();
                      if (!status.isGranted) {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Microphone permission required')),
                        );
                        return;
                      }
                      String? audioPath;
                      await showDialog(
                        context: ctx,
                        barrierDismissible: false,
                        builder: (dialogCtx) {
                          return AudioRecordDialog(
                            onRecordingComplete: (path) {
                              audioPath = path;
                            },
                          );
                        },
                      );
                      Navigator.of(ctx).pop();
                      if (audioPath?.isNotEmpty == true) {
                        Navigator.pushNamed(
                          context,
                          '/main/tickets/create/continue',
                          arguments: {
                            'audioPath': audioPath,
                          },
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: selectedCreationOption == 'record_audio'
                            ? const Color(0xFF14B8A6).withOpacity(0.1)
                            : Colors.grey[50],
                        border: selectedCreationOption == 'record_audio'
                            ? Border.all(
                                color: const Color(0xFF14B8A6),
                                width: 2,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.mic, size: 24),
                          SizedBox(width: 16),
                          Text('Enregistrer audio'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Record Video option
                  GestureDetector(
                    onTap: () async {
                      setModalState(() {
                        selectedCreationOption = 'record_video';
                      });
                      final ImagePicker picker = ImagePicker();
                      final XFile? pickedFile =
                          await picker.pickVideo(source: ImageSource.camera);
                      Navigator.of(ctx).pop();
                      if (pickedFile != null) {
                        Navigator.pushNamed(
                          context,
                          '/main/tickets/create/continue',
                          arguments: {
                            'videoPath': pickedFile.path,
                          },
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: selectedCreationOption == 'record_video'
                            ? const Color(0xFF14B8A6).withOpacity(0.1)
                            : Colors.grey[50],
                        border: selectedCreationOption == 'record_video'
                            ? Border.all(
                                color: const Color(0xFF14B8A6),
                                width: 2,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.videocam, size: 24),
                          SizedBox(width: 16),
                          Text('Enregistrer vidéo'),
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

  Widget _buildStatusCardsSection() {
    return Consumer<TicketController>(
      builder: (context, ticketController, child) {
        Widget statusCard(String title, Color color, String icon, int count,
            TicketStatus status) {
          return GestureDetector(
            onTap: () {
              // Filter by status in-place
              ticketController.filterByStatus(status);

              // Reset display limit to the true number of matching tickets (use allTickets)
              final matchCount = ticketController.allTickets
                  .where((t) => t.status == status)
                  .length;
              ticketController
                  .resetDisplayLimit(matchCount > 0 ? matchCount : 2);

              // Scroll to top so user sees filtered results
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: _buildStatusCard(
              title: title,
              count: count.toString().padLeft(2, '0'),
              icon: icon,
              color: color,
              backgroundColor: color.withOpacity(0.03),
            ),
          );
        }

        final statusItems = [
          {
            'title': 'Tickets résolu',
            'color': const Color(0xFF27AE60),
            'icon': 'assets/images/ticketresolu.png',
            'count': ticketController.resolvedTicketsCount,
            'status': TicketStatus.resolved,
          },
          {
            'title': 'Tickets rejeter',
            'color': const Color(0xFFE74C3C),
            'icon': 'assets/images/ticketrejeter.png',
            'count': ticketController.closedTicketsCount,
            'status': TicketStatus.closed,
          },
          {
            'title': 'Nouveau tickets',
            'color': const Color(0xFF3498DB),
            'icon': 'assets/images/ticketnouveau.png',
            'count': ticketController.openTicketsCount,
            'status': TicketStatus.open,
          },
          {
            'title': 'Tickets en cours',
            'color': const Color(0xFFF39C12),
            'icon': 'assets/images/ticketencour.png',
            'count': ticketController.inProgressTicketsCount,
            'status': TicketStatus.inProgress,
          },
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              // enforce approximately 164 px per item (max),
              // and a fixed main axis extent (height) of 82 px
              maxCrossAxisExtent: 164,
              mainAxisExtent: 82,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: statusItems.length,
            itemBuilder: (context, index) {
              final item = statusItems[index];
              return statusCard(
                item['title'] as String,
                item['color'] as Color,
                item['icon'] as String,
                item['count'] as int,
                item['status'] as TicketStatus,
              );
            },
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
    return SizedBox(
      width: 164, // fixed width
      height: 82, // fixed height
      child: Container(
        // reduce vertical padding so the card can fit smaller constraints
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(11.33), // 11.33px radius
          border: Border.all(
            color: color,
            width: 0.81, // 0.81px border
          ),
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
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600, // 600 = SemiBold in Poppins
                fontStyle: FontStyle.normal,
                fontSize: 13,
                height: 1.0, // 100% line-height
                letterSpacing: 0,
                color: Color(0xFF595757),
              ),
            ),
            // use a small gap instead of Spacer to avoid forcing large height
            const SizedBox(height: 6),
            // Bottom row with icon and number next to each other
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon on the left - do NOT apply color so asset keeps its original colors
                Image.asset(
                  icon,
                  width: 28,
                  height: 28,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.confirmation_number,
                      size: 28,
                      color: color,
                    );
                  },
                ),
                const SizedBox(width: 12),
                // Number next to the icon, nudged slightly down for visual alignment
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    count,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      height:
                          32.37 / 15, // line-height in px divided by font size
                      letterSpacing: 0,
                      color: Color(0xFF3A3F51),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
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
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 1, 122, 114)),
            ),
          );
        }

        // Controller already applies displayLimit when filtering, so use tickets directly
        final recentTickets = ticketController.tickets.toList();

        // Show mock tickets like in the original design when no data or few tickets
        if (recentTickets.isEmpty) {
          return Column(
            children: [
              _buildMockTicketContainer(
                title: 'Design NFT landing page shot',
                ticketId: 'Ticket# 2023-CS123',
                date: '13.08.2023',
                time: '10:55',
                status: TicketStatus.open,
                priority: 'Urgente',
                description:
                    'Design a simple home pages with clean layout and color based on the guidelin to...',
                isFirst: true,
                statusIcon: _statusIconFromEnum(TicketStatus.open),
              ),
              const SizedBox(height: 16),
              _buildMockTicketContainer(
                title: 'Design NFT landing page shot',
                ticketId: 'Ticket# 2023-CS123',
                date: '13.08.2023',
                time: '10:55',
                status: TicketStatus.open,
                priority: 'Urgente',
                description:
                    'Design a simple home pages with clean layout and color based on the guidelin to...',
                isFirst: false,
                statusIcon: _statusIconFromEnum(TicketStatus.open),
              ),
            ],
          );
        }

        // Deduplicate tickets by id to avoid rendering duplicates
        final uniqueMap = <String, TicketModel>{};
        for (final t in recentTickets) {
          uniqueMap[t.id] = t;
        }
        final uniqueTickets = uniqueMap.values.toList();

        return Column(
          children: [
            ...uniqueTickets.asMap().entries.map((entry) {
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
                  status: ticket.status,
                  priority: _getPriorityDisplay(ticket.priority),
                  description: ticket.description.length > 100
                      ? '${ticket.description.substring(0, 100)}...'
                      : ticket.description,
                  isFirst: index == 0,
                  statusIcon: _statusIconFromEnum(ticket.status),
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
    required TicketStatus status,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF292A2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticketId,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8F8E92),
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
                    // Use the appropriate status icon and label from enum
                    Image.asset(
                      statusIcon ?? _statusIconFromEnum(status),
                      width: 19,
                      height: 19,
                      color: _statusColorFromEnum(status),
                      colorBlendMode: BlendMode.srcIn,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.circle,
                          size: 8,
                          color: _statusColorFromEnum(status),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _statusLabelFromEnum(status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColorFromEnum(status),
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
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14,
              height: 20 / 14, // line-height in px divided by font size
              letterSpacing: -0.28, // -2% of 14px is -0.28
              color: Color(0xFF8A8F9B),
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
    required TicketStatus status,
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
        statusIcon: statusIcon ?? _statusIconFromEnum(status),
      ),
    );
  }

  // Helpers to map TicketStatus enum to icon, label, and color
  String _statusIconFromEnum(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'assets/images/stickernouveau.png';
      case TicketStatus.inProgress:
        // use stickerEncour for tickets "en cours / ouvert"
        return 'assets/images/stickerEncour.png';
      case TicketStatus.resolved:
        return 'assets/images/StickerResolu.png';
      case TicketStatus.closed:
        return 'assets/images/StickerRejeter.png';
    }
  }

  String _statusLabelFromEnum(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Nouveau';
      case TicketStatus.inProgress:
        return 'En cours';
      case TicketStatus.resolved:
        return 'Résolu';
      case TicketStatus.closed:
        // display as 'Rejeter' per request
        return 'Rejeter';
    }
  }

  Color _statusColorFromEnum(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return const Color(0xFF3498DB);
      case TicketStatus.inProgress:
        // match the status-card color for "Tickets en cours"
        return const Color(0xFFF39C12);
      case TicketStatus.resolved:
        return const Color(0xFF27AE60);
      case TicketStatus.closed:
        return const Color(0xFFE74C3C);
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

  // legacy string-based status icon helper removed — using enum mappings
}
