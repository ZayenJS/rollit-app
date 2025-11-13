import 'package:flutter/material.dart';

class RollitLogo extends StatelessWidget {
  final double size;

  const RollitLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text("🎲", style: TextStyle(fontSize: size * 0.55)),
      ),
    );
  }
}
