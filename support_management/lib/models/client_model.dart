import 'user_model.dart';

class ClientModel extends UserModel {
  final String? company;
  final String? website;
  final String? address;
  final DateTime
      joinDate; // keep original field name to preserve external shape
  final int ticketsInProgress;
  final int ticketsResolved;
  final int ticketsNew;
  final int ticketsRejected;

  ClientModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    this.company,
    super.avatar,
    this.website,
    this.address,
    required this.joinDate,
    super.isActive,
    this.ticketsInProgress = 0,
    this.ticketsResolved = 0,
    this.ticketsNew = 0,
    this.ticketsRejected = 0,
  }) : super(
          createdAt: joinDate,
        );

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    final joinDate =
        DateTime.tryParse(json['joinDate'] ?? '') ?? DateTime.now();
    return ClientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      company: json['company'],
      avatar: json['avatar'],
      website: json['website'],
      address: json['address'],
      joinDate: joinDate,
      isActive: json['isActive'] ?? true,
      ticketsInProgress: json['ticketsInProgress'] ?? 0,
      ticketsResolved: json['ticketsResolved'] ?? 0,
      ticketsNew: json['ticketsNew'] ?? 0,
      ticketsRejected: json['ticketsRejected'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    // Keep original ClientModel JSON shape by including joinDate and client-specific fields
    map.addAll({
      'company': company,
      'website': website,
      'address': address,
      'joinDate': joinDate.toIso8601String(),
      'ticketsInProgress': ticketsInProgress,
      'ticketsResolved': ticketsResolved,
      'ticketsNew': ticketsNew,
      'ticketsRejected': ticketsRejected,
    });
    return map;
  }

  @override
  ClientModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phoneNumber,
    DateTime? createdAt,
    bool? isActive,
    // client-specific
    String? company,
    String? website,
    String? address,
    DateTime? joinDate,
    int? ticketsInProgress,
    int? ticketsResolved,
    int? ticketsNew,
    int? ticketsRejected,
  }) {
    // prefer explicit joinDate, fallback to createdAt for compatibility
    final newJoinDate = joinDate ?? createdAt ?? this.joinDate;
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      company: company ?? this.company,
      avatar: avatar ?? this.avatar,
      website: website ?? this.website,
      address: address ?? this.address,
      joinDate: newJoinDate,
      isActive: isActive ?? this.isActive,
      ticketsInProgress: ticketsInProgress ?? this.ticketsInProgress,
      ticketsResolved: ticketsResolved ?? this.ticketsResolved,
      ticketsNew: ticketsNew ?? this.ticketsNew,
      ticketsRejected: ticketsRejected ?? this.ticketsRejected,
    );
  }
}
