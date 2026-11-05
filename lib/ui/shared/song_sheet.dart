import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../data/library_controller.dart';
import '../../data/settings_controller.dart';
import '../../domain/models.dart';
import 'premium.dart';
import 'tag_pill.dart';

Future<void> showSongSheet(BuildContext context, Song song) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _SongSheet(song: song),
  );
}

class _SongSheet extends StatelessWidget {
  const _SongSheet({required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final settings = context.watch<SettingsController>();
    final scheme = Theme.of(context).colorScheme;
    final tags = library.tagsFor(song);
    final isFavorite = library.isFavorite(song.id);
    final isDownloaded = library.isDownloaded(song.id);
    final isDownloading = library.isDownloading(song.id);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title(strings.languageCode),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 14,
                            runSpacing: 4,
                            children: [
                              if (song.author != null)
                                _Meta(
                                  icon: Icons.person_outline_rounded,
                                  label: song.author!,
                                ),
                              if (song.keySignature != null)
                                _Meta(
                                  icon: Icons.music_note_rounded,
                                  label: song.keySignature!,
                                ),
                              if (song.duration != null)
                                _Meta(
                                  icon: Icons.schedule_rounded,
                                  label:
                                      strings.minutesShort(song.duration!.inMinutes),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: strings.close,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [for (final tag in tags) TagPill(tag: tag)],
                ),
              ),
              const SizedBox(height: 18),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.lyricsLabel.toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 12),
                      ..._lyrics(context),
                      const SizedBox(height: 8),
                      Text(
                        strings.audioDemoNotice,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: scheme.outlineVariant)),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => library.toggleFavorite(song.id),
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: isFavorite ? scheme.secondary : null,
                      ),
                      label: Text(
                        isFavorite ? strings.favoriteRemoved : strings.favoritesOnly,
                      ),
                    ),
                    _DownloadAction(
                      song: song,
                      isDownloaded: isDownloaded,
                      isDownloading: isDownloading,
                      premium: settings.premiumUnlocked,
                      onDownload: () async {
                        if (!await ensurePremium(context)) return;
                        await library.downloadSong(song);
                      },
                      onRemove: () => library.removeDownload(song),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _lyrics(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final widgets = <Widget>[];
    var verse = 0;
    for (final section in song.sections) {
      if (section.kind == SectionKind.verse) verse++;
      final label = switch (section.kind) {
        SectionKind.verse => strings.sectionVerse(verse),
        SectionKind.chorus => strings.sectionChorus,
        SectionKind.bridge => strings.sectionBridge,
        SectionKind.response => strings.sectionResponse,
      };
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.secondary,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                section.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.65,
                      fontSize: 16.5,
                    ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}

class _DownloadAction extends StatelessWidget {
  const _DownloadAction({
    required this.song,
    required this.isDownloaded,
    required this.isDownloading,
    required this.premium,
    required this.onDownload,
    required this.onRemove,
  });

  final Song song;
  final bool isDownloaded;
  final bool isDownloading;
  final bool premium;
  final Future<void> Function() onDownload;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    if (isDownloading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2.4),
      );
    }

    if (isDownloaded) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.offline_pin_rounded, size: 18, color: scheme.tertiary),
          const SizedBox(width: 6),
          Text(
            strings.downloaded,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: scheme.tertiary),
          ),
          IconButton(
            tooltip: strings.remove,
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline_rounded, size: 19),
          ),
        ],
      );
    }

    return FilledButton.icon(
      onPressed: onDownload,
      icon: Icon(
        premium ? Icons.download_rounded : Icons.workspace_premium_rounded,
        size: 18,
      ),
      label: Text(strings.download),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.gold),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
