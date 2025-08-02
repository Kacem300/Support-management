import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
            _buildStatusChip('Nouveau', const Color(0xFFF39C12),
                'assets/images/stickernouveau.png'),
            _buildStatusChip(
                'Ouvert', Colors.grey[600]!, 'assets/images/stickerOuvert.png'),
            _buildStatusChip('En cours', const Color(0xFF3498DB),
                'assets/images/stickerEncour.png'),
            _buildStatusChip('Résolu', const Color(0xFF27AE60),
                'assets/images/StickerResolu.png'),
            _buildStatusChip('Rejeter', const Color(0xFFE74C3C),
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
                return Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
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
            _buildTypeChip('Design'),
            _buildTypeChip('Technical'),
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
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.blue, width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTypes.remove(type);
                });
              },
              child: Icon(
                Icons.close,
                size: 16,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatedBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Créer par qui',
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
            _buildUserChip('BU', 'Buhgalter'),
            _buildUserChip('BU', 'Buhgalter'),
          ],
        ),
      ],
    );
  }

  Widget _buildClientSection() {
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
        _buildEmailChip('javiero19@hotmail.com'),
      ],
    );
  }

  Widget _buildAssigneeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assignée',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        _buildEmailChip('javiero19@hotmail.com'),
      ],
    );
  }

  Widget _buildUserChip(String initials, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // Handle remove user
            },
            child: Icon(
              Icons.close,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailChip(String email) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            email,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // Handle remove email
            },
            child: Icon(
              Icons.close,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Calendar header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        currentMonth = DateTime(
                            currentMonth.year, currentMonth.month - 1, 1);
                      });
                    },
                  ),
                  Text(
                    _getMonthYearString(currentMonth),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        currentMonth = DateTime(
                            currentMonth.year, currentMonth.month + 1, 1);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Week headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text('M',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text('T',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text('W',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text('T',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text('F',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text('S',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text('S',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              // Calendar grid
              _buildCalendarGrid(),
              const SizedBox(height: 16),
              // Selected date range display
              if (selectedStartDate != null || selectedEndDate != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getSelectedDateRangeText(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStartDate = null;
                            selectedEndDate = null;
                            isSelectingEndDate = false;
                            selectedDateRange = null;
                          });
                        },
                        child: Icon(Icons.close,
                            color: Colors.grey[600], size: 16),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday; // Monday = 1, Sunday = 7

    // Calculate how many empty cells we need at the beginning
    final emptyCellsAtStart = firstWeekday - 1;

    // Calculate previous month days to show
    final previousMonth =
        DateTime(currentMonth.year, currentMonth.month - 1, 1);
    final daysInPreviousMonth =
        DateTime(previousMonth.year, previousMonth.month + 1, 0).day;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 weeks * 7 days
      itemBuilder: (context, index) {
        DateTime cellDate;
        bool isCurrentMonth = false;
        bool isToday = false;

        if (index < emptyCellsAtStart) {
          // Previous month days
          final day = daysInPreviousMonth - (emptyCellsAtStart - index - 1);
          cellDate = DateTime(previousMonth.year, previousMonth.month, day);
        } else if (index < emptyCellsAtStart + daysInMonth) {
          // Current month days
          final day = index - emptyCellsAtStart + 1;
          cellDate = DateTime(currentMonth.year, currentMonth.month, day);
          isCurrentMonth = true;

          // Check if it's today
          final today = DateTime.now();
          isToday = cellDate.year == today.year &&
              cellDate.month == today.month &&
              cellDate.day == today.day;
        } else {
          // Next month days
          final day = index - emptyCellsAtStart - daysInMonth + 1;
          final nextMonth =
              DateTime(currentMonth.year, currentMonth.month + 1, 1);
          cellDate = DateTime(nextMonth.year, nextMonth.month, day);
        }

        final isSelected = _isDateSelected(cellDate);
        final isInRange = _isDateInRange(cellDate);

        return GestureDetector(
          onTap: isCurrentMonth ? () => _handleDateTap(cellDate) : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.teal
                  : isInRange
                      ? Colors.teal.withOpacity(0.3)
                      : isToday
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday ? Border.all(color: Colors.blue, width: 1) : null,
            ),
            child: Center(
              child: Text(
                '${cellDate.day}',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isCurrentMonth
                          ? Colors.black
                          : Colors.grey[400],
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleDateTap(DateTime date) {
    setState(() {
      if (selectedStartDate == null ||
          (selectedStartDate != null && selectedEndDate != null)) {
        // Start new selection
        selectedStartDate = date;
        selectedEndDate = null;
        isSelectingEndDate = true;
      } else if (isSelectingEndDate) {
        // Select end date
        if (date.isBefore(selectedStartDate!)) {
          // If selected date is before start date, swap them
          selectedEndDate = selectedStartDate;
          selectedStartDate = date;
        } else {
          selectedEndDate = date;
        }
        isSelectingEndDate = false;

        // Update the DateTimeRange
        selectedDateRange =
            DateTimeRange(start: selectedStartDate!, end: selectedEndDate!);
      }
    });
  }

  bool _isDateSelected(DateTime date) {
    return (selectedStartDate != null &&
            _isSameDay(date, selectedStartDate!)) ||
        (selectedEndDate != null && _isSameDay(date, selectedEndDate!));
  }

  bool _isDateInRange(DateTime date) {
    if (selectedStartDate == null || selectedEndDate == null) return false;
    return date.isAfter(selectedStartDate!) && date.isBefore(selectedEndDate!);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getSelectedDateRangeText() {
    if (selectedStartDate == null && selectedEndDate == null) return '';

    if (selectedStartDate != null && selectedEndDate == null) {
      return 'Start: ${_formatDate(selectedStartDate!)}';
    }

    if (selectedStartDate != null && selectedEndDate != null) {
      return '${_formatDate(selectedStartDate!)} - ${_formatDate(selectedEndDate!)}';
    }

    return '';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Clear all filters
                setState(() {
                  selectedStatuses.clear();
                  selectedPriorities.clear();
                  selectedTypes.clear();
                  selectedCreatedBy.clear();
                  selectedClients.clear();
                  selectedAssignees.clear();
                  selectedDateRange = null;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: const Text(
                'Annuler',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Apply filters and return to previous page
                Navigator.of(context).pop({
                  'statuses': selectedStatuses.toList(),
                  'priorities': selectedPriorities.toList(),
                  'types': selectedTypes.toList(),
                  'createdBy': selectedCreatedBy.toList(),
                  'clients': selectedClients.toList(),
                  'assignees': selectedAssignees.toList(),
                  'dateRange': selectedDateRange,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Appliquer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
