import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../constants/constants.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with priority and status
              Row(
                children: [
                  _buildPriorityChip(),
                  const Spacer(),
                  _buildStatusChip(),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                ticket.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Description
              if (ticket.description.isNotEmpty)
                Text(
                  ticket.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: 12),

              // Client and date info
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            ticket.clientName,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(ticket.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              // Action buttons
              if (onEdit != null || onDelete != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null)
                      TextButton(
                        onPressed: onEdit,
                        child: Text(AppStrings.edit),
                      ),
                    if (onDelete != null)
                      TextButton(
                        onPressed: onDelete,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                        child: Text(AppStrings.delete),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip() {
    Color color;
    IconData icon;

    switch (ticket.priority) {
      case TicketPriority.urgent:
        color = AppColors.priorityUrgent;
        icon = Icons.warning;
        break;
      case TicketPriority.high:
        color = AppColors.priorityHigh;
        icon = Icons.keyboard_arrow_up;
        break;
      case TicketPriority.medium:
        color = AppColors.priorityMedium;
        icon = Icons.remove;
        break;
      case TicketPriority.low:
        color = AppColors.priorityLow;
        icon = Icons.keyboard_arrow_down;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            _getPriorityText(ticket.priority),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    Color color;

    switch (ticket.status) {
      case TicketStatus.open:
        color = AppColors.statusOpen;
        break;
      case TicketStatus.inProgress:
        color = AppColors.statusInProgress;
        break;
      case TicketStatus.resolved:
        color = AppColors.statusResolved;
        break;
      case TicketStatus.closed:
        color = AppColors.statusClosed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        _getStatusText(ticket.status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getPriorityText(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return AppStrings.priorityLow;
      case TicketPriority.medium:
        return AppStrings.priorityMedium;
      case TicketPriority.high:
        return AppStrings.priorityHigh;
      case TicketPriority.urgent:
        return AppStrings.priorityUrgent;
    }
  }

  String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return AppStrings.statusOpen;
      case TicketStatus.inProgress:
        return AppStrings.statusInProgress;
      case TicketStatus.resolved:
        return AppStrings.statusResolved;
      case TicketStatus.closed:
        return AppStrings.statusClosed;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
