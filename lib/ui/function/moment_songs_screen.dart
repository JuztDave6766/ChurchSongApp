import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/library_controller.dart';
import '../../domain/models.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';
import '../shared/song_sheet.dart';
import '../shared/song_tile.dart';

/// All songs that fit a specific moment of a celebration.
class MomentSongsScreen extends StatelessWidget {
  const MomentSongsScreen({
    super.key,
    required this.function,
    required this.moment,
  });

  final LiturgicalFunction function;
  final LiturgicalMoment moment;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final songs =
        library.songsForMoment(moment.id, functionId: function.id);
    final scheme = Theme.of(context).colorScheme;
    final hint = moment.hint(strings.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(function.label(strings.languageCode)),
      ),
      body: PageBody(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const SizedBox(height: 8),
            Text(
              moment.label(strings.languageCode),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            if (hint != null) ...[
              const SizedBox(height: 8),
              Text(
                hint,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              strings.songsForMoment(songs.length),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: scheme.secondary),
            ),
            const SizedBox(height: 22),
            if (songs.isEmpty)
              EmptyState(
                icon: Icons.music_off_rounded,
                title: strings.noSongsFound,
                body: strings.noSongsFoundHint,
              )
            else
              for (final song in songs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SongTile(
                    song: song,
                    onTap: () => showSongSheet(context, song),
                  ),
                ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
