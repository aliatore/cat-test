import 'dart:async';

import 'package:cat_directory_app/core/services/audio/sound_effects.dart';
import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_theme.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/appear.dart';
import 'package:cat_directory_app/design_system/widgets/cyber_background.dart';
import 'package:cat_directory_app/design_system/widgets/glitch_text.dart';
import 'package:cat_directory_app/design_system/widgets/sound_scope.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Splash animado que se dibuja encima de la app en el arranque en frio.
///
/// No es una ruta: la app (y la carga de datos desde la cache) arranca debajo
/// al mismo tiempo, y un deep link abre directamente su pantalla. Al terminar
/// se desvanece y deja al usuario donde tenia que estar.
class SplashOverlay extends StatefulWidget {
  const SplashOverlay({required this.child, super.key});

  final Widget child;

  @override
  State<SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends State<SplashOverlay>
    with TickerProviderStateMixin {
  /// El Lottie dura 2.4 s; a 1.3x el arranque no se siente lento.
  static const _speed = 1.3;

  late final _lottie = AnimationController(vsync: this);
  late final _exit = AnimationController(vsync: this, duration: Motion.slow);
  var _visible = true;
  var _started = false;
  Timer? _fallback;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    unawaited(SoundScope.of(context).play(Sfx.boot));
    // Si el Lottie no carga por lo que sea, el splash no se queda pegado.
    _fallback = Timer(const Duration(seconds: 4), _dismiss);
    if (Motion.reduced(context)) {
      _fallback?.cancel();
      _fallback = Timer(const Duration(milliseconds: 700), _dismiss);
    }
  }

  void _onLoaded(LottieComposition composition) {
    if (Motion.reduced(context)) {
      _lottie
        ..duration = composition.duration
        ..value = 1;
      return;
    }
    _lottie.duration = composition.duration * (1 / _speed);
    unawaited(
      _lottie.forward().whenComplete(
        () => Future<void>.delayed(
          const Duration(milliseconds: 250),
          _dismiss,
        ),
      ),
    );
  }

  Future<void> _dismiss() async {
    _fallback?.cancel();
    if (!mounted || !_visible || _exit.isAnimating) return;
    await _exit.forward();
    if (mounted) setState(() => _visible = false);
  }

  @override
  void dispose() {
    _fallback?.cancel();
    _lottie.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExcludeSemantics(excluding: _visible, child: widget.child),
        if (_visible)
          Positioned.fill(
            child: FadeTransition(
              opacity: ReverseAnimation(_exit),
              child: Theme(
                // El splash es siempre "Night City", aunque el sistema este
                // en modo claro: es el momento de marca.
                data: NekoTheme.dark(),
                // Esta capa vive fuera del Navigator: sin un Material propio
                // los textos heredan el estilo de depuracion de Flutter.
                child: Material(
                  type: MaterialType.transparency,
                  child: _SplashScene(
                    controller: _lottie,
                    onLoaded: _onLoaded,
                    onSkip: _dismiss,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SplashScene extends StatelessWidget {
  const _SplashScene({
    required this.controller,
    required this.onLoaded,
    required this.onSkip,
  });

  final AnimationController controller;
  final ValueChanged<LottieComposition> onLoaded;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;

    return Semantics(
      label: l10n.appName,
      hint: l10n.splashSkip,
      button: true,
      excludeSemantics: true,
      onTap: onSkip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSkip,
        child: CyberBackground(
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                Lottie.asset(
                  'assets/lottie/splash.json',
                  controller: controller,
                  onLoaded: onLoaded,
                  width: 230,
                  height: 230,
                  frameRate: FrameRate.max,
                ),
                const SizedBox(height: 6),
                Appear(
                  delay: const Duration(milliseconds: 1150),
                  child: GlitchText(
                    'NEKO//DEX',
                    every: const Duration(milliseconds: 900),
                    style: NekoFonts.orbitron(
                      32,
                      FontWeight.w900,
                    ).copyWith(color: colors.textPrimary),
                  ),
                ),
                const SizedBox(height: 10),
                Appear(
                  delay: const Duration(milliseconds: 1350),
                  child: Text(
                    l10n.directoryTagline.toUpperCase(),
                    style: NekoFonts.monoLabel(
                      13,
                    ).copyWith(color: colors.cyan, letterSpacing: 5),
                  ),
                ),
                const Spacer(flex: 4),
                Appear(
                  delay: const Duration(milliseconds: 1600),
                  child: Text(
                    l10n.splashSkip.toUpperCase(),
                    style: NekoFonts.monoLabel(
                      11,
                    ).copyWith(color: colors.textMuted),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
