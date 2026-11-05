import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../data/library_controller.dart';
import '../../data/setlist_controller.dart';
import '../../domain/models.dart';
import '../shared/page_body.dart';
import 'song_picker_sheet.dart';

/// Create or edit a setlist for [function].
///
/// Returns the saved [Setlist] so the caller can open its detail page.
class SetlistEditorScreen extends StatefulWidget {
  const SetlistEditorScreen({
    super.key,
    required this.function,
    this.existing,
  });

  final LiturgicalFunction function;
  final Setlist? existing;

  @override
  State<SetlistEditorScreen> createState() => _SetlistEditorScreenState();
}

class _SetlistEditorScreenState extends State<SetlistEditorScreen> {
  final _nameController = TextEditingController();
  late List<SetlistItem> _items;
  bool _initialised = false;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _initialised = true;
    final strings = AppStrings.of(context);
    _items = List.of(widget.existing?.items ?? const <SetlistItem>[]);
    final now = DateTime.now();
    _nameController.text = widget.existing?.name ??
        '${widget.function.label(strings.languageCode)} · '
            '${now.day}/${now.month}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _defaultName {
    final strings = AppStrings.of(context);
    final now = DateTime.now();
    return '${widget.function.label(strings.languageCode)} · '
        '${now.day}/${now.month}';
  }

  List<SetlistItem> _itemsFor(String momentId) =>
      _items.where((item) => item.momentId == momentId).toList();

  Future<void> _addSongs(LiturgicalMoment moment) async {
    final existingIds =
        _itemsFor(moment.id).map((item) => item.songId).toSet();
    final picked = await showSongPicker(
      context,
      function: widget.function,
      moment: moment,
      excludedSongIds: existingIds,
    );
    if (picked == null || picked.isEmpty || !mounted) return;
    setState(() {
      for (final song in picked) {
        _items.add(
          SetlistItem(
            id: 'si_${DateTime.now().microsecondsSinceEpoch}_${_items.length}',
            songId: song.id,
            momentId: moment.id,
          ),
        );
      }
    });
  }

  void _removeItem(SetlistItem item) {
    setState(() => _items.removeWhere((entry) => entry.id == item.id));
  }

  void _move(SetlistItem item, {required bool up}) {
    final siblings = _items
        .where((entry) => entry.momentId == item.momentId)
        .toList();
    final siblingIndex = siblings.indexWhere((entry) => entry.id == item.id);
    final targetSibling = up ? siblingIndex - 1 : siblingIndex + 1;
    if (targetSibling < 0 || targetSibling >= siblings.length) return;
    final from = _items.indexWhere((entry) => entry.id == item.id);
    final to = _items.indexWhere(
      (entry) => entry.id == siblings[targetSibling].id,
    );
    setState(() {
      final moved = _items.removeAt(from);
      _items.insert(to, moved);
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final controller = context.read<SetlistController>();
    final now = DateTime.now();
    final name = _nameController.text.trim().isEmpty
        ? _defaultName
        : _nameController.text.trim();
    final setlist = Setlist(
      id: widget.existing?.id ?? 'sl_${now.microsecondsSinceEpoch}',
      name: name,
      functionId: widget.function.id,
      items: List.of(_items),
      createdAt: widget.existing?.createdAt ?? now,
      updatedAt: now,
      remoteId: widget.existing?.remoteId,
    );
    await controller.save(setlist);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.of(context).setlistSaved)),
    );
    Navigator.of(context).pop(setlist);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? strings.editSetlist : strings.newSetlist),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(strings.save),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageBody(
        maxWidth: 900,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: strings.setlistName,
                hintText: strings.setlistNameHint,
                prefixIcon: const Icon(Icons.edit_note_rounded),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.church_rounded, size: 18, color: scheme.secondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.function.label(strings.languageCode),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    strings.songCount(_items.length),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text(
              strings.celebrationMoments,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 14),
            for (final moment in widget.function.moments) ...[
              _MomentSection(
                moment: moment,
                items: _itemsFor(moment.id),
                onAdd: () => _addSongs(moment),
                onRemove: _removeItem,
                onMoveUp: (item) => _move(item, up: true),
                onMoveDown: (item) => _move(item, up: false),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(strings.save),
          ),
        ),
      ),
    );
  }
}

class _MomentSection extends StatelessWidget {
  const _MomentSection({
    required this.moment,
    required this.items,
    required this.onAdd,
    required this.onRemove,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  final LiturgicalMoment moment;
  final List<SetlistItem> items;
  final VoidCallback onAdd;
  final ValueChanged<SetlistItem> onRemove;
  final ValueChanged<SetlistItem> onMoveUp;
  final ValueChanged<SetlistItem> onMoveDown;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final library = context.read<LibraryController>();
    final hint = moment.hint(strings.languageCode);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              moment.label(strings.languageCode),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (moment.optional) ...[
                            const SizedBox(width: 8),
                            Text(
                              strings.optional,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                        ],
                      ),
                      if (hint != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            hint,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: strings.addSongs,
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded, size: 20),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                strings.emptyMoment,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                children: [
                  for (final item in items)
                    _ItemRow(
                      item: item,
                      song: library.songById(item.songId),
                      onRemove: () => onRemove(item),
                      onMoveUp: () => onMoveUp(item),
                      onMoveDown: () => onMoveDown(item),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.song,
    required this.onRemove,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  final SetlistItem item;
  final Song? song;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    if (song == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(Icons.music_note_rounded, size: 17, color: AppColors.gold),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              song!.title(strings.languageCode),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          IconButton(
            tooltip: strings.moveUp,
            onPressed: onMoveUp,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 19),
          ),
          IconButton(
            tooltip: strings.moveDown,
            onPressed: onMoveDown,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 19),
          ),
          IconButton(
            tooltip: strings.remove,
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
