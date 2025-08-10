import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';

class TicketsFilterView extends StatefulWidget {
  const TicketsFilterView({super.key});

  @override
  State<TicketsFilterView> createState() => _TicketsFilterViewState();
}

class _TicketsFilterViewState extends State<TicketsFilterView> {
  // Filter state variables
  Set<String> selectedStatuses = {};
  Set<String> selectedPriorities = {};
  Set<String> selectedTypes = {};
  Set<String> selectedCreatedBy = {};
  Set<String> selectedClients = {};
  Set<String> selectedAssignees = {};
  DateTimeRange? selectedDateRange;

  // Calendar state variables
  DateTime currentMonth = DateTime(2025, 12, 1); // December 2025
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool isSelectingEndDate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Filtrage',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrioritySection(),
                  const SizedBox(height: 24),
                  _buildStatusSection(),
                  const SizedBox(height: 24),
                  _buildTypeSection(),
                  const SizedBox(height: 24),
                  _buildCreatedBySection(),
                  const SizedBox(height: 24),
                  _buildClientSection(),
                  const SizedBox(height: 24),
                  _buildAssigneeSection(),
                  const SizedBox(height: 24),
                  _buildDateSection(),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priorité',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildPriorityChip(
                'Urgente', const Color(0xFFE74C3C), 'assets/images/flag.png'),
            _buildPriorityChip('Haute', const Color(0xFFF39C12),
                'assets/images/flagHaute.png'),
            _buildPriorityChip('Moyenne', const Color(0xFFF1C40F),
                'assets/images/flagMoyenne.png'),
            _buildPriorityChip('Basse', const Color(0xFF3498DB),
                'assets/images/flagBasse.png'),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(String priority, Color color, String iconPath) {
    final isSelected = selectedPriorities.contains(priority);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedPriorities.remove(priority);
          } else {
            selectedPriorities.add(priority);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: color, width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: 16,
              height: 16,
              color: color,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.flag,
                  size: 16,
                  color: color,
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              priority,
              style: TextStyle(
                color: isSelected ? color : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statut de ticket',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildStatusChip('Nouveau', const Color(0xFF3498DB),
                'assets/images/stickernouveau.png'),
            _buildStatusChip('En cours', const Color(0xFFF39C12),
                'assets/images/stickerEncour.png'),
            _buildStatusChip('Résolu', const Color(0xFF4ECDC4),
                'assets/images/StickerResolu.png'),
            _buildStatusChip('Fermé', const Color(0xFFE74C3C),
                'assets/images/StickerRejeter.png'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status, Color color, String iconPath) {
    final isSelected = selectedStatuses.contains(status);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedStatuses.remove(status);
          } else {
            selectedStatuses.add(status);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: color, width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: 16,
              height: 16,
              color: color,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.circle,
                  size: 16,
                  color: color,
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              status,
              style: TextStyle(
                color: isSelected ? color : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type de ticket',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildTypeChip('Technique'),
            _buildTypeChip('Facturation'),
            _buildTypeChip('Support'),
            _buildTypeChip('Demande d\'information'),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type) {
    final isSelected = selectedTypes.contains(type);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedTypes.remove(type);
          } else {
            selectedTypes.add(type);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4ECDC4).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? const Border.fromBorderSide(
                  BorderSide(color: Color(0xFF4ECDC4), width: 1))
              : null,
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCreatedBySection() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Créé par',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildCreatedByChip('Moi'),
                _buildCreatedByChip('Équipe support'),
                _buildCreatedByChip('Client'),
                _buildCreatedByChip('Système'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCreatedByChip(String createdBy) {
    final isSelected = selectedCreatedBy.contains(createdBy);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCreatedBy.remove(createdBy);
          } else {
            selectedCreatedBy.add(createdBy);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4ECDC4).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? const Border.fromBorderSide(
                  BorderSide(color: Color(0xFF4ECDC4), width: 1))
              : null,
        ),
        child: Text(
          createdBy,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildClientSection() {
    return Consumer<ClientController>(
      builder: (context, clientController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Client',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: clientController.clients.take(6).map((client) {
                return _buildClientChip(client.name);
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClientChip(String client) {
    final isSelected = selectedClients.contains(client);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedClients.remove(client);
          } else {
            selectedClients.add(client);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4ECDC4).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? const Border.fromBorderSide(
                  BorderSide(color: Color(0xFF4ECDC4), width: 1))
              : null,
        ),
        child: Text(
          client,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAssigneeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assigné à',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildAssigneeChip('Moi'),
            _buildAssigneeChip('Hamdi ben hbhb'),
            _buildAssigneeChip('Sarah Martin'),
            _buildAssigneeChip('Non assigné'),
          ],
        ),
      ],
    );
  }

  Widget _buildAssigneeChip(String assignee) {
    final isSelected = selectedAssignees.contains(assignee);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedAssignees.remove(assignee);
          } else {
            selectedAssignees.add(assignee);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4ECDC4).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? const Border.fromBorderSide(
                  BorderSide(color: Color(0xFF4ECDC4), width: 1))
              : null,
        ),
        child: Text(
          assignee,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date de création',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildCalendar(),
              if (selectedStartDate != null || selectedEndDate != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedStartDate != null
                              ? const Color(0xFF4ECDC4).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedStartDate != null
                                ? const Color(0xFF4ECDC4)
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          selectedStartDate != null
                              ? '${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}'
                              : 'Date début',
                          style: TextStyle(
                            color: selectedStartDate != null
                                ? const Color(0xFF4ECDC4)
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedEndDate != null
                              ? const Color(0xFF4ECDC4).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedEndDate != null
                                ? const Color(0xFF4ECDC4)
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          selectedEndDate != null
                              ? '${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}'
                              : 'Date fin',
                          style: TextStyle(
                            color: selectedEndDate != null
                                ? const Color(0xFF4ECDC4)
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayWeekday =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday;

    return Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  currentMonth =
                      DateTime(currentMonth.year, currentMonth.month - 1);
                });
              },
            ),
            Text(
              '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  currentMonth =
                      DateTime(currentMonth.year, currentMonth.month + 1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Weekdays header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
              .map((day) => SizedBox(
                    width: 32,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar grid
        ...List.generate(6, (weekIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (dayIndex) {
              final dayNumber =
                  weekIndex * 7 + dayIndex + 1 - (firstDayWeekday - 1);

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox(width: 32, height: 32);
              }

              final date =
                  DateTime(currentMonth.year, currentMonth.month, dayNumber);
              final isStartDate = selectedStartDate != null &&
                  selectedStartDate!.year == date.year &&
                  selectedStartDate!.month == date.month &&
                  selectedStartDate!.day == date.day;
              final isEndDate = selectedEndDate != null &&
                  selectedEndDate!.year == date.year &&
                  selectedEndDate!.month == date.month &&
                  selectedEndDate!.day == date.day;
              final isInRange = selectedStartDate != null &&
                  selectedEndDate != null &&
                  date.isAfter(selectedStartDate!) &&
                  date.isBefore(selectedEndDate!);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedStartDate == null ||
                        (selectedStartDate != null &&
                            selectedEndDate != null)) {
                      // Start new selection
                      selectedStartDate = date;
                      selectedEndDate = null;
                      isSelectingEndDate = true;
                    } else if (isSelectingEndDate) {
                      // Set end date
                      if (date.isAfter(selectedStartDate!)) {
                        selectedEndDate = date;
                      } else {
                        selectedStartDate = date;
                      }
                      isSelectingEndDate = false;
                    }
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isStartDate || isEndDate
                        ? const Color(0xFF4ECDC4)
                        : isInRange
                            ? const Color(0xFF4ECDC4).withOpacity(0.3)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      dayNumber.toString(),
                      style: TextStyle(
                        color: isStartDate || isEndDate
                            ? Colors.white
                            : Colors.black,
                        fontWeight: isStartDate || isEndDate
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        })
            .where(
                (row) => row.children.any((child) => child is GestureDetector))
            ,
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return months[month];
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Navigate back without applying filters
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.grey[100],
                ),
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Appliquer',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() {
    // Apply filters using the TicketController
    final ticketController =
        Provider.of<TicketController>(context, listen: false);

    // Convert selected filters to enum types if needed
    TicketStatus? statusFilter;
    if (selectedStatuses.isNotEmpty) {
      final statusString = selectedStatuses.first;
      if (statusString == 'Nouveau') statusFilter = TicketStatus.open;
      if (statusString == 'En cours') statusFilter = TicketStatus.inProgress;
      if (statusString == 'Résolu') statusFilter = TicketStatus.resolved;
      if (statusString == 'Fermé') statusFilter = TicketStatus.closed;
    }

    TicketPriority? priorityFilter;
    if (selectedPriorities.isNotEmpty) {
      final priorityString = selectedPriorities.first;
      if (priorityString == 'Urgente') priorityFilter = TicketPriority.urgent;
      if (priorityString == 'Haute') priorityFilter = TicketPriority.high;
      if (priorityString == 'Moyenne') priorityFilter = TicketPriority.medium;
      if (priorityString == 'Basse') priorityFilter = TicketPriority.low;
    }

    String? clientFilter;
    if (selectedClients.isNotEmpty) {
      clientFilter = selectedClients.first;
    }

    // Apply filters to controller using individual methods
    if (statusFilter != null) {
      ticketController.filterByStatus(statusFilter);
    }

    if (priorityFilter != null) {
      ticketController.filterByPriority(priorityFilter);
    }

    if (clientFilter != null) {
      ticketController.filterByClient(clientFilter);
    }

    // Return to home view with filters applied
    Navigator.of(context).pop();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Filtres appliqués (${_getAppliedFiltersCount()} actifs)'),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
    );
  }

  int _getAppliedFiltersCount() {
    int count = 0;
    if (selectedStatuses.isNotEmpty) count++;
    if (selectedPriorities.isNotEmpty) count++;
    if (selectedTypes.isNotEmpty) count++;
    if (selectedCreatedBy.isNotEmpty) count++;
    if (selectedClients.isNotEmpty) count++;
    if (selectedAssignees.isNotEmpty) count++;
    if (selectedStartDate != null || selectedEndDate != null) count++;
    return count;
  }
}
