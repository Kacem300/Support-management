enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed,
}

enum TicketPriority {
  low,
  medium,
  high,
  urgent,
}

class TicketModel {
  final String id;
  final String title;
  final String description;
  final String clientId;
  final String clientName;
  final TicketStatus status;
  final TicketPriority priority;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final String? assignedTo;
  final List<String> tags;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.clientId,
    required this.clientName,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.assignedTo,
    this.tags = const [],
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      clientId: json['clientId'] ?? '',
      clientName: json['clientName'] ?? '',
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.open,
      ),
      priority: TicketPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TicketPriority.medium,
      ),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.tryParse(json['resolvedAt'])
          : null,
      assignedTo: json['assignedTo'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'clientId': clientId,
      'clientName': clientName,
      'status': status.name,
      'priority': priority.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'assignedTo': assignedTo,
      'tags': tags,
    };
  }

  TicketModel copyWith({
    String? id,
    String? title,
    String? description,
    String? clientId,
    String? clientName,
    TicketStatus? status,
    TicketPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    String? assignedTo,
    List<String>? tags,
  }) {
    return TicketModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      tags: tags ?? this.tags,
    );
  }
}
