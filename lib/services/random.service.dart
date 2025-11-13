import 'dart:math';

class RandomService {
  static final Random _random = Random();

  static int rollDice() => _random.nextInt(6) + 1;
}
