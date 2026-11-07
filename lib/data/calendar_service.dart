import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

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
  bool _refreshing = false;
  bool get refreshing => _refreshing;

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

  /// Tries to refresh a single day from the CEI "santo del giorno" page.
  /// Works on native platforms; on web it fails silently and keeps bundled data.
  Future<void> refresh(DateTime date) async {
    if (_refreshing) return;
    _refreshing = true;
    notifyListeners();
    try {
      final uri = Uri.parse(
        'https://www.chiesacattolica.it/santo-del-giorno/?data-liturgia='
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) return;
      final html = response.body;
      final titleMatch = RegExp(r'<title>(.*?)</title>', dotAll: true).firstMatch(html);
      if (titleMatch == null) return;
      final rawTitle = _stripTags(titleMatch.group(1) ?? '');
      final name = rawTitle.contains(':')
          ? rawTitle.split(':').last.split('- sito').first.trim()
          : rawTitle;
      if (name.isEmpty) return;

      final key = DateTime(date.year, date.month, date.day);
      final index = _days.indexWhere((day) =>
          day.date.year == key.year &&
          day.date.month == key.month &&
          day.date.day == key.day);
      if (index < 0) return;

      final current = _days[index];
      final saintKeywords = ['Sant’', 'San ', 'Santa ', 'Beato', 'Beata'];
      final isSaint = saintKeywords.any(name.contains);
      final newSaint = (isSaint && name != current.titleIt) ? name : current.saintIt;
      // Keep the Sunday title when the day is a Sunday with readings.
      final newTitle = (current.isSunday && current.hasReadings)
          ? current.titleIt
          : name;

      _days[index] = LiturgicalDay(
        date: current.date,
        titleIt: newTitle,
        titleEn: current.titleEn == current.titleIt ? newTitle : current.titleEn,
        seasonId: current.seasonId,
        saintIt: newSaint,
        saintEn: newSaint,
        readings: current.readings,
        verified: current.verified,
        source: 'CEI – Santo del giorno (online)',
        sourceUrl: uri.toString(),
      );
      notifyListeners();
    } catch (_) {
      // Offline or CORS: keep bundled data.
    } finally {
      _refreshing = false;
      notifyListeners();
    }
  }

  static String _stripTags(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll(RegExp(r'\s+'), ' ').trim();
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
