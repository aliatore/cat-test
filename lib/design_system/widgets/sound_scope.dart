import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:flutter/widgets.dart';

/// Da acceso a los efectos de sonido a cualquier widget del sistema de
/// diseno sin acoplarlo al contenedor de dependencias.
class SoundScope extends InheritedWidget {
  const SoundScope({required this.sounds, required super.child, super.key});

  final SoundEffects sounds;

  static final _silent = SilentSoundEffects();

  static SoundEffects of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<SoundScope>()?.sounds ?? _silent;

  @override
  bool updateShouldNotify(SoundScope oldWidget) => sounds != oldWidget.sounds;
}
