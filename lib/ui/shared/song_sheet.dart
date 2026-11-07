import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../data/library_controller.dart';
import '../../data/settings_controller.dart';
import '../../data/youtube_service.dart';
import '../../domain/models.dart';
import '../library/song_editor_screen.dart';
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
              if (song.youtubeId != null && song.youtubeId!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: _YoutubePreview(videoId: song.youtubeId!),
                ),
              ],
              if (song.sheetUrl != null && song.sheetUrl!.isNotEmpty &&
                  song.youtubeId == null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: _SheetLink(url: song.sheetUrl!),
                ),
              ],
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
                        ..._lyrics(context),
                        if (song.license == SongLicense.personalUse &&
                            song.sourceNote != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${strings.personalSourceLabel}: ${song.sourceNote}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (song.sheetUrl != null &&
                            song.sheetUrl!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _SheetLink(url: song.sheetUrl!),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          strings.audioDemoNotice,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: scheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
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
                    if (song.isUserSong) ...[
                      OutlinedButton.icon(
                        onPressed: () async {
                          final closed = await Navigator.of(context).push<bool>(
                            MaterialPageRoute<bool>(
                              builder: (_) =>
                                  SongEditorScreen(existing: song),
                            ),
                          );
                          if (closed == true && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(strings.editSong),
                      ),
                      IconButton(
                        tooltip: strings.deleteSong,
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text(strings.deleteSong),
                              content: Text(strings.deleteSongQuestion),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext)
                                      .pop(false),
                                  child: Text(AppStrings.of(context).cancel),
                                ),
                               FilledButton(
                                  onPressed: () => Navigator.of(dialogContext)
                                      .pop(true),
                                  child: Text(strings.delete),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await library.deleteUserSong(song.id);
                          }
                        },
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 19,
                          color: scheme.error,
                        ),
                      ),
                    ],
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

/// Tap-to-play YouTube preview: a thumbnail with a play badge; opens the
/// video in an external browser/application.
class _YoutubePreview extends StatelessWidget {
  const _YoutubePreview({required this.videoId});

  final String videoId;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () async {
          final url = YouTubeService.watchUrl(videoId);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 92,
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.play_circle_fill_rounded,
                size: 44,
                color: scheme.error.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.youtubeLabel,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      strings.watchOnYoutube,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 22),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
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

class _Meta extends StatelessWidget {  const _Meta({required this.icon, required this.label});

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
