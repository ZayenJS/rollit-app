import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartyPlayer {
  final String name;
  final int avatarIndex;

  PartyPlayer({required this.name, required this.avatarIndex});
}

class PartyModeState {
  final List<PartyPlayer> players;

  PartyModeState({required this.players});
}

class PartyModeNotifier extends Notifier<PartyModeState> {
  @override
  PartyModeState build() {
    return PartyModeState(players: []);
  }

  void addPlayer(PartyPlayer player) {
    state = PartyModeState(players: [...state.players, player]);
  }

  void removePlayerAt(int index) {
    if (index < 0 || index >= state.players.length) {
      return;
    }
    final updated = [...state.players]..removeAt(index);
    state = PartyModeState(players: updated);
  }

  void removePlayer(PartyPlayer player) {
    final updated = [...state.players]..remove(player);
    state = PartyModeState(players: updated);
  }

  void updatePlayerAt(int index, PartyPlayer player) {
    if (index < 0 || index >= state.players.length) {
      return;
    }
    final updated = [...state.players];
    updated[index] = player;
    state = PartyModeState(players: updated);
  }
}

final partyModeProvider = NotifierProvider<PartyModeNotifier, PartyModeState>(
  () => PartyModeNotifier(),
);
