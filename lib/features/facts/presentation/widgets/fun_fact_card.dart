import 'dart:async';

import 'package:cat_directory_app/core/domain/data_origin.dart';
import 'package:cat_directory_app/core/presentation/failure_copy.dart';
import 'package:cat_directory_app/design_system/theme/motion.dart';
import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/neon_button.dart';
import 'package:cat_directory_app/design_system/widgets/neon_panel.dart';
import 'package:cat_directory_app/design_system/widgets/skeleton.dart';
import 'package:cat_directory_app/design_system/widgets/status_chip.dart';
import 'package:cat_directory_app/features/facts/domain/entities/cat_fact.dart';
import 'package:cat_directory_app/features/facts/presentation/bloc/cat_fact_bloc.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tarjeta del dato curioso. Tiene su propio bloc: carga, falla y se
/// reintenta sin afectar a la ficha de la raza.
class FunFactCard extends StatelessWidget {
  const FunFactCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final state = context.watch<CatFactBloc>().state;
    final bloc = context.read<CatFactBloc>();
    final fact = switch (state) {
      CatFactLoaded(:final fact) => fact,
      _ => null,
    };

    return NeonPanel(
      accent: colors.purple,
      glow: true,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal_rounded, size: 18, color: colors.purple),
              const SizedBox(width: 8),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.factTitle.toUpperCase(),
                    style: NekoFonts.monoLabel(
                      12.5,
                    ).copyWith(color: colors.purple),
                  ),
                ),
              ),
              if (fact != null)
                StatusChip(
                  label: fact.origin == DataOrigin.remote
                      ? l10n.factLive
                      : l10n.factSaved,
                  color: fact.origin == DataOrigin.remote
                      ? colors.mint
                      : colors.yellow,
                ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: Motion.medium,
            switchInCurve: Motion.enter,
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.topLeft,
              children: [...previous, ?current],
            ),
            child: switch (state) {
              CatFactLoading() => const _FactLoading(key: ValueKey('loading')),
              CatFactLoaded(:final fact) => _FactText(
                key: ValueKey(fact.text),
                fact: fact,
              ),
              CatFactFailure(:final failure) => _FactMessage(
                key: const ValueKey('failure'),
                text: '${l10n.factError} ${failureCopy(l10n, failure).message}',
                color: colors.magenta,
              ),
            },
          ),
          if (fact?.origin == DataOrigin.cache) ...[
            const SizedBox(height: 10),
            Text(
              l10n.factSavedHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          NeonButton(
            label: state is CatFactFailure ? l10n.retry : l10n.factAnother,
            icon: state is CatFactFailure
                ? Icons.refresh_rounded
                : Icons.auto_awesome_rounded,
            variant: NeonButtonVariant.outlined,
            accent: colors.purple,
            expand: true,
            onPressed: state is CatFactLoading
                ? null
                : () => bloc.add(const CatFactRequested()),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.factLanguage,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _FactLoading extends StatelessWidget {
  const _FactLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    return Semantics(
      liveRegion: true,
      label: context.l10n.factLoading,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NeonShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 13),
                SizedBox(height: 9),
                SkeletonBox(height: 13),
                SizedBox(height: 9),
                SkeletonBox(width: 180, height: 13),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.factLoading,
            style: NekoFonts.monoLabel(12).copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _FactText extends StatelessWidget {
  const _FactText({required this.fact, super.key});

  final CatFact fact;

  @override
  Widget build(BuildContext context) {
    // El lector de pantalla recibe el texto completo de una vez; la maquina de
    // escribir es solo visual.
    return Semantics(
      liveRegion: true,
      label: fact.text,
      excludeSemantics: true,
      child: TypewriterText(
        fact.text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _FactMessage extends StatelessWidget {
  const _FactMessage({required this.text, required this.color, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

/// Escribe el texto caracter a caracter con un cursor de bloque.
class TypewriterText extends StatefulWidget {
  const TypewriterText(this.text, {this.style, super.key});

  final String text;
  final TextStyle? style;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: (widget.text.length * 14).clamp(350, 2000),
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _controller.value = 1;
    } else if (_controller.value == 0) {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = context.neko.purple;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final visible = (widget.text.length * _controller.value).round();
        final typing = _controller.isAnimating;
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: widget.text.substring(0, visible)),
              if (typing)
                TextSpan(
                  text: '▌',
                  style: TextStyle(color: cursorColor),
                ),
              // Lo que falta se reserva invisible para que la tarjeta no
              // cambie de alto mientras escribe.
              TextSpan(
                text: widget.text.substring(visible),
                style: const TextStyle(color: Colors.transparent),
              ),
            ],
          ),
          style: widget.style,
        );
      },
    );
  }
}
