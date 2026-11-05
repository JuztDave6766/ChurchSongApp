import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../data/library_controller.dart';
import '../../domain/models.dart';
import '../setlists/setlist_detail_screen.dart';
import '../setlists/setlist_editor_screen.dart';
import '../shared/function_icon.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';
import 'moment_songs_screen.dart';

/// Overview of a celebration: each moment with the number of suitable songs.
class FunctionScreen extends StatelessWidget {
  const FunctionScreen({super.key, required this.function});

  final LiturgicalFunction function;

  Future<void> _createSetlist(BuildContext context) async {
    final setlist = await Navigator.of(context).push<Setlist>(
      MaterialPageRoute<Setlist>(
        builder: (_) => SetlistEditorScreen(function: function),
      ),
    );
    if (setlist != null && context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SetlistDetailScreen(setlistId: setlist.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final scheme = Theme.of(context).colorScheme;
    final songCount = library.songs
        .where((song) => song.hasTag(function.id))
        .length;

    return Scaffold(
      appBar: AppBar(),
      body: PageBody(
        maxWidth: 900,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            Row(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    functionIcon(function.iconName),
                    color: scheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        function.label(strings.languageCode),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        strings.songCount(songCount),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: scheme.secondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              function.description(strings.languageCode),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () => _createSetlist(context),
              icon: const Icon(Icons.playlist_add_rounded),
              label: Text(strings.createSetlist),
            ),
            const SizedBox(height: 30),
            SectionHeader(
              title: strings.celebrationMoments,
              padding: const EdgeInsets.only(bottom: 12),
            ),
            for (var index = 0; index < function.moments.length; index++)
              _MomentCard(
                index: index,
                moment: function.moments[index],
                songCount: library.countForMoment(
                  function.moments[index].id,
                  functionId: function.id,
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => MomentSongsScreen(
                      function: function,
                      moment: function.moments[index],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MomentCard extends StatelessWidget {
  const _MomentCard({
    required this.index,
    required this.moment,
    required this.songCount,
    required this.onTap,
  });

  final int index;
  final LiturgicalMoment moment;
  final int songCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final hint = moment.hint(strings.languageCode);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: scheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              moment.label(strings.languageCode),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (moment.optional) ...[
                            const SizedBox(width: 8),
                            Text(
                              strings.optional,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ],
                      ),
                      if (hint != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          hint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$songCount',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: songCount == 0
                                ? scheme.onSurfaceVariant
                                : scheme.primary,
                          ),
                    ),
                    Text(
                      strings.songCount(songCount).split(' ').last,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
