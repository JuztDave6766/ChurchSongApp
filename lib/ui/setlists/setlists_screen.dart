import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/setlist_controller.dart';
import '../../domain/catalog.dart';
import '../../domain/models.dart';
import '../setlists/setlist_detail_screen.dart';
import '../setlists/setlist_editor_screen.dart';
import '../shared/function_chooser.dart';
import '../shared/function_icon.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';

class SetlistsScreen extends StatelessWidget {
  const SetlistsScreen({super.key});

  Future<void> _newSetlist(BuildContext context) async {
    final choice = await showFunctionChooser(context);
    if (choice == null || !context.mounted) return;
    final setlist = await Navigator.of(context).push<Setlist>(
      MaterialPageRoute<Setlist>(
        builder: (_) => SetlistEditorScreen(function: choice.function),
      ),
    );
    if (setlist != null && context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SetlistDetailScreen(setlistId: setlist.id),
        ),
      );
    }
  }

  /// Creates a setlist from a ready-made themed template (Taizé, Lourdes,
  /// Gregorian, contemporary).
  Future<void> _fromTemplate(BuildContext context) async {
    final strings = AppStrings.of(context);
    final language = strings.languageCode;

    final template = await showDialog<SetlistTemplate>(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;
        return SimpleDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.templatesTitle),
              Text(
                strings.fromTemplate,
                style: Theme.of(dialogContext)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          children: [
            for (final template in kSetlistTemplates)
              SimpleDialogOption(
                onPressed: () => Navigator.of(dialogContext).pop(template),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              template.title(language),
                              style: Theme.of(dialogContext)
                                  .textTheme
                                  .titleSmall,
                            ),
                          ),
                          Text(
                            ' · ${strings.songCount(template.entries.length)}',
                            style: Theme.of(dialogContext).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        template.description(language),
                        style: Theme.of(dialogContext)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );

    if (template == null || !context.mounted) return;

    final now = DateTime.now();
    final setlist = context.read<SetlistController>().create(
          name: template.title(language),
          functionId: template.functionId,
          items: [
            for (var i = 0; i < template.entries.length; i++)
              SetlistItem(
                id: 'si_${now.microsecondsSinceEpoch}_$i',
                songId: template.entries[i].songId,
                momentId: template.entries[i].momentId,
              ),
          ],
        );
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SetlistDetailScreen(setlistId: setlist.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final setlists = context.watch<SetlistController>().all;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: PageBody(
        maxWidth: 900,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 36),
          children: [
            const SizedBox(height: 10),
            Text(
              strings.setlistsTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 4),
            Text(
              strings.setlistsSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _fromTemplate(context),
                  icon: const Icon(Icons.diamond_outlined, size: 18),
                  label: Text(strings.fromTemplate),
                ),
                FilledButton.icon(
                  onPressed: () => _newSetlist(context),
                  icon: const Icon(Icons.add_rounded, size: 19),
                  label: Text(strings.newSetlist),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (setlists.isEmpty)
              EmptyState(
                icon: Icons.queue_music_rounded,
                title: strings.emptySetlistsTitle,
                body: strings.emptySetlistsBody,
                actionLabel: strings.createFirstSetlist,
                onAction: () => _newSetlist(context),
              )
            else ...[
              SectionHeader(
                title: strings.recentSetlists,
                padding: const EdgeInsets.only(bottom: 12),
              ),
              for (final setlist in setlists)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SetlistCard(
                    setlist: setlist,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SetlistDetailScreen(
                          setlistId: setlist.id,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SetlistCard extends StatelessWidget {
  const _SetlistCard({required this.setlist, required this.onTap});

  final Setlist setlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final function = kFunctionsById[setlist.functionId];

    return Material(
      color: scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  functionIcon(function?.iconName ?? ''),
                  color: scheme.onPrimaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      setlist.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${function?.label(strings.languageCode) ?? setlist.functionId}'
                      ' · ${strings.songCount(setlist.songCount)}'
                      ' · ${setlist.updatedAt.day}/${setlist.updatedAt.month}/${setlist.updatedAt.year}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
