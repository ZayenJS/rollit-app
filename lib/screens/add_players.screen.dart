import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rollit/widgets/app_background.widget.dart';
import 'package:rollit/services/i18n.service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rollit/providers/party_mode.provider.dart';

class AddPlayersScreen extends ConsumerStatefulWidget {
  const AddPlayersScreen({super.key});

  @override
  ConsumerState<AddPlayersScreen> createState() => _AddPlayersScreenState();
}

String _avatarAssetForIndex(int? avatarIndex) {
  if (avatarIndex == null || avatarIndex == 0) {
    return 'assets/images/avatars/avatar_unknown.png';
  }
  return 'assets/images/avatars/avatar_${avatarIndex.toString().padLeft(2, '0')}.png';
}

class _AddPlayersScreenState extends ConsumerState<AddPlayersScreen>
    with TickerProviderStateMixin {
  static const int _maxPlayers = 8;
  final List<int> _draftPlayerIds = [];
  int _nextDraftPlayerId = 1;
  int? _focusDraftId;
  final Map<int, GlobalKey> _draftAvatarKeys = {};
  final Map<PartyPlayer, GlobalKey> _playerAvatarKeys = {};
  final Set<PartyPlayer> _animatingPlayers = {};

  GlobalKey _draftAvatarKey(int draftId) {
    return _draftAvatarKeys.putIfAbsent(draftId, () => GlobalKey());
  }

  GlobalKey _playerAvatarKey(PartyPlayer player) {
    return _playerAvatarKeys.putIfAbsent(player, () => GlobalKey());
  }

  Future<int?> _pickAvatar(BuildContext context, {int? selectedAvatarIndex}) {
    return showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) => SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.8,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 81, 39, 180),
                    Color.fromARGB(255, 106, 58, 201),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  20 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          I18nKeys.instance.addPlayers.chooseAvatarTitle.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 6),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final avatarIndex = index + 1;
                        final isSelected = selectedAvatarIndex == avatarIndex;
                        return GestureDetector(
                          onTap: () => Navigator.pop(context, avatarIndex),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFF5EDF)
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFF5EDF,
                                        ).withValues(alpha: 0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'assets/images/avatars/avatar_${avatarIndex.toString().padLeft(2, '0')}.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Color(0xFF6A5DFF),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPlayerOptions(int index, PartyPlayer player) async {
    String editedName = player.name;
    int selectedAvatarIndex = player.avatarIndex;
    bool canSave() => editedName.trim().isNotEmpty;
    bool? result;
    result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) => SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: StatefulBuilder(
              builder: (context, setModalState) => Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.8,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 81, 39, 180),
                      Color.fromARGB(255, 106, 58, 201),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    20 + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          final selection = await _pickAvatar(
                            context,
                            selectedAvatarIndex: selectedAvatarIndex,
                          );
                          if (selection != null) {
                            setModalState(() {
                              selectedAvatarIndex = selection;
                            });
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            _avatarAssetForIndex(selectedAvatarIndex),
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: editedName,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: I18nKeys.instance.addPlayers.playerName
                              .tr(),
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            editedName = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(64),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0,
                                    vertical: 12.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64),
                                  ),
                                ),
                                child: Text(
                                  I18nKeys.instance.addPlayers.editDelete.tr(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(64),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: canSave()
                                    ? () => Navigator.pop(context, false)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  disabledForegroundColor: Colors.white
                                      .withValues(alpha: 0.6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0,
                                    vertical: 12.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64),
                                  ),
                                ),
                                child: Text(
                                  I18nKeys.instance.addPlayers.editSave.tr(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (result == true) {
      ref.read(partyModeProvider.notifier).removePlayerAt(index);
      _playerAvatarKeys.remove(player);
      return;
    }
    if (result == false) {
      final updatedPlayer = PartyPlayer(
        name: editedName.trim(),
        avatarIndex: selectedAvatarIndex,
      );
      setState(() {
        _playerAvatarKeys.remove(player);
        _playerAvatarKey(updatedPlayer);
      });
      ref.read(partyModeProvider.notifier).updatePlayerAt(index, updatedPlayer);
    }
  }

  void _animateAvatarToGrid({
    required GlobalKey fromKey,
    required GlobalKey toKey,
    required int avatarIndex,
    required String name,
    required PartyPlayer player,
  }) {
    final overlay = Overlay.of(context);
    final fromBox = fromKey.currentContext?.findRenderObject() as RenderBox?;
    final toBox = toKey.currentContext?.findRenderObject() as RenderBox?;
    if (overlay == null || fromBox == null || toBox == null) {
      return;
    }

    final fromOffset = fromBox.localToGlobal(Offset.zero);
    final toOffset = toBox.localToGlobal(Offset.zero);
    final fromSize = fromBox.size;
    final toSize = toBox.size;
    final avatarUrl = _avatarAssetForIndex(avatarIndex);

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final t = animation.value;
          final left = lerpDouble(fromOffset.dx, toOffset.dx, t) ?? 0;
          final top = lerpDouble(fromOffset.dy, toOffset.dy, t) ?? 0;
          final width = lerpDouble(fromSize.width, toSize.width, t) ?? 0;
          final height = lerpDouble(fromSize.height, toSize.height, t) ?? 0;
          return Positioned(
            left: left,
            top: top,
            child: IgnorePointer(
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(avatarUrl, width: width, height: height),
                      const SizedBox(height: 6),
                      Opacity(
                        opacity: t,
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    overlay.insert(entry);
    controller.forward().whenComplete(() {
      entry.remove();
      controller.dispose();
      if (mounted) {
        setState(() {
          _animatingPlayers.remove(player);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final partyState = ref.watch(partyModeProvider);
    final canStartGame = partyState.players.length >= 2;
    final hasReachedMaxPlayers = partyState.players.length >= _maxPlayers;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(I18nKeys.instance.addPlayers.title.tr()),
          actions: [
            IconButton(
              onPressed: hasReachedMaxPlayers
                  ? null
                  : () {
                      setState(() {
                        final newDraftId = _nextDraftPlayerId++;
                        _draftPlayerIds.add(newDraftId);
                        _focusDraftId = newDraftId;
                      });
                    },
              icon: const Icon(Icons.add, size: 28),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (partyState.players.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        I18nKeys.instance.addPlayers.emptyTitle.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        I18nKeys.instance.addPlayers.emptySubtitle.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (partyState.players.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          I18nKeys.instance.addPlayers.playersLabel.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: I18nKeys.instance.addPlayers.maxPlayersHint
                              .tr(),
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 3),
                          exitDuration: const Duration(milliseconds: 360),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.25),
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
                              '${partyState.players.length}/$_maxPlayers',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                      itemCount: partyState.players.length,
                      itemBuilder: (context, index) {
                        final player = partyState.players[index];
                        return Visibility(
                          visible: !_animatingPlayers.contains(player),
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: _SelectedPlayerTile(
                            player: player,
                            avatarKey: _playerAvatarKey(player),
                            onDelete: () => _showPlayerOptions(index, player),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              if (hasReachedMaxPlayers) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    I18nKeys.instance.addPlayers.maxPlayersReached.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              if (partyState.players.isNotEmpty) const SizedBox(height: 20),
              for (final draftId in _draftPlayerIds)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _DraftPlayerCard(
                    avatarKey: _draftAvatarKey(draftId),
                    autofocus: _focusDraftId == draftId,
                    onPickAvatar: (selectedAvatarIndex) => _pickAvatar(
                      context,
                      selectedAvatarIndex: selectedAvatarIndex,
                    ),
                    onRemove: () {
                      setState(() {
                        _draftAvatarKeys.remove(draftId);
                        _draftPlayerIds.remove(draftId);
                        if (_focusDraftId == draftId) {
                          _focusDraftId = null;
                        }
                      });
                    },
                    onValidate: (name, avatarIndex) {
                      if (partyState.players.length >= _maxPlayers) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              I18nKeys.instance.addPlayers.maxPlayersReached
                                  .tr(),
                            ),
                          ),
                        );
                        return;
                      }
                      final player = PartyPlayer(
                        name: name,
                        avatarIndex: avatarIndex,
                      );
                      setState(() {
                        _animatingPlayers.add(player);
                        if (_focusDraftId == draftId) {
                          _focusDraftId = null;
                        }
                      });
                      final targetKey = _playerAvatarKey(player);
                      ref.read(partyModeProvider.notifier).addPlayer(player);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _animateAvatarToGrid(
                          fromKey: _draftAvatarKey(draftId),
                          toKey: targetKey,
                          avatarIndex: avatarIndex,
                          name: name,
                          player: player,
                        );
                      });
                    },
                  ),
                ),
              if (partyState.players.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(
                          0xFFFF5EDF,
                        ).withValues(alpha: canStartGame ? 1.0 : 0.4),
                        const Color(
                          0xFF6A5DFF,
                        ).withValues(alpha: canStartGame ? 1.0 : 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(64),
                    boxShadow: canStartGame
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFFFF3EDF,
                              ).withValues(alpha: 0.4),
                              blurRadius: 12.0,
                              spreadRadius: 0.5,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: ElevatedButton(
                    onPressed: canStartGame
                        ? () => Navigator.pop(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white.withValues(
                        alpha: 0.6,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 14.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64),
                      ),
                    ),
                    child: Text(I18nKeys.instance.addPlayers.startGame.tr()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedPlayerTile extends StatelessWidget {
  final PartyPlayer player;
  final GlobalKey avatarKey;
  final VoidCallback onDelete;

  const _SelectedPlayerTile({
    super.key,
    required this.player,
    required this.avatarKey,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _avatarAssetForIndex(player.avatarIndex);
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

class _DraftPlayerCard extends StatefulWidget {
  final GlobalKey avatarKey;
  final bool autofocus;
  final Future<int?> Function(int? selectedAvatarIndex) onPickAvatar;
  final void Function(String name, int avatarIndex) onValidate;
  final VoidCallback onRemove;

  const _DraftPlayerCard({
    super.key,
    required this.avatarKey,
    required this.autofocus,
    required this.onPickAvatar,
    required this.onValidate,
    required this.onRemove,
  });

  @override
  State<_DraftPlayerCard> createState() => _DraftPlayerCardState();
}

class _DraftPlayerCardState extends State<_DraftPlayerCard> {
  static const _submitAnimationDelay = Duration(milliseconds: 120);
  static const _submitAnimationDuration = Duration(milliseconds: 280);
  late final TextEditingController _nameController;
  int? _selectedAvatarIndex;
  bool _isSubmitting = false;
  bool _collapse = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    HapticFeedback.lightImpact();
    final avatarIndex = _selectedAvatarIndex ?? 0;
    widget.onValidate(_nameController.text.trim(), avatarIndex);
    await Future.delayed(_submitAnimationDelay);
    if (!mounted) {
      return;
    }
    setState(() {
      _collapse = true;
    });
    await Future.delayed(_submitAnimationDuration);
    if (mounted) {
      widget.onRemove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _avatarAssetForIndex(_selectedAvatarIndex);
    final canValidate = _nameController.text.trim().isNotEmpty;

    final cardContent = Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 81, 39, 180),
            Color.fromARGB(255, 106, 58, 201),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _isSubmitting
                        ? null
                        : () async {
                            final selectedAvatar = await widget.onPickAvatar(
                              _selectedAvatarIndex,
                            );
                            if (selectedAvatar != null) {
                              setState(() {
                                _selectedAvatarIndex = selectedAvatar;
                              });
                            }
                          },
                    child: ClipRRect(
                      key: widget.avatarKey,
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(avatarUrl, width: 80, height: 80),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _nameController,
                      autofocus: widget.autofocus,
                      enabled: !_isSubmitting,
                      decoration: InputDecoration(
                        labelText: I18nKeys.instance.addPlayers.playerName.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                          onPressed: _isSubmitting ? null : widget.onRemove,
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          disabledColor: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                          onPressed: canValidate && !_isSubmitting
                              ? _submit
                              : null,
                          icon: const Icon(Icons.check),
                          color: Colors.white,
                          disabledColor: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return AnimatedOpacity(
      duration: _submitAnimationDuration,
      opacity: _collapse ? 0.0 : 1.0,
      child: AnimatedSize(
        duration: _submitAnimationDuration,
        curve: Curves.easeInOut,
        child: _collapse ? const SizedBox.shrink() : cardContent,
      ),
    );
  }
}
