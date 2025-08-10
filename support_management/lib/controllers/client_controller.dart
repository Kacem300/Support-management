import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../models/ticket_model.dart';
import '../services/client_service.dart';

class ClientController extends ChangeNotifier {
  final ClientService _clientService = ClientServiceImpl();

  List<ClientModel> _clients = [];
  List<ClientModel> _filteredClients = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  bool? _isActiveFilter;

  // Getters
  List<ClientModel> get clients => _filteredClients;
  List<ClientModel> get allClients => _clients;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  bool? get isActiveFilter => _isActiveFilter;

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setClients(List<ClientModel> clients) {
    _clients = clients;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredClients = _clients.where((client) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = client.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            client.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (client.company
                    ?.toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ??
                false);
        if (!matchesSearch) return false;
      }

      // Active status filter
      if (_isActiveFilter != null && client.isActive != _isActiveFilter) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  // Public methods
  Future<void> loadClients({bool refresh = false}) async {
    try {
      if (refresh || _clients.isEmpty) {
        _setLoading(true);
        _setError(null);

        final clients = await _clientService.getClients();
        _setClients(clients);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<ClientModel?> getClientById(String id) async {
    try {
      return await _clientService.getClientById(id);
    } catch (e) {
      print('Error fetching client $id: $e');
      return null;
    }
  }

  Future<List<TicketModel>> getClientTickets(String clientId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TicketModel(
        id: '1',
        title: 'Design NFT landing page shot',
        description:
            'Design a simple home pages with clean layout and color based on the guideline to...',
        clientId: clientId,
        clientName: 'Alice Johnson',
        status: TicketStatus.open,
        priority: TicketPriority.urgent,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        assignedTo: 'Support Team',
        tags: ['design', 'ui/ux'],
      ),
      TicketModel(
        id: '2',
        title: 'Login Issue Resolution',
        description:
            'Client unable to access account due to authentication problems...',
        clientId: clientId,
        clientName: 'Alice Johnson',
        status: TicketStatus.inProgress,
        priority: TicketPriority.high,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        assignedTo: 'Tech Support',
        tags: ['auth', 'bug'],
      ),
      TicketModel(
        id: '3',
        title: 'Feature Request Implementation',
        description:
            'Implementation of new dashboard features as requested by client...',
        clientId: clientId,
        clientName: 'Alice Johnson',
        status: TicketStatus.resolved,
        priority: TicketPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        resolvedAt: DateTime.now().subtract(const Duration(days: 1)),
        assignedTo: 'Development Team',
        tags: ['feature', 'enhancement'],
      ),
      TicketModel(
        id: '4',
        title: 'Documentation Update',
        description:
            'Update API documentation with latest changes and examples...',
        clientId: clientId,
        clientName: 'Alice Johnson',
        status: TicketStatus.closed,
        priority: TicketPriority.low,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        resolvedAt: DateTime.now().subtract(const Duration(days: 2)),
        assignedTo: 'Documentation Team',
        tags: ['docs', 'api'],
      ),
    ];
  }

  Future<bool> createClient(ClientModel client) async {
    try {
      _setLoading(true);
      _setError(null);

      final newClient = await _clientService.createClient(client);
      _clients.insert(0, newClient);
      _applyFilters();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateClient(ClientModel client) async {
    try {
      _setLoading(true);
      _setError(null);

      final updatedClient = await _clientService.updateClient(client);
      final index = _clients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        _clients[index] = updatedClient;
        _applyFilters();
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteClient(String id) async {
    try {
      _setLoading(true);
      _setError(null);

      final success = await _clientService.deleteClient(id);
      if (success) {
        _clients.removeWhere((client) => client.id == id);
        _applyFilters();
      }

      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void searchClients(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByActiveStatus(bool? isActive) {
    _isActiveFilter = isActive;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _isActiveFilter = null;
    _applyFilters();
  }

  void clearError() {
    _setError(null);
  }

  // Statistics methods
  int get totalClientsCount => _clients.length;
  int get activeClientsCount => _clients.where((c) => c.isActive).length;
  int get inactiveClientsCount => _clients.where((c) => !c.isActive).length;

  double get averageTicketsPerClient {
    if (_clients.isEmpty) return 0.0;
    final totalTickets = _clients.fold<int>(
      0,
      (sum, client) =>
          sum +
          client.ticketsInProgress +
          client.ticketsResolved +
          client.ticketsNew +
          client.ticketsRejected,
    );
    return totalTickets / _clients.length;
  }
}
