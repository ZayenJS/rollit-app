import 'package:flutter/material.dart';
import 'package:rollit/providers/party_mode.provider.dart';
import 'package:rollit/widgets/add_players/avatar_utils.dart';

class EditPlayerResult {
  final bool delete;
  final PartyPlayer? updatedPlayer;

  const EditPlayerResult._({required this.delete, this.updatedPlayer});

  const EditPlayerResult.delete() : this._(delete: true);

  const EditPlayerResult.cancel() : this._(delete: false);

  const EditPlayerResult.save(PartyPlayer player)
      : this._(delete: false, updatedPlayer: player);
}

Future<EditPlayerResult?> showEditPlayerSheet({
  required BuildContext context,
  required PartyPlayer player,
  required String playerNameLabel,
  required String deleteLabel,
  required String saveLabel,
  required Future<int?> Function(int? selectedAvatarIndex) onPickAvatar,
}) {
  String editedName = player.name;
  int selectedAvatarIndex = player.avatarIndex;
  bool canSave() => editedName.trim().isNotEmpty;

  return showModalBottomSheet<EditPlayerResult>(
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
                          onPressed: () =>
                              Navigator.pop(context, const EditPlayerResult.cancel()),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        final selection = await onPickAvatar(
                          selectedAvatarIndex,
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
                          avatarAssetForIndex(selectedAvatarIndex),
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
                        labelText: playerNameLabel,
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
                              onPressed: () => Navigator.pop(
                                context,
                                const EditPlayerResult.delete(),
                              ),
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
                              child: Text(deleteLabel),
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
                                  ? () => Navigator.pop(
                                        context,
                                        EditPlayerResult.save(
                                          PartyPlayer(
                                            name: editedName.trim(),
                                            avatarIndex: selectedAvatarIndex,
                                          ),
                                        ),
                                      )
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                disabledForegroundColor:
                                    Colors.white.withValues(
                                  alpha: 0.6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                  vertical: 12.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64),
                                ),
                              ),
                              child: Text(saveLabel),
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
}
