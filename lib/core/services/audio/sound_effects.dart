/// Efectos disponibles. Los archivos estan en `assets/sfx/` y se generan con
/// `tool/assets/sfx_gen.py`.
enum Sfx {
  boot('sfx/boot.wav', 0.8),
  tap('sfx/tap.wav', 0.45),
  meow('sfx/meow.wav', 0.8),
  glitch('sfx/glitch.wav', 0.55),
  success('sfx/success.wav', 0.55)
  ;

  const Sfx(this.asset, this.volume);

  final String asset;
  final double volume;
}

abstract interface class SoundEffects {
  bool get enabled;

  set enabled(bool value);

  Future<void> preload();

  /// Nunca lanza: si el audio falla, la app sigue igual.
  Future<void> play(Sfx sfx);
}

class SilentSoundEffects implements SoundEffects {
  SilentSoundEffects();

  @override
  bool enabled = false;

  @override
  Future<void> preload() async {}

  @override
  Future<void> play(Sfx sfx) async {}
}
