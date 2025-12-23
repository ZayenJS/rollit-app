import 'package:flutter/material.dart';
import 'package:rollit/providers/party_mode.provider.dart';
import 'package:rollit/widgets/add_players/avatar_utils.dart';

class SelectedPlayersGrid extends StatelessWidget {
  final List<PartyPlayer> players;
  final Set<PartyPlayer> animatingPlayers;
  final GlobalKey Function(PartyPlayer player) avatarKeyBuilder;
  final void Function(int index, PartyPlayer player) onPlayerTap;

  const SelectedPlayersGrid({
    super.key,
    required this.players,
    required this.animatingPlayers,
    required this.avatarKeyBuilder,
    required this.onPlayerTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return Visibility(
          visible: !animatingPlayers.contains(player),
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: _SelectedPlayerTile(
            player: player,
            avatarKey: avatarKeyBuilder(player),
            onDelete: () => onPlayerTap(index, player),
          ),
        );
      },
    );
  }
}

class _SelectedPlayerTile extends StatelessWidget {
  final PartyPlayer player;
  final GlobalKey avatarKey;
  final VoidCallback onDelete;

  const _SelectedPlayerTile({
    required this.player,
    required this.avatarKey,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = avatarAssetForIndex(player.avatarIndex);
    return Column(
      children: [
        GestureDetector(
          onTap: onDelete,
          child: ClipRRect(
            key: avatarKey,
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(avatarUrl, width: 64, height: 64),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          player.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
