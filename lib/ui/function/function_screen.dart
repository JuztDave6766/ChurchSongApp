import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../data/library_controller.dart';
import '../../data/setlist_controller.dart';
import '../../data/sundays_service.dart';
import '../../domain/models.dart';
import '../shared/function_chooser.dart';
import '../setlists/setlist_detail_screen.dart';
import '../setlists/setlist_editor_screen.dart';
import '../shared/function_icon.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';
import '../shared/song_sheet.dart';
import '../shared/song_tile.dart';
import 'moment_songs_screen.dart';

/// Overview of a celebration: each moment with the number of suitable songs.
class FunctionScreen extends StatelessWidget {
  const FunctionScreen({
    super.key,
    required this.function,
    this.prayerVariant,
  });

  final LiturgicalFunction function;
  final PrayerVariant? prayerVariant;

  Future<void> _createSetlist(BuildContext context) async {
    final setlist = await Navigator.of(context).push<Setlist>(
      MaterialPageRoute<Setlist>(
        builder: (_) => SetlistEditorScreen(
          function: function,
          prayerVariant: prayerVariant,
        ),
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
                      if (prayerVariant != null) ...[
                        const SizedBox(height: 6),
                        Chip(
                          label: Text(prayerVariant!.label(strings.languageCode)),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
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
            if (function.id == 'messa') ...[
              const SizedBox(height: 26),
              const _SundayReadingsCard(),
            ],
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

/// Sunday readings (verified Year A calendar) with themed song suggestions for the
/// psalm, the alleluia verse and communion, plus one-tap setlist creation.
class _SundayReadingsCard extends StatelessWidget {
  const _SundayReadingsCard();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final sundays = context.watch<SundaysController>();
    final library = context.watch<LibraryController>();

    if (!sundays.loaded) return const SizedBox.shrink();
    final reading = sundays.forDate(DateTime.now());
    if (reading == null) return const SizedBox.shrink();
    if (!reading.hasReadings) return const SizedBox.shrink();

    final suggestions = reading.buildSuggestions(library);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.primaryContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                size: 20,
                color: scheme.secondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.sundaysCardTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Text(
                '${reading.date.day}/${reading.date.month}/${reading.date.year}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            reading.title(strings.languageCode),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _ReadingRow(
            label: strings.firstReading,
            citation: reading.firstReading,
          ),
          if (reading.psalmCitation != null) ...[
            _ReadingRow(
              label: strings.psalmReading,
              citation: reading.psalmCitation,
            ),
            if (reading.psalmResponse != null)
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${strings.psalmResponseLabel}:',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: scheme.secondary),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '“${reading.psalmResponse!}”',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          _ReadingRow(
            label: strings.secondReading,
            citation: reading.secondReading,
          ),
          _ReadingRow(label: strings.gospel, citation: reading.gospel),
          if (suggestions.psalmSongs.isNotEmpty) ...[
            const SizedBox(height: 10),
            _SuggestionBlock(
              title: strings.suggestedPsalm,
              songs: suggestions.psalmSongs,
            ),
          ],
          if (suggestions.alleluiaSongs.isNotEmpty) ...[
            const SizedBox(height: 6),
            _SuggestionBlock(
              title: strings.suggestedAlleluia,
              songs: suggestions.alleluiaSongs,
            ),
          ],
          if (suggestions.communionSongs.isNotEmpty) ...[
            const SizedBox(height: 6),
            _SuggestionBlock(
              title: strings.suggestedCommunion,
              songs: suggestions.communionSongs,
            ),
          ],
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () =>
                    _createSundaySetlist(context, reading, suggestions),
                icon: const Icon(Icons.queue_music_rounded, size: 19),
                label: Text(strings.createSundaySetlist),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _createSundaySetlist(
    BuildContext context,
    SundayReading reading,
    SundaySuggestions suggestions,
  ) async {
    final strings = AppStrings.of(context);
    final controller = context.read<SetlistController>();
    final language = strings.languageCode;
    final now = DateTime.now();
    final setlist = controller.create(
      name: '${reading.title(language)} · ${now.day}/${now.month}',
      functionId: 'messa',
      items: [
        for (var i = 0; i < suggestions.items.length; i++)
          SetlistItem(
            id: 'si_${now.microsecondsSinceEpoch}_$i',
            songId: suggestions.items[i].songId,
            momentId: suggestions.items[i].momentId,
          ),
      ],
    );
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SetlistDetailScreen(setlistId: setlist.id),
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  const _ReadingRow({required this.label, required this.citation});

  final String label;
  final String? citation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (citation == null || citation!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: scheme.secondary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              citation!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionBlock extends StatelessWidget {
  const _SuggestionBlock({required this.title, required this.songs});

  final String title;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 1,
              ),
        ),
        const SizedBox(height: 4),
        for (final song in songs.take(3))
          SongTile(
            song: song,
            onTap: () => showSongSheet(context, song),
          ),
      ],
    );
  }
}
