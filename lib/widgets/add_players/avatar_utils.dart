String avatarAssetForIndex(int? avatarIndex) {
  if (avatarIndex == null || avatarIndex == 0) {
    return 'assets/images/avatars/avatar_unknown.png';
  }
  return 'assets/images/avatars/avatar_${avatarIndex.toString().padLeft(2, '0')}.png';
}
