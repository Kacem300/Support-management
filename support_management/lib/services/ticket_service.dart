import '../models/models.dart';

abstract class TicketService {
  Future<List<TicketModel>> getTickets({int page = 1, int limit = 20});
  Future<TicketModel?> getTicketById(String id);
  Future<TicketModel> createTicket(TicketModel ticket);
  Future<TicketModel> updateTicket(TicketModel ticket);
  Future<bool> deleteTicket(String id);
  Future<List<TicketModel>> searchTickets(String query);
  Future<List<TicketModel>> filterTickets({
    TicketStatus? status,
    TicketPriority? priority,
    String? clientId,
  });
}

class TicketServiceImpl implements TicketService {
  // Mock data storage
  static final List<TicketModel> _tickets = [
    TicketModel(
      id: '1',
      title: 'Login Issue',
      description: 'User unable to login to the system',
      clientId: '1',
      clientName: 'Alice Johnson',
      status: TicketStatus.open,
      priority: TicketPriority.urgent,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      tags: ['authentication', 'urgente'],
    ),
    TicketModel(
      id: '2',
      title: 'Feature Request',
      description: 'Request for new dashboard feature',
      clientId: '2',
      clientName: 'Bob Smith',
      status: TicketStatus.inProgress,
      priority: TicketPriority.urgent,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['feature', 'dashboard'],
    ),
    TicketModel(
      id: '3',
      title: 'Bug Report',
      description: 'Application crashes on startup',
      clientId: '3',
      clientName: 'Carol Williams',
      status: TicketStatus.resolved,
      priority: TicketPriority.low,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      resolvedAt: DateTime.now().subtract(const Duration(hours: 6)),
      tags: ['bug', 'crash'],
    ),
    TicketModel(
      id: '4',
      title: 'Report',
      description: 'Application crashes',
      clientId: '4',
      clientName: 'David Brown',
      status: TicketStatus.closed,
      priority: TicketPriority.medium,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      resolvedAt: DateTime.now().subtract(const Duration(hours: 6)),
      tags: ['bug', 'crash'],
    ),
  ];

  @override
  Future<List<TicketModel>> getTickets({int page = 1, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= _tickets.length) return [];

    return _tickets.sublist(
      startIndex,
      endIndex > _tickets.length ? _tickets.length : endIndex,
    );
  }

  @override
  Future<TicketModel?> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<TicketModel> createTicket(TicketModel ticket) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final newTicket = ticket.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
    );

    _tickets.insert(0, newTicket);
    return newTicket;
  }

  @override
  Future<TicketModel> updateTicket(TicketModel ticket) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final index = _tickets.indexWhere((t) => t.id == ticket.id);
    if (index == -1) {
      throw Exception('Ticket not found');
    }

    final updatedTicket = ticket.copyWith(updatedAt: DateTime.now());
    _tickets[index] = updatedTicket;
    return updatedTicket;
  }

  @override
  Future<bool> deleteTicket(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _tickets.indexWhere((ticket) => ticket.id == id);
    if (index == -1) return false;

    _tickets.removeAt(index);
    return true;
  }

  @override
  Future<List<TicketModel>> searchTickets(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (query.isEmpty) return _tickets;

    return _tickets
        .where((ticket) =>
            ticket.title.toLowerCase().contains(query.toLowerCase()) ||
            ticket.description.toLowerCase().contains(query.toLowerCase()) ||
            ticket.clientName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<TicketModel>> filterTickets({
    TicketStatus? status,
    TicketPriority? priority,
    String? clientId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _tickets.where((ticket) {
      if (status != null && ticket.status != status) return false;
      if (priority != null && ticket.priority != priority) return false;
      if (clientId != null && ticket.clientId != clientId) return false;
      return true;
    }).toList();
  }
}
