import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/strings.dart';
import '../../data/backup_file.dart';
import '../../data/library_controller.dart';
import '../../data/setlist_controller.dart';
import '../../data/settings_controller.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _version = '0.1.0';
  static const _repo = 'https://github.com/JuztDave6766/ChurchSongApp';

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

  Map<String, dynamic> _backupPayload(BuildContext context) {
    final library = context.read<LibraryController>();
    final setlists = context.read<SetlistController>();
    final settings = context.read<SettingsController>();
    return {
      'app': 'ChurchSongApp',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': settings.value.toJson(),
      'library': library.toBackup(),
      'setlists': setlists.toBackup(),
    };
  }

  String _encodeBackup(BuildContext context) => const JsonEncoder.withIndent(
        '  ',
      ).convert(_backupPayload(context));

  Future<void> _exportData(BuildContext context) async {
    final strings = AppStrings.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final content = _encodeBackup(context);
    final saved = await saveBackupFile(content, 'churchsong-backup.json');
    if (saved) {
      messenger.showSnackBar(
        SnackBar(content: Text(strings.backupExported)),
      );
      return;
    }
    // Non-web platforms: the backup is copied to the clipboard and shown so
    // it can be saved manually.
    await Clipboard.setData(ClipboardData(text: content));
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text('${strings.backupExported} · ${strings.copyData}')),
    );
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.exportData),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: SelectableText(
              content,
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.close),
          ),
        ],
      ),
    );
  }

  Future<void> _importData(BuildContext context) async {
    final content = await pickBackupFile();
    if (!context.mounted) return;
    if (content != null) {
      await _applyBackup(context, content);
      return;
    }
    await _importFromDialog(context);
  }

  Future<void> _importFromDialog(BuildContext context) async {
    final strings = AppStrings.of(context);
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.importData),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.backupDescription,
                style: Theme.of(dialogContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                minLines: 6,
                maxLines: 12,
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                decoration: InputDecoration(
                  labelText: strings.pasteData,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final data = await Clipboard.getData(Clipboard.kTextPlain);
              if (data?.text != null) controller.text = data!.text!;
            },
            child: Text(strings.pasteData),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(strings.importData),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && result.trim().isNotEmpty && context.mounted) {
      await _applyBackup(context, result);
    }
  }

  Future<void> _applyBackup(BuildContext context, String content) async {
    final strings = AppStrings.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final library = context.read<LibraryController>();
    final setlists = context.read<SetlistController>();
    final settings = context.read<SettingsController>();

    try {
      final decoded = jsonDecode(content);
      if (decoded is! Map<String, dynamic> ||
          decoded['app'] != 'ChurchSongApp') {
        throw const FormatException();
      }
      final rawLibrary = decoded['library'];
      final rawSetlists = decoded['setlists'];
      if (rawLibrary is! Map<String, dynamic> ||
          rawSetlists is! Map<String, dynamic>) {
        throw const FormatException();
      }
      await library.restoreBackup(rawLibrary);
      await setlists.restoreBackup(rawSetlists);
      final rawSettings = decoded['settings'];
      if (rawSettings is Map<String, dynamic>) {
        final language = rawSettings['languageCode'];
        final theme = rawSettings['themeMode'];
        if (language is String) await settings.setLanguage(language);
        if (theme is String) {
          final mode = switch (theme) {
            'light' => ThemeMode.light,
            'dark' => ThemeMode.dark,
            _ => ThemeMode.system,
          };
          await settings.setThemeMode(mode);
        }
      }
      messenger.showSnackBar(
        SnackBar(content: Text(strings.backupImported)),
      );
    } on Object {
      messenger.showSnackBar(
        SnackBar(content: Text(strings.backupInvalid)),
      );
    }
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _showCredits(BuildContext context) async {
    final strings = AppStrings.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.creditsTitle),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Text(
              strings.creditsBody,
              style: Theme.of(dialogContext).textTheme.bodyMedium,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.close),
          ),
          TextButton(
            onPressed: () => _openUrl(context, '$_repo/issues'),
            child: Text(strings.takedown),
          ),
        ],
      ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    strings.settingsTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                _DemoBadge(label: strings.demoBadge),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              strings.settingsSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 22),

            _LocalDataBanner(
              title: strings.localDataTitle,
              body: strings.localDataBody,
            ),
            const SizedBox(height: 22),

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
                        icon:
                            const Icon(Icons.brightness_auto_rounded, size: 18),
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
              title: strings.backupTitle,
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.backupDescription,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${strings.songCount(library.songs.length)} · '
                      '${strings.localDataTitle}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        FilledButton.icon(
                          onPressed: () => _exportData(context),
                          icon: const Icon(Icons.file_download_outlined,
                              size: 18),
                          label: Text(strings.exportData),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _importData(context),
                          icon: const Icon(Icons.file_upload_outlined,
                              size: 18),
                          label: Text(strings.importData),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            _SettingsSection(
              title: strings.about,
              child: _Card(
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
                                '${strings.version} $_version · ${strings.demoBadge}',
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
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _showCredits(context),
                          icon: const Icon(Icons.copyright_rounded, size: 18),
                          label: Text(strings.openCredits),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _openUrl(context, '$_repo/issues'),
                          icon: const Icon(Icons.flag_outlined, size: 18),
                          label: Text(strings.takedown),
                        ),
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

class _DemoBadge extends StatelessWidget {
  const _DemoBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.secondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.public_rounded, size: 13, color: scheme.onSecondaryContainer),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _LocalDataBanner extends StatelessWidget {
  const _LocalDataBanner({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.tertiaryContainer),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, size: 20, color: scheme.tertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
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
