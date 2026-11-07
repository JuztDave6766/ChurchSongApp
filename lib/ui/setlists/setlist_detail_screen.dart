import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../data/library_controller.dart';
import '../../data/setlist_controller.dart';
import '../../domain/catalog.dart';
import '../../domain/models.dart';
import '../event/event_screen.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';
import '../shared/song_sheet.dart';
import '../shared/song_tile.dart';
import 'setlist_editor_screen.dart';
import 'song_picker_sheet.dart';

class SetlistDetailScreen extends StatefulWidget {
  const SetlistDetailScreen({super.key, required this.setlistId});

  final String setlistId;

  @override
  State<SetlistDetailScreen> createState() => _SetlistDetailScreenState();
}

class _SetlistDetailScreenState extends State<SetlistDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final controller = context.watch<SetlistController>();
    final library = context.watch<LibraryController>();
    final setlist = controller.byId(widget.setlistId);

    if (setlist == null) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.setlistDetail)),
        body: EmptyState(
          icon: Icons.playlist_remove_rounded,
          title: strings.noSetlistsHome,
          body: strings.emptySetlistsBody,
        ),
      );
    }

    final function = kFunctionsById[setlist.functionId];
    final scheme = Theme.of(context).colorScheme;
    final validItems = setlist.items
        .where((item) => library.songById(item.songId) != null)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.setlistDetail),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                await Navigator.of(context).push(
                  MaterialPageRoute<Setlist>(
                    builder: (_) => SetlistEditorScreen(
                      function: function ?? kFunctions.first,
                      existing: setlist,
                    ),
                  ),
                );
              } else if (value == 'delete') {
                final confirmed = await _confirmDelete(context, strings);
                if (confirmed == true && context.mounted) {
                  await context.read<SetlistController>().delete(setlist.id);
                  if (context.mounted) Navigator.of(context).pop();
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(strings.editSetlist),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline_rounded,
                      color: scheme.error),
                  title: Text(
                    strings.deleteSetlist,
                    style: TextStyle(color: scheme.error),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: PageBody(
        maxWidth: 900,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const SizedBox(height: 6),
            _HeroCard(
              setlist: setlist,
              function: function,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<Setlist>(
                      builder: (_) => SetlistEditorScreen(
                        function: function ?? kFunctions.first,
                        existing: setlist,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(strings.editSetlist),
                ),
              ],
            ),
            const SizedBox(height: 26),
            if (validItems.isEmpty)
              EmptyState(
                icon: Icons.music_note_rounded,
                title: strings.noSongsYet,
                body: strings.emptyMoment,
                actionLabel: strings.addSongs,
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute<Setlist>(
                    builder: (_) => SetlistEditorScreen(
                      function: function ?? kFunctions.first,
                      existing: setlist,
                    ),
                  ),
                ),
              )
            else ...[
              SectionHeader(
                title: strings.celebrationMoments,
                padding: const EdgeInsets.only(bottom: 12),
              ),
              ..._momentSections(context, setlist, function, library),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton.icon(
            onPressed: validItems.isEmpty
                ? null
                : () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => EventScreen(setlist: setlist),
                      ),
                    ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              '${strings.startCelebration} · ${strings.songCount(validItems.length)}',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _replaceSong(
    BuildContext context,
    Setlist setlist,
    SetlistItem item,
    LiturgicalFunction? function,
  ) async {
    final strings = AppStrings.of(context);
    final controller = context.read<SetlistController>();
    if (function == null) return;
    final moment = function.momentById(item.momentId ?? '') ?? function.moments.first;
    final picked = await showSongPicker(
      context,
      function: function,
      moment: moment,
      excludedSongIds: {item.songId},
    );
    if (picked == null || picked.isEmpty || !context.mounted) return;
    final replacement = picked.first;
    final updatedItems = setlist.items
        .map((entry) => entry.id == item.id
            ? SetlistItem(
                id: entry.id,
                songId: replacement.id,
                momentId: entry.momentId,
                note: entry.note,
              )
            : entry)
        .toList();
    final now = DateTime.now();
    await controller.save(
      setlist.copyWith(items: updatedItems, updatedAt: now),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.replaceSong)),
    );
  }

  List<Widget> _momentSections(
    BuildContext context,
    Setlist setlist,
    LiturgicalFunction? function,
    LibraryController library,
  ) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final widgets = <Widget>[];
    final knownMoments = function?.moments.map((moment) => moment.id).toSet() ??
        <String>{};

    for (final moment in function?.moments ?? const <LiturgicalMoment>[]) {
      final items =
          setlist.items.where((item) => item.momentId == moment.id).toList();
      if (items.isEmpty) continue;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 6),
          child: Row(
            children: [
              Container(
                height: 7,
                width: 7,
                decoration: BoxDecoration(
                  color: scheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                moment.label(strings.languageCode).toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      letterSpacing: 1.1,
                      color: scheme.secondary,
                    ),
              ),
              const Spacer(),
              Text(
                strings.songCount(items.length),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
      for (final item in items) {
        final song = library.songById(item.songId);
        if (song == null) continue;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SongTile(
              song: song,
              dense: true,
              showFavorite: false,
              onTap: () => showSongSheet(context, song),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: strings.replaceSong,
                      icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                      onPressed: () => _replaceSong(context, setlist, item, function),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      widgets.add(const SizedBox(height: 10));
    }

    final unassigned = setlist.items
        .where((item) => !knownMoments.contains(item.momentId))
        .toList();
    if (unassigned.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            strings.songsLabel.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.1,
                  color: scheme.secondary,
                ),
          ),
        ),
      );
      for (final item in unassigned) {
        final song = library.songById(item.songId);
        if (song == null) continue;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SongTile(
              song: song,
              dense: true,
              showFavorite: false,
              onTap: () => showSongSheet(context, song),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  Future<bool?> _confirmDelete(BuildContext context, AppStrings strings) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.deleteSetlist),
        content: Text(strings.deleteSetlistQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.setlist,
    required this.function,
  });

  final Setlist setlist;
  final LiturgicalFunction? function;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final brightness = Theme.of(context).brightness;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient(brightness),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -40,
            top: -60,
            child: Glow(size: 220, color: AppColors.goldSoft, opacity: 0.28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const AppMark(size: 28, onDark: true),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    function?.label(strings.languageCode).toUpperCase() ??
                        setlist.functionId.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.goldSoft,
                          letterSpacing: 1.4,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                setlist.name,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _hint(
                    context,
                    Icons.library_music_rounded,
                    strings.songCount(setlist.songCount),
                  ),
                  _hint(
                    context,
                    Icons.event_rounded,
                    '${setlist.updatedAt.day}/${setlist.updatedAt.month}/${setlist.updatedAt.year}',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hint(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.white.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
      ],
    );
  }
}
