import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiceState {
  final int rolls;
  final int maxRollsBeforePaywall = 49;

  DiceState({required this.rolls});
}

class DiceNotifier extends Notifier<DiceState> {
  @override
  DiceState build() {
    return DiceState(rolls: 0);
  }

  void incrementRolls() {
    state = DiceState(rolls: state.rolls + 1);
  }
}

final diceProvider = NotifierProvider<DiceNotifier, DiceState>(
  () => DiceNotifier(),
);
