import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/library_controller.dart';
import '../../data/setlist_controller.dart';
import '../../data/settings_controller.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';
import '../shared/song_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _version = '0.1.0';

  Future<void> _resetData(BuildContext context) async {
    final strings = AppStrings.of(context);
    final setlists = context.read<SetlistController>();
    final library = context.read<LibraryController>();
    final messenger = ScaffoldMessenger.of(context);
    final scheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.resetData),
        content: Text(strings.resetDataQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            ),
            child: Text(strings.reset),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await setlists.restoreDemoData();
    await library.resetUserData();
    messenger.showSnackBar(
      SnackBar(content: Text(strings.dataReset)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final settings = context.watch<SettingsController>();
    final library = context.watch<LibraryController>();
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: PageBody(
        maxWidth: 860,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            const SizedBox(height: 10),
            Text(
              strings.settingsTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 4),
            Text(
              strings.settingsSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 26),

            _SettingsSection(
              title: strings.language,
              child: _Card(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: 'it',
                        label: Text(strings.italian),
                      ),
                      ButtonSegment(
                        value: 'en',
                        label: Text(strings.english),
                      ),
                    ],
                    selected: {settings.value.languageCode},
                    onSelectionChanged: (value) =>
                        settings.setLanguage(value.first),
                  ),
                ),
              ),
            ),

            _SettingsSection(
              title: strings.appearance,
              child: _Card(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<ThemeMode>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: const Icon(Icons.brightness_auto_rounded, size: 18),
                        label: Text(strings.systemTheme),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: const Icon(Icons.light_mode_rounded, size: 18),
                        label: Text(strings.lightTheme),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: const Icon(Icons.dark_mode_rounded, size: 18),
                        label: Text(strings.darkTheme),
                      ),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (value) =>
                        settings.setThemeMode(value.first),
                  ),
                ),
              ),
            ),

            _SettingsSection(
              title: strings.premium,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.secondaryContainer,
                      scheme.secondaryContainer.withValues(alpha: 0.55),
                    ],
                  ),
                  border: Border.all(
                    color: scheme.secondary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: scheme.secondary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        color: scheme.onSecondaryContainer,
                        size: 23,
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
                                  settings.premiumUnlocked
                                      ? strings.premiumActive
                                      : strings.premiumInactive,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (settings.premiumUnlocked)
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: scheme.tertiary,
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            strings.premiumDescription,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: scheme.onSecondaryContainer
                                      .withValues(alpha: 0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Switch(
                      value: settings.premiumUnlocked,
                      onChanged: settings.setPremiumUnlocked,
                    ),
                  ],
                ),
              ),
            ),

            _SettingsSection(
              title: strings.offline,
              child: _Card(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
                      child: Text(
                        strings.offlineDescription,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                      child: Row(
                        children: [
                          Icon(Icons.download_done_rounded,
                              size: 17, color: scheme.tertiary),
                          const SizedBox(width: 8),
                          Text(
                            '${strings.downloadedSongs}: '
                            '${library.downloadedSongs.length}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    if (library.downloadedSongs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                        child: Text(
                          strings.noDownloads,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      )
                    else ...[
                      Divider(height: 1, color: scheme.outlineVariant),
                      for (final song in library.downloadedSongs)
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            onTap: () => showSongSheet(context, song),
                            leading: Icon(
                              Icons.music_note_rounded,
                              size: 19,
                              color: scheme.secondary,
                            ),
                            title: Text(
                              song.title(strings.languageCode),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              song.author ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              tooltip: strings.removeDownload,
                              onPressed: () => library.removeDownload(song),
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: 19,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),

            _SettingsSection(
              title: strings.sync,
              child: _Card(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Icon(Icons.cloud_queue_rounded,
                        color: scheme.onSurfaceVariant),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.sync,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            strings.syncDescription,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        strings.syncComingSoon,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _SettingsSection(
              title: strings.about,
              child: _Card(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AppMark(size: 34),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.appName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${strings.version} $_version',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.aboutDescription,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _resetData(context),
                      icon: const Icon(Icons.restart_alt_rounded, size: 18),
                      label: Text(strings.resetData),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.error,
                        side: BorderSide(
                          color: scheme.error.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.2,
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: child,
    );
  }
}
