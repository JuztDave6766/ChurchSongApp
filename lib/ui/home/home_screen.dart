import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/library_controller.dart';
import '../../data/setlist_controller.dart';
import '../../domain/catalog.dart';
import '../../domain/models.dart';
import '../../domain/seasons.dart';
import '../function/function_screen.dart';
import '../setlists/setlist_detail_screen.dart';
import '../shared/function_chooser.dart';
import '../shared/function_icon.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenSetlists});

  final VoidCallback onOpenSetlists;

  Future<void> _prepareCelebration(BuildContext context) async {
    final choice = await showFunctionChooser(context);
    if (choice != null && context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => FunctionScreen(
            function: choice.function,
            prayerVariant: choice.prayerVariant,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final recent = context.watch<SetlistController>().all.take(3).toList();
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: PageBody(
        maxWidth: 1100,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 36),
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const AppMark(size: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.appName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        strings.appTagline,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.public_rounded,
                        size: 12,
                        color: scheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        strings.demoBadge,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: scheme.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Stack(
              children: [
                Positioned(
                  right: -50,
                  top: -70,
                  child: Glow(
                    size: 260,
                    color: scheme.primary,
                    opacity: 0.18,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.homeGreeting.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: scheme.secondary,
                            letterSpacing: 1.8,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      strings.homeTitle,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Text(
                        strings.homeSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 22),
            _LocalDataBanner(
              title: strings.localDataTitle,
              body: strings.localDataBody,
            ),
            const SizedBox(height: 30),
            SectionHeader(
              title: strings.chooseCelebration,
              actionLabel: strings.startPreparing,
              onAction: () => _prepareCelebration(context),
              padding: const EdgeInsets.only(bottom: 4),
            ),
            Text(
              strings.chooseCelebrationHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1000
                    ? 4
                    : constraints.maxWidth >= 620
                        ? 2
                        : 1;
                const gap = 14.0;
                final width =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final function in kFunctions.where((f) =>
                        f.seasonIds.isEmpty ||
                        f.seasonIds.contains(
                          seasonFor(DateTime.now()).name)))
                      SizedBox(
                        width: width,
                        height: 186,
                        child: _FunctionCard(
                          function: function,
                          songCount: library.songs
                              .where((song) => song.hasTag(function.id))
                              .length,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  FunctionScreen(function: function),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            SectionHeader(
              title: strings.recentSetlists,
              actionLabel: strings.seeAll,
              onAction: onOpenSetlists,
              padding: const EdgeInsets.only(bottom: 12),
            ),
            if (recent.isEmpty)
              _EmptySetlists(onCreate: () => _prepareCelebration(context))
            else
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: recent.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final setlist = recent[index];
                    return SizedBox(
                      width: 268,
                      child: _SetlistPreview(
                        setlist: setlist,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => SetlistDetailScreen(
                              setlistId: setlist.id,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FunctionCard extends StatelessWidget {
  const _FunctionCard({
    required this.function,
    required this.songCount,
    required this.onTap,
  });

  final LiturgicalFunction function;
  final int songCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      functionIcon(function.iconName),
                      color: scheme.onPrimaryContainer,
                      size: 21,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    strings.songCount(songCount),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                function.label(strings.languageCode),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                function.description(strings.languageCode),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetlistPreview extends StatelessWidget {
  const _SetlistPreview({required this.setlist, required this.onTap});

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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (function?.label(strings.languageCode) ?? setlist.functionId)
                    .toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.secondary,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                setlist.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.library_music_rounded,
                      size: 15, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    strings.songCount(setlist.songCount),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: scheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.tertiaryContainer),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, size: 19, color: scheme.tertiary),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(body, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySetlists extends StatelessWidget {
  const _EmptySetlists({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.playlist_add_rounded, color: scheme.secondary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              strings.noSetlistsHome,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: onCreate,
            child: Text(strings.startPreparing),
          ),
        ],
      ),
    );
  }
}
