import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/library_controller.dart';
import '../../domain/models.dart';
import '../shared/song_tile.dart';

/// Multi-select picker showing only the songs suited to [momentId].
Future<List<Song>?> showSongPicker(
  BuildContext context, {
  required LiturgicalFunction function,
  required LiturgicalMoment moment,
  required Set<String> excludedSongIds,
}) {
  return showModalBottomSheet<List<Song>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _SongPickerSheet(
      function: function,
      moment: moment,
      excludedSongIds: excludedSongIds,
    ),
  );
}

class _SongPickerSheet extends StatefulWidget {
  const _SongPickerSheet({
    required this.function,
    required this.moment,
    required this.excludedSongIds,
  });

  final LiturgicalFunction function;
  final LiturgicalMoment moment;
  final Set<String> excludedSongIds;

  @override
  State<_SongPickerSheet> createState() => _SongPickerSheetState();
}

class _SongPickerSheetState extends State<_SongPickerSheet> {
  final _search = TextEditingController();
  final Set<String> _selected = {};
  late final List<Song> _songs;

  @override
  void initState() {
    super.initState();
    final library = context.read<LibraryController>();
    _songs = library
        .songsForMoment(widget.moment.id, functionId: widget.function.id)
        .where((song) => !widget.excludedSongIds.contains(song.id))
        .toList();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Song> get _visible {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return _songs;
    return _songs
        .where((song) =>
            song.title('it').toLowerCase().contains(query) ||
            (song.author ?? '').toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final visible = _visible;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.chooseSong,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.moment.label(strings.languageCode)} · '
                  '${widget.function.label(strings.languageCode)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.secondary),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: strings.searchSongs,
                    prefixIcon: const Icon(Icons.search_rounded, size: 21),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: _search.clear,
                            icon: const Icon(Icons.close_rounded, size: 19),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  strings.songsForMoment(visible.length),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: visible.isEmpty
                      ? Center(
                          child: Text(
                            strings.noSongsFound,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 6, bottom: 12),
                          itemCount: visible.length,
                          separatorBuilder: (_, _) => Divider(
                            height: 1,
                            color: scheme.outlineVariant.withValues(alpha: 0.6),
                          ),
                          itemBuilder: (context, index) {
                            final song = visible[index];
                            final selected = _selected.contains(song.id);
                            return SongPickerTile(
                              song: song,
                              selected: selected,
                              onToggle: () => setState(() {
                                if (selected) {
                                  _selected.remove(song.id);
                                } else {
                                  _selected.add(song.id);
                                }
                              }),
                            );
                          },
                        ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text(
                          '${_selected.length}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          strings.songsLabel.toLowerCase(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: _selected.isEmpty
                              ? null
                              : () {
                                  final picked = _songs
                                      .where(
                                          (song) => _selected.contains(song.id))
                                      .toList();
                                  Navigator.of(context).pop(picked);
                                },
                          icon: const Icon(Icons.add_rounded, size: 19),
                          label: Text(strings.add),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
