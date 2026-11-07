import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../domain/liturgical_calendar.dart';
import '../../domain/models.dart';
import '../../data/calendar_service.dart';
import '../../data/library_controller.dart';
import '../../data/setlist_controller.dart';
import '../../data/sundays_service.dart';
import '../../domain/seasons.dart';
import '../setlists/setlist_detail_screen.dart';
import '../shared/page_body.dart';
import '../shared/section_header.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final calendar = context.watch<LiturgicalCalendarController>();
    final scheme = Theme.of(context).colorScheme;

    if (!calendar.loaded) {
      return const SizedBox.shrink();
    }

    final selectedDay = calendar.forDate(_selected);

    return SafeArea(
      bottom: false,
      child: PageBody(
        maxWidth: 960,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.calendarTitle,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.calendarSubtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _month = DateTime(DateTime.now().year, DateTime.now().month);
                    _selected = DateTime.now();
                  }),
                  icon: const Icon(Icons.today_rounded, size: 18),
                  label: Text(strings.calendarToday),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _MonthHeader(
              month: _month,
              onPrev: () => setState(() {
                _month = DateTime(_month.year, _month.month - 1);
              }),
              onNext: () => setState(() {
                _month = DateTime(_month.year, _month.month + 1);
              }),
            ),
            const SizedBox(height: 10),
            _MonthGrid(
              month: _month,
              selected: _selected,
              calendar: calendar,
              onSelect: (day) => setState(() => _selected = day),
            ),
            const SizedBox(height: 10),
            _SeasonLegend(calendar: calendar),
            const SizedBox(height: 22),
            if (selectedDay == null)
              EmptyState(
                icon: Icons.event_busy_rounded,
                title: strings.calendarNoData,
                body: '',
              )
            else ...[
              _DayDetail(
                day: selectedDay,
                selected: _selected,
                onCreateMass: () => _createMass(context, selectedDay),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _createMass(BuildContext context, LiturgicalDay day) async {
    final strings = AppStrings.of(context);
    final library = context.read<LibraryController>();
    final controller = context.read<SetlistController>();
    final sundays = context.read<SundaysController>();

    final seasonTag = day.seasonId;
    final reading = sundays.forDate(day.date);

    final items = <SetlistItem>[];
    var counter = 0;
    String nextId() => 'si_${DateTime.now().microsecondsSinceEpoch}_${counter++}';

    if (reading != null && reading.hasReadings) {
      final suggestions = reading.buildSuggestions(library);
      for (final entry in suggestions.items) {
        items.add(SetlistItem(
          id: nextId(),
          songId: entry.songId,
          momentId: entry.momentId,
        ));
      }
    } else {
      // Weekday: build a compact Mass from seasonal songs.
      for (final momentId in const ['ingresso', 'offertorio', 'comunione', 'congedo']) {
        final candidates = library
            .songsForMoment(momentId, functionId: 'messa')
            .where((song) => song.hasTag(seasonTag) || seasonTag == 'tempo-ordinario')
            .toList();
        if (candidates.isNotEmpty) {
          items.add(SetlistItem(
            id: nextId(),
            songId: candidates.first.id,
            momentId: momentId,
          ));
        }
      }
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.calendarNoData)),
      );
      return;
    }

    final setlist = controller.create(
      name: '${day.title(strings.languageCode)} · ${day.date.day}/${day.date.month}',
      functionId: 'messa',
      items: items,
    );
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SetlistDetailScreen(setlistId: setlist.id),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final names = const [
      'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre',
    ];
    return Row(
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            '${names[month.month - 1]} ${month.year}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.selected,
    required this.calendar,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime selected;
  final LiturgicalCalendarController calendar;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final leading = firstDay.weekday % 7; // Sunday = 0
    final total = leading + lastDay.day;
    final rows = (total / 7).ceil();

    final weekdays = const ['D', 'L', 'M', 'M', 'G', 'V', 'S'];

    return Column(
      children: [
        Row(
          children: [
            for (final w in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    w,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var r = 0; r < rows; r++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                for (var c = 0; c < 7; c++)
                  Expanded(
                    child: _DayCell(
                      date: _dateForCell(r, c, leading, month),
                      inMonth: _inMonth(r, c, leading, month, lastDay.day),
                      selected: selected,
                      calendar: calendar,
                      onSelect: onSelect,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  DateTime _dateForCell(int row, int col, int leading, DateTime month) {
    final index = row * 7 + col - leading + 1;
    return DateTime(month.year, month.month, index);
  }

  bool _inMonth(int row, int col, int leading, DateTime month, int lastDay) {
    final index = row * 7 + col - leading + 1;
    return index >= 1 && index <= lastDay;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.inMonth,
    required this.selected,
    required this.calendar,
    required this.onSelect,
  });

  final DateTime date;
  final bool inMonth;
  final DateTime selected;
  final LiturgicalCalendarController calendar;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!inMonth) return const SizedBox(height: 44);

    final day = calendar.forDate(date);
    final season = day?.season ?? seasonFor(date);
    final color = _seasonColor(season, scheme);
    final isSelected = date.year == selected.year &&
        date.month == selected.month &&
        date.day == selected.day;
    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => onSelect(date),
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? scheme.primaryContainer
              : color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),
          border: isToday
              ? Border.all(color: scheme.primary, width: 1.4)
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? scheme.onPrimaryContainer : scheme.onSurface,
                ),
          ),
        ),
      ),
    );
  }

  Color _seasonColor(LiturgicalSeason season, ColorScheme scheme) {
    return switch (season) {
      LiturgicalSeason.avvento => const Color(0xFF6B4E8C),
      LiturgicalSeason.natale => const Color(0xFFB88A2E),
      LiturgicalSeason.quaresima => const Color(0xFF5A3E6B),
      LiturgicalSeason.pasqua => const Color(0xFFD4A017),
      LiturgicalSeason.tempoOrdinario => const Color(0xFF2F6B5F),
    };
  }
}

