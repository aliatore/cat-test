import 'package:cat_directory_app/design_system/theme/neko_colors.dart';
import 'package:cat_directory_app/design_system/theme/neko_typography.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Buscador con estilo de terminal. Manda cada pulsacion al bloc; el debounce
/// vive alli, no aqui, para poder probarlo sin widgets.
class BreedSearchField extends StatefulWidget {
  const BreedSearchField({super.key});

  @override
  State<BreedSearchField> createState() => _BreedSearchFieldState();
}

class _BreedSearchFieldState extends State<BreedSearchField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    context.read<BreedsBloc>().add(BreedsQueryChanged(value));
    setState(() {});
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neko;
    final l10n = context.l10n;
    final focused = _focus.hasFocus;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.surface.withValues(alpha: 0.94),
        shape: BeveledRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          side: BorderSide(
            color: focused ? colors.cyan : colors.outline,
            width: focused ? 1.4 : 1,
          ),
        ),
        shadows: focused
            ? [
                BoxShadow(
                  color: colors.cyan.withValues(alpha: 0.3 * colors.glow),
                  blurRadius: 16,
                  spreadRadius: -6,
                ),
              ]
            : null,
      ),
      child: Semantics(
        label: l10n.searchLabel,
        child: TextField(
          controller: _controller,
          focusNode: _focus,
          onChanged: _onChanged,
          onTapOutside: (_) => _focus.unfocus(),
          onSubmitted: (_) => _focus.unfocus(),
          textInputAction: TextInputAction.search,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor: colors.cyan,
          style: NekoFonts.monoLabel(
            15.5,
          ).copyWith(color: colors.textPrimary, letterSpacing: 0.6),
          decoration: InputDecoration(
            filled: false,
            isDense: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            hintText: l10n.searchHint,
            hintStyle: NekoFonts.monoLabel(
              15,
            ).copyWith(color: colors.textMuted),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: ExcludeSemantics(
                child: Text(
                  '>',
                  style: NekoFonts.monoLabel(
                    18,
                  ).copyWith(color: colors.cyan, height: 1),
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: l10n.searchClear,
                    onPressed: _clear,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
