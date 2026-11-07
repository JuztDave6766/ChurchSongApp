import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../domain/liturgical_calendar.dart';

typedef CalendarJsonLoader = Future<Map<String, dynamic>> Function();

Future<Map<String, dynamic>> loadCalendarAsset() async {
  final raw = await rootBundle.loadString('assets/data/liturgical_calendar.json');
  final decoded = jsonDecode(raw);
  return decoded is Map<String, dynamic> ? decoded : {};
}

class LiturgicalCalendarController extends ChangeNotifier {
  LiturgicalCalendarController({this.loader = loadCalendarAsset}) {
    ensureLoaded();
  }

  final CalendarJsonLoader loader;

  final List<LiturgicalDay> _days = [];
  final List<LiturgicalSeasonInfo> _seasons = [];
  bool _loaded = false;

  bool get loaded => _loaded;
  List<LiturgicalDay> get days => List.unmodifiable(_days);
  List<LiturgicalSeasonInfo> get seasons => List.unmodifiable(_seasons);

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    try {
      final data = await loader();
      final list = data['sundays'] ?? data['days'];
      if (list is List) {
        _days
          ..clear()
          ..addAll(
            list
                .whereType<Map<String, dynamic>>()
                .map(LiturgicalDay.fromJson)
                .where((day) => day.verified)
                .toList(),
          );
        _days.sort((a, b) => a.date.compareTo(b.date));
      }
      final seasons = data['seasons'];
      if (seasons is List) {
        _seasons
          ..clear()
          ..addAll(
            seasons.whereType<Map<String, dynamic>>().map(
                  (s) => LiturgicalSeasonInfo(
                    id: s['id'] as String? ?? '',
                    it: s['it'] as String? ?? '',
                    en: s['en'] as String? ?? '',
                  ),
                ),
          );
      }
    } catch (_) {
      // Never crash the app over the calendar.
    }
    _loaded = true;
    notifyListeners();
  }

  LiturgicalDay? forDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    for (final day in _days) {
      if (day.date.year == key.year &&
          day.date.month == key.month &&
          day.date.day == key.day) {
        return day;
      }
    }
    return null;
  }

  List<LiturgicalDay> daysInMonth(int year, int month) {
    return _days
        .where((day) => day.date.year == year && day.date.month == month)
        .toList();
  }

  LiturgicalSeasonInfo? seasonInfo(String id) {
    for (final season in _seasons) {
      if (season.id == id) return season;
    }
    return null;
  }
}
