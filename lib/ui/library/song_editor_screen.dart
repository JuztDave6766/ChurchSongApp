import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/strings.dart';
import '../../data/library_controller.dart';
import '../../data/settings_controller.dart';
import '../../data/youtube_service.dart';
import '../../domain/catalog.dart';
import '../../domain/models.dart';
import '../shared/page_body.dart';

/// Add (or edit) a song. Two entry modes:
///  * automatic: paste a YouTube link (oEmbed) or search by title
///    (Data API key in settings, otherwise an external search page);
///  * manual: fill every field by hand.
class SongEditorScreen extends StatefulWidget {
  const SongEditorScreen({super.key, this.existing});

  final Song? existing;

  @override
  State<SongEditorScreen> createState() => _SongEditorScreenState();
}

class _SongEditorScreenState extends State<SongEditorScreen> {
  final _youtubeService = YouTubeService();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _keyController = TextEditingController();
  final _textController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _sheetUrlController = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _automatic = false;
  bool _fetching = false;
  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _initialised = true;
    final existing = widget.existing;
    if (existing != null) {
      _titleController.text = existing.title('it');
      _authorController.text = existing.author ?? '';
      _keyController.text = existing.keySignature ?? '';
      _textController.text = existing.sections
          .map((section) =>
              section.kind == SectionKind.chorus
                  ? 'R:\n${section.text}'
                  : section.text)
          .join('\n\n');
      _youtubeUrlController.text = existing.youtubeId ?? '';
      _sheetUrlController.text = existing.sheetUrl ?? '';
      _selectedTags.addAll(existing.tagIds);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _keyController.dispose();
    _textController.dispose();
    _youtubeUrlController.dispose();
    _sheetUrlController.dispose();
    super.dispose();
  }

