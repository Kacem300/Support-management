import 'package:flutter/material.dart';

class ClientFilterView extends StatefulWidget {
  const ClientFilterView({super.key});

  @override
  State<ClientFilterView> createState() => _ClientFilterViewState();
}

class _ClientFilterViewState extends State<ClientFilterView> {
  // Filter state variables
  String _selectedStatus = 'Tous';
  String _selectedDateRange = 'Toutes les périodes';
  final List<String> _selectedClients = [];

  // Filter options
  final List<String> _statusOptions = [
    'Tous',
    'Actif',
    'Inactif',
  ];

  final List<String> _dateRangeOptions = [
    'Toutes les périodes',
    'Aujourd\'hui',
    'Cette semaine',
    'Ce mois',
    'Ce trimestre',
    'Cette année',
  ];

  final List<String> _clientOptions = [
    'Kacem BenBrahim',
    'Ahmed Mahmoudi',
    'Sarah Johnson',
    'Mike Thompson',
    'Lisa Anderson',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filtres',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'Réinitialiser',
              style: TextStyle(
                color: Color(0xFF4ECDC4),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
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
                  // Status Section
                  _buildStatusSection(),

                  const SizedBox(height: 32),

                  // Date Range Section
                  _buildDateRangeSection(),

                  const SizedBox(height: 32),

                  // Clients Section
                  _buildClientsSection(),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statut du client',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _statusOptions.map((status) {
            final isSelected = _selectedStatus == status;
            return _buildChip(
              status,
              isSelected,
              () {
                setState(() {
                  _selectedStatus = status;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Période d\'inscription',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _dateRangeOptions.map((dateRange) {
            final isSelected = _selectedDateRange == dateRange;
            return _buildChip(
              dateRange,
              isSelected,
              () {
                setState(() {
                  _selectedDateRange = dateRange;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildClientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clients spécifiques',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _clientOptions.map((client) {
            final isSelected = _selectedClients.contains(client);
            return _buildChip(
              client,
              isSelected,
              () {
                setState(() {
                  if (isSelected) {
                    _selectedClients.remove(client);
                  } else {
                    _selectedClients.add(client);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Apply Filters Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ECDC4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Appliquer les filtres',
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

  void _resetFilters() {
    setState(() {
      _selectedStatus = 'Tous';
      _selectedDateRange = 'Toutes les périodes';
      _selectedClients.clear();
    });
  }

  void _applyFilters() {
    // Create filter results
    final filterResults = {
      'status': _selectedStatus,
      'dateRange': _selectedDateRange,
      'clients': _selectedClients,
    };

    // Return results to previous screen
    Navigator.pop(context, filterResults);
  }
}