class _SeasonLegend extends StatelessWidget {
  const _SeasonLegend({required this.calendar});

  final LiturgicalCalendarController calendar;

  @override
  Widget build(BuildContext context) {
    final items = [
      (LiturgicalSeason.avvento, 'Avvento'),
      (LiturgicalSeason.natale, 'Natale'),
      (LiturgicalSeason.quaresima, 'Quaresima'),
      (LiturgicalSeason.pasqua, 'Pasqua'),
      (LiturgicalSeason.tempoOrdinario, 'Tempo ordinario'),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: [
        for (final item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _color(item.$1).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 5),
              Text(item.$2, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
      ],
    );
  }

  Color _color(LiturgicalSeason s) {
    return switch (s) {
      LiturgicalSeason.avvento => const Color(0xFF6B4E8C),
      LiturgicalSeason.natale => const Color(0xFFB88A2E),
      LiturgicalSeason.quaresima => const Color(0xFF5A3E6B),
      LiturgicalSeason.pasqua => const Color(0xFFD4A017),
      LiturgicalSeason.tempoOrdinario => const Color(0xFF2F6B5F),
    };
  }
}

class _DayDetail extends StatelessWidget {
  const _DayDetail({
    required this.day,
    required this.selected,
    required this.onCreateMass,
  });

  final LiturgicalDay day;
  final DateTime selected;
  final VoidCallback onCreateMass;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final readings = day.readings;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  day.title(strings.languageCode),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  day.season.label(strings.languageCode),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: scheme.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${day.date.day}/${day.date.month}/${day.date.year}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (day.saint(strings.languageCode) != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person_outline_rounded, size: 16, color: scheme.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${strings.saintsOfTheDay}: ${day.saint(strings.languageCode)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
          if (readings != null && day.hasReadings) ...[
            const SizedBox(height: 14),
            _line(strings.firstReading, readings['firstReading'] as String?),
            _line(strings.psalmReading, readings['psalmCitation'] as String?),
            if (readings['psalmResponse'] != null)
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 2, bottom: 4),
                child: Text(
                  '“${readings['psalmResponse']}”',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            _line(strings.secondReading, readings['secondReading'] as String?),
            _line(strings.gospel, readings['gospel'] as String?),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: onCreateMass,
                icon: const Icon(Icons.queue_music_rounded, size: 18),
                label: Text(strings.prepareMassForDay),
              ),
              OutlinedButton.icon(
                onPressed: () => context
                    .read<LiturgicalCalendarController>()
                    .refresh(day.date),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(strings.calendarToday),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

