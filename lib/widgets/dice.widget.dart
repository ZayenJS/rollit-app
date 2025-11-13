import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int number;

  const DiceWidget({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Text(number.toString(), style: const TextStyle(fontSize: 32));
  }
}
