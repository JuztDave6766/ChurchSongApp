import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../domain/models.dart';

/// Small coloured pill used for every tag in the app.
class TagPill extends StatelessWidget {
  const TagPill({
    super.key,
    required this.tag,
    this.selected = false,
    this.onTap,
    this.dense = false,
  });

  final Tag tag;
  final bool selected;
  final VoidCallback? onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = AppColors.tagColor(tag.kind, scheme);
    final background = selected
        ? color
        : color.withValues(alpha: 0.10);
    final foreground = selected ? _onColor(color) : color;

    final pill = Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 9 : 11,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? color : color.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        tag.label(Localizations.localeOf(context).languageCode),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              fontSize: dense ? 10.5 : 11.5,
            ),
      ),
    );

    if (onTap == null) return pill;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: pill,
    );
  }

  Color _onColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.55 ? const Color(0xFF201A2E) : Colors.white;
  }
}
