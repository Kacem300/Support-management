class ClientModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? company;
  final String? avatar;
  final String? website;
  final String? address;
  final DateTime joinDate;
  final bool isActive;
  final int ticketsInProgress;
  final int ticketsResolved;
  final int ticketsNew;
  final int ticketsRejected;

  ClientModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.company,
    this.avatar,
    this.website,
    this.address,
    required this.joinDate,
    this.isActive = true,
    this.ticketsInProgress = 0,
    this.ticketsResolved = 0,
    this.ticketsNew = 0,
    this.ticketsRejected = 0,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      company: json['company'],
      avatar: json['avatar'],
      website: json['website'],
      address: json['address'],
      joinDate: DateTime.tryParse(json['joinDate'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
      ticketsInProgress: json['ticketsInProgress'] ?? 0,
      ticketsResolved: json['ticketsResolved'] ?? 0,
      ticketsNew: json['ticketsNew'] ?? 0,
      ticketsRejected: json['ticketsRejected'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'company': company,
      'avatar': avatar,
      'website': website,
      'address': address,
      'joinDate': joinDate.toIso8601String(),
      'isActive': isActive,
      'ticketsInProgress': ticketsInProgress,
      'ticketsResolved': ticketsResolved,
      'ticketsNew': ticketsNew,
      'ticketsRejected': ticketsRejected,
    };
  }

  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? company,
    String? avatar,
    String? website,
    String? address,
    DateTime? joinDate,
    bool? isActive,
    int? ticketsInProgress,
    int? ticketsResolved,
    int? ticketsNew,
    int? ticketsRejected,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      company: company ?? this.company,
      avatar: avatar ?? this.avatar,
      website: website ?? this.website,
      address: address ?? this.address,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      ticketsInProgress: ticketsInProgress ?? this.ticketsInProgress,
      ticketsResolved: ticketsResolved ?? this.ticketsResolved,
      ticketsNew: ticketsNew ?? this.ticketsNew,
      ticketsRejected: ticketsRejected ?? this.ticketsRejected,
    );
  }
}