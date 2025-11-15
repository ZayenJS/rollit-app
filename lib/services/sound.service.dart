import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _enabled = true;

  static void setEnabled(bool value) {
    _enabled = value;
  }

  static Future<void> play(String fileName) async {
    if (!_enabled) return;

    await _player.play(AssetSource('sounds/$fileName'), volume: 0.8);
  }
}
