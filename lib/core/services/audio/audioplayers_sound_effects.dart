import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/core/utils/log.dart';

/// Efectos de interfaz con audioplayers.
///
/// Se configuran como sonidos de interfaz: en iOS usan la categoria `ambient`
/// (respetan el interruptor de silencio y se mezclan con la musica del
/// usuario) y en Android no piden foco de audio, asi que nunca pausan
/// Spotify ni un podcast.
class AudioplayersSoundEffects implements SoundEffects {
  AudioplayersSoundEffects({this.enabled = true});

  @override
  bool enabled;

  final _pools = <Sfx, AudioPool>{};
  Future<void>? _loading;

  static final _context = AudioContext(
    android: const AudioContextAndroid(
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.none,
    ),
    // `ambient` ya se mezcla con el audio de otras apps por definicion.
    iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
  );

  @override
  Future<void> preload() => _loading ??= _load();

  Future<void> _load() async {
    try {
      await AudioPlayer.global.setAudioContext(_context);
      for (final sfx in Sfx.values) {
        _pools[sfx] = await AudioPool.create(
          source: AssetSource(sfx.asset),
          maxPlayers: sfx == Sfx.tap ? 3 : 1,
          audioContext: _context,
        );
      }
    } on Object catch (error) {
      logDebug('sfx', 'no se pudo preparar el audio', error: error);
    }
  }

  @override
  Future<void> play(Sfx sfx) async {
    if (!enabled) return;
    try {
      await preload();
      await _pools[sfx]?.start(volume: sfx.volume);
    } on Object catch (error) {
      logDebug('sfx', 'fallo al reproducir $sfx', error: error);
    }
  }
}
