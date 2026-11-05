import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../data/library_controller.dart';
import '../../domain/models.dart';
import 'tag_pill.dart';

/// Row used in every song list in the app.
class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.trailing,
    this.leading,
    this.showFavorite = true,
    this.selected = false,
    this.dense = false,
  });

  final Song song;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;
  final bool showFavorite;
  final bool selected;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final scheme = Theme.of(context).colorScheme;
    final tags = library.tagsFor(song)
      ..sort((a, b) => a.kind.index.compareTo(b.kind.index));
    final visibleTags = tags.take(dense ? 2 : 3).toList();
    final isFavorite = library.isFavorite(song.id);
    final isDownloaded = library.isDownloaded(song.id);

    return Material(
      color: selected
          ? scheme.primaryContainer.withValues(alpha: 0.55)
          : scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 14 : 16,
            vertical: dense ? 12 : 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            song.title(strings.languageCode),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: dense ? 18 : 20),
                          ),
                        ),
                        if (isDownloaded) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.offline_pin_rounded,
                            size: 16,
                            color: scheme.tertiary,
                          ),
                        ],
                      ],
                    ),
                    if (song.author case final author?) ...[
                      const SizedBox(height: 2),
                      Text(
                        author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (!dense && visibleTags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final tag in visibleTags)
                            TagPill(tag: tag, dense: true),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (showFavorite)
                IconButton(
                  tooltip: strings.favoritesOnly,
                  onPressed: () => library.toggleFavorite(song.id),
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite ? scheme.secondary : scheme.onSurfaceVariant,
                    size: 21,
                  ),
                ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact search result used inside the song picker.
class SongPickerTile extends StatelessWidget {
  const SongPickerTile({
    super.key,
    required this.song,
    required this.selected,
    required this.onToggle,
  });

  final Song song;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.primaryContainer.withValues(alpha: 0.5)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? scheme.primary : scheme.outline,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title(strings.languageCode),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (song.author case final author?)
                      Text(
                        author,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              if (song.keySignature case final key?)
                Text(
                  key,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.gold,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
