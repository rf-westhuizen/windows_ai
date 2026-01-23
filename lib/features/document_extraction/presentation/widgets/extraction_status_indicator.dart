import 'package:flutter/material.dart';

import '../../data/models/models.dart';

/// Visual indicator for extraction status.
/// 
/// Shows different colors and icons based on the current status.
class ExtractionStatusIndicator extends StatelessWidget {
  const ExtractionStatusIndicator({
    required this.status,
    super.key,
  });

  final ExtractionStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color, label) = _getStatusDetails(theme);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status == ExtractionStatus.processing)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color,
            ),
          )
        else
          Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  (IconData, Color, String) _getStatusDetails(ThemeData theme) {
    return switch (status) {
      ExtractionStatus.pending => (
          Icons.hourglass_empty,
          theme.colorScheme.outline,
          'Pending',
        ),
      ExtractionStatus.processing => (
          Icons.sync,
          theme.colorScheme.primary,
          'Processing',
        ),
      ExtractionStatus.completed => (
          Icons.check_circle,
          Colors.green,
          'Completed',
        ),
      ExtractionStatus.failed => (
          Icons.error,
          theme.colorScheme.error,
          'Failed',
        ),
    };
  }
}
