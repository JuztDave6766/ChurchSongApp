import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../data/library_controller.dart';
import '../../data/youtube_service.dart';
import '../../domain/models.dart';
import '../library/song_editor_screen.dart';
import '../library/song_print_screen.dart';
import 'chord_text.dart';
import 'tag_pill.dart';

Future<void> showSongSheet(BuildContext context, Song song) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _SongSheet(songId: song.id),
  );
}

class _SongSheet extends StatelessWidget {
  const _SongSheet({required this.songId});

  final String songId;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final song = library.songById(songId);
    if (song == null) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final tags = library.tagsFor(song);
    final isFavorite = library.isFavorite(song.id);
    final overridden = library.isOverridden(song.id);

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
                          if (song.version != null &&
                              song.version!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              song.version!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: scheme.secondary),
                            ),
                          ],
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
                              if (overridden)
                                _Meta(
                                  icon: Icons.edit_note_rounded,
                                  label: strings.locallyEdited,
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
                  children: [
                    for (final tag in tags) TagPill(tag: tag),
                    Chip(
                      label: Text(strings.licenseName(song.license)),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: scheme.onSecondaryContainer),
                      backgroundColor: scheme.secondaryContainer,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (song.license == SongLicense.copyrighted)
                        _CopyrightNotice(song: song)
                      else ...[
                        Text(
                          strings.lyricsLabel.toUpperCase(),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 12),
                        ..._lyrics(context, song),
                        if (song.sourceNote != null &&
                            song.sourceNote!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            '${strings.personalSourceLabel}: ${song.sourceNote}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (song.sheetUrl != null &&
                            song.sheetUrl!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _SheetLink(url: song.sheetUrl!),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: scheme.outlineVariant)),
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
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
                        isFavorite
                            ? strings.favoriteRemoved
                            : strings.favoritesOnly,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _edit(context, song),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(strings.editSong),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SongPrintScreen(songId: song.id),
                        ),
                      ),
                      icon: const Icon(Icons.print_outlined, size: 18),
                      label: Text(strings.printSong),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _searchChords(context, song),
                      icon: const Icon(Icons.search_rounded, size: 18),
                      label: Text(strings.chordsSearch),
                    ),
                    _TrackAction(song: song),
                    if (overridden)
                      TextButton.icon(
                        onPressed: () => library.resetOverride(song.id),
                        icon: const Icon(Icons.restart_alt_rounded, size: 18),
                        label: Text(strings.restoreOriginal),
                      ),
                    if (song.isUserSong)
                      IconButton(
                        tooltip: strings.deleteSong,
                        onPressed: () => _delete(context, song),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 19,
                          color: scheme.error,
                        ),
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

  Future<void> _searchChords(BuildContext context, Song song) async {
    final query = Uri.encodeComponent(
      '${song.title('it')} ${song.author ?? ''} accordi'.trim(),
    );
    final uri = Uri.parse('https://www.google.com/search?q=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _edit(BuildContext context, Song song) async {
    await Navigator.of(context).push<Song>(
      MaterialPageRoute<Song>(
        builder: (_) => SongEditorScreen(existing: song),
      ),
    );
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _delete(BuildContext context, Song song) async {
    final strings = AppStrings.of(context);
    final library = context.read<LibraryController>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.deleteSong),
        content: Text(strings.deleteSongQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await library.deleteUserSong(song.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  List<Widget> _lyrics(BuildContext context, Song song) {
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
              ChordProText(
                text: section.text,
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

/// Opens a verified video when available, otherwise searches YouTube.
class _TrackAction extends StatelessWidget {
  const _TrackAction({required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    if (song.youtubeId != null && song.youtubeId!.isNotEmpty) {
      return FilledButton.icon(
        onPressed: () async {
          final url = YouTubeService.watchUrl(song.youtubeId!);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
        icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
        label: Text(strings.watchOnYoutube),
      );
    }

    return OutlinedButton.icon(
      onPressed: () async {
        final query = [song.title('it'), song.author]
            .whereType<String>()
            .where((part) => part.trim().isNotEmpty)
            .join(' ');
        final url = YouTubeService.searchUrl(query);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      icon: const Icon(Icons.search_rounded, size: 18),
      label: Text(strings.searchOnYoutube),
    );
  }
}

class _SheetLink extends StatelessWidget {
  const _SheetLink({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return OutlinedButton.icon(
      onPressed: () async {
        final uri = Uri.tryParse(url);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      icon: const Icon(Icons.description_rounded, size: 18),
      label: Text(strings.openSheet),
    );
  }
}

/// Banner shown instead of bundled lyrics for copyrighted repertoire.
class _CopyrightNotice extends StatelessWidget {
  const _CopyrightNotice({required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.tertiaryContainer, width: 0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.copyright_rounded,
                size: 18,
                color: scheme.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                strings.textProtectedTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            song.sourceNote ?? strings.textProtectedBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (song.sheetUrl != null && song.sheetUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SheetLink(url: song.sheetUrl!),
          ],
        ],
      ),
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
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
