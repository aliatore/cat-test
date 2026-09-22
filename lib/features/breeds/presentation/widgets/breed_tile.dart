import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_theme.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/design_system/widgets/cat_avatar.dart';
import 'package:cat_directory_app/design_system/widgets/neon_panel.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

String breedHeroTag(Breed breed) => 'breed-avatar-${breed.slug}';

CatAvatarSpec avatarSpecFor(Breed breed) => CatAvatarSpec.fromBreed(
  seed: breed.slug,
  pattern: breed.pattern,
  coat: breed.coat,
);

/// Fila del directorio. Altura fija (una linea de nombre y otra de pais) para
/// que la lista pueda calcular su extension sin medir cada elemento.
class BreedTile extends StatelessWidget {
  const BreedTile({
    required this.breed,
    required this.number,
    this.query = '',
    this.onTap,
    this.hero = true,
    super.key,
  });

  /// Solo para medir la altura de fila con la escala de texto actual.
  static const prototype = BreedTile(
    breed: Breed(name: 'Prototype', country: 'Prototype'),
    number: 0,
    hero: false,
  );

  final Breed breed;
  final int number;
  final String query;
  final VoidCallback? onTap;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final country = breed.country ?? l10n.unknownCountry;

    Widget avatar = CatAvatar(spec: avatarSpecFor(breed), size: 50);
    if (hero) avatar = Hero(tag: breedHeroTag(breed), child: avatar);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      // excludeSemantics tambien descarta el onTap del InkWell de adentro:
      // la accion se declara aqui para que TalkBack/VoiceOver puedan activarla.
      child: Semantics(
        button: true,
        label: l10n.breedTileSemantics(breed.name, country),
        onTap: onTap,
        onTapHint: l10n.breedTileHint,
        excludeSemantics: true,
        child: NeonPanel(
          padding: EdgeInsets.zero,
          accent: colors.outline,
          brackets: false,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: nekoShape,
              onTap: onTap,
              splashColor: colors.cyan.withValues(alpha: 0.12),
              highlightColor: colors.cyan.withValues(alpha: 0.06),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Row(
                  children: [
                    avatar,
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _HighlightedName(
                            name: breed.name,
                            query: query,
                            style: theme.textTheme.titleMedium!,
                            highlight: colors.magenta,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: colors.cyan,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  country.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: NekoFonts.monoLabel(
                                    12.5,
                                  ).copyWith(color: colors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '#${number.toString().padLeft(3, '0')}',
                          style: NekoFonts.monoLabel(
                            11,
                          ).copyWith(color: colors.textMuted),
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colors.textMuted,
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
    );
  }
}

/// Resalta la parte del nombre que coincide con la busqueda.
class _HighlightedName extends StatelessWidget {
  const _HighlightedName({
    required this.name,
    required this.query,
    required this.style,
    required this.highlight,
  });

  final String name;
  final String query;
  final TextStyle style;
  final Color highlight;

  @override
  Widget build(BuildContext context) {
    final start = query.isEmpty
        ? -1
        : name.toLowerCase().indexOf(query.toLowerCase());
    if (start < 0) {
      return Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }
    final end = start + query.length;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: name.substring(0, start)),
          TextSpan(
            text: name.substring(start, end),
            style: TextStyle(
              color: highlight,
              decoration: TextDecoration.underline,
              decorationColor: highlight,
            ),
          ),
          TextSpan(text: name.substring(end)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}

/// Numero de la raza en el directorio completo, aunque la lista este filtrada.
int breedNumber(BreedsState state, int visibleIndex) {
  if (!state.isSearching) return visibleIndex + 1;
  final slug = state.visible[visibleIndex].slug;
  return state.breeds.indexWhere((b) => b.slug == slug) + 1;
}
