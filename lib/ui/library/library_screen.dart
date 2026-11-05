import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/library_controller.dart';
import '../../domain/catalog.dart';
import '../../domain/models.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';
import '../shared/song_sheet.dart';
import '../shared/song_tile.dart';
import '../shared/tag_pill.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _searchController = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasFilters =>
      _selectedTags.isNotEmpty ||
      _favoritesOnly ||
      _searchController.text.trim().isNotEmpty;

  void _clearFilters() {
    setState(() {
      _selectedTags.clear();
      _favoritesOnly = false;
      _searchController.clear();
    });
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (!_selectedTags.remove(tagId)) _selectedTags.add(tagId);
    });
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _TagFilterSheet(initial: _selectedTags),
    );
    if (result != null) {
      setState(() {
        _selectedTags
          ..clear()
          ..addAll(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final scheme = Theme.of(context).colorScheme;
    final songs = library.filter(
      query: _searchController.text,
      tagIds: _selectedTags,
      favoritesOnly: _favoritesOnly,
    );

    return SafeArea(
      bottom: false,
      child: PageBody(
        maxWidth: 900,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 36),
          children: [
            const SizedBox(height: 10),
            Text(
              strings.libraryTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 4),
            Text(
              strings.librarySubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: strings.searchSongs,
                prefixIcon: const Icon(Icons.search_rounded, size: 21),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _searchController.clear,
                        icon: const Icon(Icons.close_rounded, size: 19),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    avatar: Icon(
                      _favoritesOnly
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 17,
                      color: _favoritesOnly
                          ? scheme.onPrimaryContainer
                          : scheme.secondary,
                    ),
                    showCheckmark: false,
                    label: Text(strings.favoritesOnly),
                    selected: _favoritesOnly,
                    onSelected: (value) =>
                        setState(() => _favoritesOnly = value),
                  ),
                  const SizedBox(width: 8),
                  for (final function in kFunctions) ...[
                    FilterChip(
                      showCheckmark: false,
                      label: Text(function.label(strings.languageCode)),
                      selected: _selectedTags.contains(function.id),
                      onSelected: (_) => _toggleTag(function.id),
                    ),
                    const SizedBox(width: 8),
                  ],
                  ActionChip(
                    avatar: const Icon(Icons.tune_rounded, size: 17),
                    label: Text(strings.filterBy),
                    onPressed: _openFilters,
                  ),
                  if (_hasFilters) ...[
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: _clearFilters,
                      child: Text(strings.clearFilters),
                    ),
                  ],
                ],
              ),
            ),
            if (_selectedTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  for (final id in _selectedTags)
                    if (kTagsById[id] != null)
                      TagPill(
                        tag: kTagsById[id]!,
                        selected: true,
                        onTap: () => _toggleTag(id),
                      ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  strings.songCount(songs.length),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                Text(
                  _favoritesOnly
                      ? strings.favoritesOnly
                      : strings.all,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (songs.isEmpty)
              EmptyState(
                icon: Icons.search_off_rounded,
                title: strings.noSongsFound,
                body: strings.noSongsFoundHint,
                actionLabel: _hasFilters ? strings.clearFilters : null,
                onAction: _hasFilters ? _clearFilters : null,
              )
            else
              for (final song in songs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: SongTile(
                    song: song,
                    onTap: () => showSongSheet(context, song),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _TagFilterSheet extends StatefulWidget {
  const _TagFilterSheet({required this.initial});

  final Set<String> initial;

  @override
  State<_TagFilterSheet> createState() => _TagFilterSheetState();
}

class _TagFilterSheetState extends State<_TagFilterSheet> {
  late final Set<String> _temp = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final celebrations = kTags.where((tag) => tag.kind == TagKind.celebration);
    final moments = kTags
        .where((tag) =>
            tag.kind == TagKind.moment && kMomentIds.contains(tag.id))
        .toList();
    final themes = kTags.where((tag) => tag.kind == TagKind.theme).toList();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.82,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      strings.filterBy,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(_temp.clear),
                      child: Text(strings.clearFilters),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _group(
                        context,
                        strings.chooseCelebration,
                        celebrations,
                      ),
                      _group(context, strings.celebrationMoments, moments),
                      _group(context, strings.themesLabel, themes),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Text(
                          strings.filtersCount(_temp.length),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () =>
                              Navigator.of(context).pop({..._temp}),
                          child: Text(strings.done),
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

  Widget _group(BuildContext context, String title, Iterable<Tag> tags) {
    final scheme = Theme.of(context).colorScheme;
    final language = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1,
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tag in tags)
                FilterChip(
                  showCheckmark: true,
                  label: Text(tag.label(language)),
                  selected: _temp.contains(tag.id),
                  onSelected: (_) => setState(() {
                    if (!_temp.remove(tag.id)) _temp.add(tag.id);
                  }),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
