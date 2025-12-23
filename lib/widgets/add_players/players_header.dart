import 'package:flutter/material.dart';

class PlayersHeader extends StatelessWidget {
  final String label;
  final String tooltipMessage;
  final int currentCount;
  final int maxCount;

  const PlayersHeader({
    super.key,
    required this.label,
    required this.tooltipMessage,
    required this.currentCount,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: tooltipMessage,
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 2),
          exitDuration: const Duration(milliseconds: 360),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              '$currentCount/$maxCount',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
