import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class TicketController extends ChangeNotifier {
  final TicketService _ticketService = TicketServiceImpl();

  List<TicketModel> _tickets = [];
  List<TicketModel> _filteredTickets = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  TicketStatus? _statusFilter;
  TicketPriority? _priorityFilter;
  String? _clientFilter;

  // Getters
  List<TicketModel> get tickets => _filteredTickets;
  List<TicketModel> get allTickets => _tickets;
  // Number of tickets to show in recent list; supports lazy load
  int _displayLimit = 2;
  int get displayLimit => _displayLimit;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  TicketStatus? get statusFilter => _statusFilter;
  TicketPriority? get priorityFilter => _priorityFilter;
  String? get clientFilter => _clientFilter;

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setTickets(List<TicketModel> tickets) {
    _tickets = tickets;
    _applyFilters();
  }

  void resetDisplayLimit([int initial = 2]) {
    _displayLimit = initial;
    notifyListeners();
  }

  void increaseDisplayLimit([int step = 10]) {
    _displayLimit = (_displayLimit + step).clamp(0, _tickets.length);
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTickets = _tickets.where((ticket) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch =
            ticket.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                ticket.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                ticket.clientName
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
        if (!matchesSearch) return false;
      }

      // Status filter
      if (_statusFilter != null && ticket.status != _statusFilter) {
        return false;
      }

      // Priority filter
      if (_priorityFilter != null && ticket.priority != _priorityFilter) {
        return false;
      }

      // Client filter
      if (_clientFilter != null && ticket.clientId != _clientFilter) {
        return false;
      }

      return true;
    }).toList();

    // Apply display limit for 'recent' lists / lazy loading
    if (_displayLimit > 0 && _filteredTickets.length > _displayLimit) {
      _filteredTickets = _filteredTickets.sublist(0, _displayLimit);
    }

    notifyListeners();
  }

  // Public methods
  Future<void> loadTickets({bool refresh = false}) async {
    try {
      if (refresh || _tickets.isEmpty) {
        _setLoading(true);
        _setError(null);

        final tickets = await _ticketService.getTickets();
        _setTickets(tickets);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<TicketModel?> getTicketById(String id) async {
    try {
      _setError(null);
      return await _ticketService.getTicketById(id);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  Future<bool> createTicket(TicketModel ticket) async {
    try {
      _setLoading(true);
      _setError(null);

      final newTicket = await _ticketService.createTicket(ticket);
      _tickets.insert(0, newTicket);
      _applyFilters();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateTicket(TicketModel ticket) async {
    try {
      _setLoading(true);
      _setError(null);

      final updatedTicket = await _ticketService.updateTicket(ticket);
      final index = _tickets.indexWhere((t) => t.id == ticket.id);
      if (index != -1) {
        _tickets[index] = updatedTicket;
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

  Future<bool> deleteTicket(String id) async {
    try {
      _setLoading(true);
      _setError(null);

      final success = await _ticketService.deleteTicket(id);
      if (success) {
        _tickets.removeWhere((ticket) => ticket.id == id);
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

  void searchTickets(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByStatus(TicketStatus? status) {
    _statusFilter = status;
    _applyFilters();
  }

  void filterByPriority(TicketPriority? priority) {
    _priorityFilter = priority;
    _applyFilters();
  }

  void filterByClient(String? clientId) {
    _clientFilter = clientId;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _priorityFilter = null;
    _clientFilter = null;
    _applyFilters();
  }

  void clearError() {
    _setError(null);
  }

  // Statistics methods
  int get openTicketsCount =>
      _tickets.where((t) => t.status == TicketStatus.open).length;
  int get inProgressTicketsCount =>
      _tickets.where((t) => t.status == TicketStatus.inProgress).length;
  int get resolvedTicketsCount =>
      _tickets.where((t) => t.status == TicketStatus.resolved).length;
  int get closedTicketsCount =>
      _tickets.where((t) => t.status == TicketStatus.closed).length;

  int get urgentTicketsCount =>
      _tickets.where((t) => t.priority == TicketPriority.urgent).length;
  int get highPriorityTicketsCount =>
      _tickets.where((t) => t.priority == TicketPriority.high).length;
  int get mediumPriorityTicketsCount =>
      _tickets.where((t) => t.priority == TicketPriority.medium).length;
  int get lowPriorityTicketsCount =>
      _tickets.where((t) => t.priority == TicketPriority.low).length;
}