  Future<void> _fetchFromYoutubeLink() async {
    final input = _youtubeUrlController.text.trim();
    if (input.isEmpty) return;
    setState(() => _fetching = true);
    final info = await _youtubeService.fetchInfoFromUrl(input);
    if (!mounted) return;
    setState(() => _fetching = false);
    if (info == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).importError)),
      );
      return;
    }
    setState(() {
      _titleController.text = info.title;
      if ((info.author ?? '').isNotEmpty) {
        _authorController.text = info.author!;
      }
      // Keep only the id in the stored field; the watch link is derived.
      final videoId = YouTubeService.extractVideoId(input);
      if (videoId != null) _youtubeUrlController.text = videoId;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.of(context).importedData)),
    );
  }

  Future<void> _searchOnline() async {
    final query = _titleController.text.trim();
    if (query.isEmpty) return;
    final apiKey = context.read<SettingsController>().youtubeApiKey;
    if (apiKey.isNotEmpty) {
      setState(() => _fetching = true);
      final info = await _youtubeService.searchByTitle(query, apiKey);
      if (!mounted) return;
      setState(() => _fetching = false);
      if (info == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).importError)),
        );
        return;
      }
      setState(() {
        if ((info.author ?? '').isNotEmpty) _authorController.text = info.author!;
        if (info.videoId != null) _youtubeUrlController.text = info.videoId!;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).importedData)),
      );
      return;
    }
    // No API key: open the YouTube search page and let the user copy details.
    final url = YouTubeService.searchUrl(query);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final sections = <SongSection>[];
    for (final block in _textController.text.split(RegExp(r'\n\s*\n'))) {
      final text = block.trim();
      if (text.isEmpty) continue;
      if (text.startsWith('R:')) {
        sections.add(
          SongSection(
            kind: SectionKind.chorus,
            text: text.substring(2).trim(),
          ),
        );
      } else {
        sections.add(SongSection(kind: SectionKind.verse, text: text));
      }
    }

    final now = DateTime.now();
    final song = Song(
      id: widget.existing?.id ?? 'us_${now.microsecondsSinceEpoch}',
      titles: {'it': title},
      author: _authorController.text.trim(),
      tagIds: _selectedTags.toList(),
      sections: sections,
      keySignature: _keyController.text.trim(),
      youtubeId: YouTubeService.extractVideoId(_youtubeUrlController.text),
      sheetUrl:
          _sheetUrlController.text.trim().isEmpty
              ? null
              : _sheetUrlController.text.trim(),
      license: SongLicense.demo,
    );

    await context.read<LibraryController>().saveUserSong(song);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.of(context).songSaved)),
    );
    Navigator.of(context).pop(song);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? strings.editSong : strings.addSongTitle),
        actions: [
          TextButton(onPressed: _save, child: Text(strings.save)),
          const SizedBox(width: 8),
        ],
      ),
      body: PageSafeList(
        children: [
          if (!isEditing) ...[
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: true,
                  icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                  label: Text(strings.addSongAutomatic),
                ),
                ButtonSegment(
                  value: false,
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: Text(strings.addSongManual),
                ),
              ],
              selected: {_automatic},
              onSelectionChanged: (selection) =>
                  setState(() => _automatic = selection.first),
            ),
            const SizedBox(height: 18),
          ],
          if (!isEditing && _automatic) ...[
            Text(
              strings.importTitleHint,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _youtubeUrlController,
              decoration: InputDecoration(
                labelText: strings.youtubeUrlLabel,
                prefixIcon:
                    const Icon(Icons.ondemand_video_rounded, size: 20),
                suffixIcon: IconButton(
                  tooltip: strings.fetchInfo,
                  onPressed: _fetching ? null : _fetchFromYoutubeLink,
                  icon: const Icon(Icons.download_rounded, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 26),
          ],
          TextField(
            controller: _titleController,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: strings.titleField,
              prefixIcon: const Icon(Icons.music_note_rounded, size: 19),
              suffixIcon:
                  !isEditing && _automatic
                      ? _fetching
                          ? const Padding(
                              padding: EdgeInsets.all(13),
                              child: SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : IconButton(
                              tooltip: strings.searchOnline,
                              onPressed:
                                  _titleController.text.trim().isEmpty
                                      ? null
                                      : _searchOnline,
                              icon: const Icon(
                                Icons.search_rounded,
                                size: 20,
                              ),
                            )
                      : null,
            ),
          ),
          TextField(
            controller: _authorController,
            decoration:
                InputDecoration(labelText: strings.authorField),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _keyController,
            decoration: InputDecoration(
              labelText: strings.keyField,
              prefixIcon: const Icon(Icons.piano_rounded, size: 19),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _textController,
            minLines: 6,
            maxLines: 14,
            decoration: InputDecoration(
              labelText: strings.lyricsLabel,
              helperText: strings.textSectionsHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          if (isEditing || !_automatic) ...[
            TextField(
              controller: _youtubeUrlController,
              decoration: InputDecoration(
                labelText: strings.youtubeIdField,
                prefixIcon:
                    const Icon(Icons.ondemand_video_rounded, size: 19),
              ),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _sheetUrlController,
            decoration: InputDecoration(
              labelText: strings.sheetUrlField,
              prefixIcon: const Icon(Icons.description_rounded, size: 19),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            strings.filterBy,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          _TagChooser(selected: _selectedTags, onChanged: (_) => setState(() {})),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check_rounded),
            label: Text(strings.save),
          ),
        ),
      ),
    );
  }
}

class PageSafeList extends StatelessWidget {
  const PageSafeList({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return PageBody(maxWidth: 720, child: ListView(children: children));
  }
}

class _TagChooser extends StatelessWidget {
  const _TagChooser({required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  void _toggle(String id) {
    if (!selected.remove(id)) selected.add(id);
    onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final language = Localizations.localeOf(context).languageCode;

    final groups = <(String, Iterable<Tag>)>[
      (
        strings.chooseCelebration,
        kTags.where((tag) => tag.kind == TagKind.celebration),
      ),
      (
        strings.celebrationMoments,
        kTags.where((tag) =>
            tag.kind == TagKind.moment && kMomentIds.contains(tag.id)),
      ),
      (strings.themesLabel, kTags.where((tag) => tag.kind == TagKind.theme)),
      (strings.stylesLabel, kTags.where((tag) => tag.kind == TagKind.style)),
      (
        strings.instrumentsLabel,
        kTags.where((tag) => tag.kind == TagKind.instrument),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (label, tags) in groups) ...[
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tag in tags)
                FilterChip(
                  label: Text(tag.label(language)),
                  selected: selected.contains(tag.id),
                  onSelected: (_) => _toggle(tag.id),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
