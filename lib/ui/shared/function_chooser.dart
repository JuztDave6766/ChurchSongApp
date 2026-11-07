import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/library_controller.dart';
import '../../domain/catalog.dart';
import '../../domain/models.dart';
import '../../domain/seasons.dart';
import 'function_icon.dart';


/// Optional variant for the Prayer celebration: free prayer or breviary,
/// morning or evening.
enum PrayerKind { free, breviary }

enum PrayerTime { morning, evening }

class PrayerVariant {
  const PrayerVariant({required this.kind, required this.time});

  final PrayerKind kind;
  final PrayerTime time;

  String label(String languageCode) {
    final kindLabel = kind == PrayerKind.free
        ? (languageCode == 'en' ? 'Free prayer' : 'Preghiera libera')
        : (languageCode == 'en' ? 'Breviary' : 'Breviario');
    final timeLabel = time == PrayerTime.morning
        ? (languageCode == 'en' ? 'Morning' : 'Mattino')
        : (languageCode == 'en' ? 'Evening' : 'Sera');
    return '$kindLabel · $timeLabel';
  }
}

/// Result of [showFunctionChooser]: the celebration plus, for prayer, the
/// chosen variant.
class FunctionChoice {
  const FunctionChoice({required this.function, this.prayerVariant});

  final LiturgicalFunction function;
  final PrayerVariant? prayerVariant;
}

/// Required first step of the flow: pick the liturgical celebration.
Future<FunctionChoice?> showFunctionChooser(BuildContext context) {
  return showModalBottomSheet<LiturgicalFunction>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _FunctionChooser(),
  ).then((function) async {
    if (function == null) return null;
    if (!context.mounted) return null;
    if (function.id != 'preghiera') {
      return FunctionChoice(function: function);
    }
    final variant = await _showPrayerVariantChooser(context);
    if (variant == null) return null;
    return FunctionChoice(function: function, prayerVariant: variant);
  });
}



Future<PrayerVariant?> _showPrayerVariantChooser(BuildContext context) {
  return showModalBottomSheet<PrayerVariant>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _PrayerVariantChooser(),
  );
}

class _FunctionChooser extends StatelessWidget {
  const _FunctionChooser();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final scheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.chooseCelebration,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                strings.chooseCelebrationHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final function in kFunctions.where((f) =>
                            f.seasonIds.isEmpty ||
                            f.seasonIds.contains(
                              seasonFor(DateTime.now()).name)))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: scheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(18),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () =>
                                  Navigator.of(context).pop(function),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 46,
                                      width: 46,
                                      decoration: BoxDecoration(
                                        color: scheme.primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: Icon(
                                        functionIcon(function.iconName),
                                        color: scheme.onPrimaryContainer,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            function.label(
                                              strings.languageCode,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(fontSize: 20),
                                          ),
                                          Text(
                                            strings.songCount(
                                              library.songs
                                                  .where((song) =>
                                                      song.hasTag(function.id))
                                                  .length,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}

class _PrayerVariantChooser extends StatelessWidget {
  const _PrayerVariantChooser();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.prayerVariantTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                strings.prayerVariantHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              for (final kind in PrayerKind.values)
                for (final time in PrayerTime.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: scheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.of(context).pop(
                          PrayerVariant(kind: kind, time: time),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(
                                kind == PrayerKind.free
                                    ? Icons.edit_note_rounded
                                    : Icons.menu_book_rounded,
                                color: scheme.secondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  PrayerVariant(kind: kind, time: time)
                                      .label(strings.languageCode),
                                  style: Theme.of(context)
                                      .textTheme.titleMedium,
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  color: scheme.onSurfaceVariant),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
