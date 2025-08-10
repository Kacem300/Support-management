import '../models/client_model.dart';

abstract class ClientService {
  Future<List<ClientModel>> getClients({int page = 1, int limit = 20});
  Future<ClientModel?> getClientById(String id);
  Future<ClientModel> createClient(ClientModel client);
  Future<ClientModel> updateClient(ClientModel client);
  Future<bool> deleteClient(String id);
  Future<List<ClientModel>> searchClients(String query);
}

class ClientServiceImpl implements ClientService {
  static final List<ClientModel> _clients = [
    ClientModel(
      id: '1',
      name: 'Alice Johnson',
      email: 'alwissuryatmaja@gmail.com',
      phoneNumber: '+6282283386756',
      company: 'Tech Corp',
      website: 'www.aftercode.tn',
      address: '2464 Royal Ln. Mesa, New Jersey',
      joinDate: DateTime(2024, 8, 12),
      isActive: true,
      ticketsInProgress: 3,
      ticketsResolved: 3,
      ticketsNew: 8,
      ticketsRejected: 3,
      avatar: 'assets/images/default_avatar.png',
    ),
    ClientModel(
      id: '2',
      name: 'Bob Smith',
      email: 'bob@example.com',
      phoneNumber: '+1234567891',
      company: 'Design Studio',
      website: 'www.designstudio.com',
      address: '123 Main St, New York',
      joinDate: DateTime.now().subtract(const Duration(days: 45)),
      isActive: true,
      ticketsInProgress: 1,
      ticketsResolved: 3,
      ticketsNew: 5,
      ticketsRejected: 2,
      avatar: 'assets/images/default_avatar.png',
    ),
    ClientModel(
      id: '3',
      name: 'Carol Williams',
      email: 'carol@example.com',
      phoneNumber: '+1234567892',
      company: 'Marketing Inc',
      website: 'www.marketinginc.com',
      address: '456 Oak Ave, California',
      joinDate: DateTime.now().subtract(const Duration(days: 60)),
      isActive: false,
      ticketsInProgress: 0,
      ticketsResolved: 8,
      ticketsNew: 2,
      ticketsRejected: 1,
      avatar: 'assets/images/default_avatar.png',
    ),
    ClientModel(
      id: '4',
      name: 'David Brown',
      email: 'david@example.com',
      phoneNumber: '+1234567893',
      company: 'Consulting LLC',
      website: 'www.consultingllc.com',
      address: '789 Pine Rd, Texas',
      joinDate: DateTime.now().subtract(const Duration(days: 15)),
      isActive: true,
      ticketsInProgress: 3,
      ticketsResolved: 1,
      ticketsNew: 4,
      ticketsRejected: 0,
      avatar: 'assets/images/default_avatar.png',
    ),
  ];

  @override
  Future<List<ClientModel>> getClients({int page = 1, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= _clients.length) return [];

    return _clients.sublist(
      startIndex,
      endIndex > _clients.length ? _clients.length : endIndex,
    );
  }

  @override
  Future<ClientModel?> getClientById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _clients.firstWhere((client) => client.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ClientModel> createClient(ClientModel client) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final newClient = client.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      joinDate: DateTime.now(),
    );

    _clients.insert(0, newClient);
    return newClient;
  }

  @override
  Future<ClientModel> updateClient(ClientModel client) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index == -1) {
      throw Exception('Client not found');
    }

    _clients[index] = client;
    return client;
  }

  @override
  Future<bool> deleteClient(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _clients.indexWhere((client) => client.id == id);
    if (index == -1) return false;

    _clients.removeAt(index);
    return true;
  }

  @override
  Future<List<ClientModel>> searchClients(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (query.isEmpty) return _clients;

    return _clients
        .where((client) =>
            client.name.toLowerCase().contains(query.toLowerCase()) ||
            client.email.toLowerCase().contains(query.toLowerCase()) ||
            (client.company?.toLowerCase().contains(query.toLowerCase()) ?? false))
        .toList();
  }
}