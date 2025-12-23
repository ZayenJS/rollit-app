import 'package:flutter/material.dart';

class StartGameButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onPressed;

  const StartGameButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF5EDF).withValues(alpha: enabled ? 1.0 : 0.4),
            const Color(0xFF6A5DFF).withValues(alpha: enabled ? 1.0 : 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(64),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: const Color(0xFFFF3EDF).withValues(alpha: 0.4),
                  blurRadius: 12.0,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(
            horizontal: 0.0,
            vertical: 14.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
