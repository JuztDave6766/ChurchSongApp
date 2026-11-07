import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../domain/models.dart';
import 'library_controller.dart';

/// Readings for one Sunday (liturgical Year B: Advent 2025 → Christ the King
/// 2026). Citations are short references; the audience opens them in the
/// paper missal or the app of their choice.
class SundayReading {
  const SundayReading({
    required this.date,
    required this.titleIt,
    required this.titleEn,
    this.firstReading,
    this.psalmCitation,
    this.psalmResponse,
    this.secondReading,
    this.gospel,
    this.themeIds = const [],
  });

  factory SundayReading.fromJson(Map<String, dynamic> json) {
    final parsedDate = DateTime.tryParse(json['date'] as String? ?? '');
    return SundayReading(
      date: parsedDate ?? DateTime.now(),
      titleIt: json['titleIt'] as String? ?? 'Domenica',
      titleEn: json['titleEn'] as String? ?? 'Sunday',
      firstReading: json['firstReading'] as String?,
      psalmCitation: json['psalmCitation'] as String?,
      psalmResponse: json['psalmResponse'] as String?,
      secondReading: json['secondReading'] as String?,
      gospel: json['gospel'] as String?,
      themeIds:
          (json['themeIds'] as List<dynamic>? ?? const []).whereType<String>().toList(),
    );
  }

  final DateTime date;
  final String titleIt;
  final String titleEn;
  final String? firstReading;
  final String? psalmCitation;
  final String? psalmResponse;
  final String? secondReading;
  final String? gospel;
  final List<String> themeIds;

  bool get hasReadings =>
      (firstReading != null && firstReading!.isNotEmpty) ||
      (gospel != null && gospel!.isNotEmpty);

  String title(String languageCode) =>
      languageCode == 'en' ? titleEn : titleIt;
}

typedef SundJsonLoader = Future<Map<String, dynamic>> Function();

/// Default loader: bundled Year B calendar asset.
Future<Map<String, dynamic>> loadSundaysAsset() async {
  final raw = await rootBundle.loadString('assets/data/sundays_b.json');
  final decoded = jsonDecode(raw);
  return decoded is Map<String, dynamic> ? decoded : {};
}

/// Loads the Sunday readings and computes themed song suggestions.
///
/// Suggestions are never hard-coded song ids: they are derived from the
/// tomorrow's themes mapped onto catalogue tags, so user songs are also
/// considered.
class SundaysController extends ChangeNotifier {
  SundaysController({this.loader = loadSundaysAsset}) {
    ensureLoaded();
  }

  final SundJsonLoader loader;

  final List<SundayReading> _sundays = [];
  bool _loaded = false;

  bool get loaded => _loaded;
  List<SundayReading> get sundays => List.unmodifiable(_sundays);

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    try {
      final data = await loader();
      final list = data['sundays'];
      if (list is List) {
        _sundays
          ..clear()
          ..addAll(
            list
                .whereType<Map<String, dynamic>>()
                .map(SundayReading.fromJson)
                .toList(),
          );
        _sundays.sort((a, b) => a.date.compareTo(b.date));
      }
    } catch (_) {
      // Never crash the app over the demo calendar.
    }
    _loaded = true;
    notifyListeners();
  }

  /// The Sunday of [date]: the date itself if it is a Sunday, otherwise the
  /// most recent Sunday (readings still "current") and, only when there is no
  /// match, the upcoming one.
  SundayReading? forDate(DateTime date) {
    if (_sundays.isEmpty) return null;
    final currentSunday = DateTime(
      date.year,
      date.month,
      date.day - (date.weekday % 7),
    );
    final dayId = currentSunday.toIso8601String().substring(0, 10);
    for (final sunday in _sundays) {
      if (sunday.date.toIso8601String().substring(0, 10) == dayId) {
        return sunday;
      }
    }
    // Fallback: the nearest future (or past) entry.
    final after = _sundays.where((s) => s.date.isAfter(date)).toList();
    if (after.isNotEmpty) return after.first;
    return _sundays.last;
  }
}

/// Themed song suggestions for a [SundayReading].
class SundaySuggestions {
  SundaySuggestions({
    required this.psalmSongs,
    required this.alleluiaSongs,
    required this.communionSongs,
    required this.items,
  });

  final List<Song> psalmSongs;
  final List<Song> alleluiaSongs;
  final List<Song> communionSongs;

  /// Setlist items ready for [SetlistController.create]: a compact template
  /// built from the readings (entrance, psalm, alleluia, communion...).
  final List<SetlistEntry> items;
}

/// A (momentId, songId) pair; declared here to keep sundays_service free of
/// UI-only imports.
class SetlistEntry {
  const SetlistEntry(this.momentId, this.songId);

  final String momentId;
  final String songId;
}

extension SundaySuggestionLogic on SundayReading {
  bool _matchesThemes(Song song, List<String> themeIds) =>
      song.matchesAnyTag(themeIds);

  /// Songs for the responsorial psalm: [salmo] tagged songs, themed ones
  /// first, then the rest by title.
  List<Song> psalmSuggestions(LibraryController library, {int limit = 4}) {
    final candidates = library.songsWhere(
      (song) => song.hasTag('salmo') && song.hasTag('messa'),
    );
    final scored = _sortByThemeMatch(candidates);
    return scored.take(limit).toList();
  }

  /// Songs for the alleluia verse before the Gospel.
  List<Song> alleluiaSuggestions(LibraryController library, {int limit = 4}) {
    final candidates = library.songsWhere((song) =>
        song.hasTag('versetto-alleluia') &&
        (song.hasTag('messa') || song.hasTag('preghiera')));
    return _sortByThemeMatch(candidates).take(limit).toList();
  }

  List<Song> communionSuggestions(LibraryController library, {int limit = 4}) {
    final candidates =
        library.songsWhere((song) => song.hasTag('comunione'));
    return _sortByThemeMatch(candidates).take(limit).toList();
  }

  List<Song> _sortByThemeMatch(List<Song> songs) {
    int relevance(Song song) {
      var score = 0;
      for (final theme in themeIds) {
        if (song.hasTag(theme)) score += 2;
      }
      return score;
    }

    final result = List.of(songs);
    result.sort((a, b) {
      final compare = relevance(b).compareTo(relevance(a));
      if (compare != 0) return compare;
      return a.title('it').compareTo(b.title('it'));
    });
    return result;
  }

  /// A compact Mass setlist derived from the readings.
  SundaySuggestions buildSuggestions(LibraryController library) {
    final psalm = psalmSuggestions(library);
    final alleluia = alleluiaSuggestions(library);
    final communion = communionSuggestions(library);

    final items = <SetlistEntry>[];
    if (psalm.firstOrNull != null) items.add(SetlistEntry('salmo', psalm.first.id));
    if (alleluia.firstOrNull != null) {
      items.add(SetlistEntry('versetto-alleluia', alleluia.first.id));
    }
    for (final song in communion) {
      if (items.every((entry) => entry.songId != song.id)) {
        items.add(SetlistEntry('comunione', song.id));
      }
      if (items.where((entry) => entry.momentId == 'comunione').length >= 2) {
        break;
      }
    }
    // A closing song carrying the "pace" theme, if any.
    final closing = library
        .songsWhere((song) =>
            song.hasTag('messa') && song.hasTag('congedo'))
        .where((song) => _matchesThemes(song, themeIds))
        .firstOrNull ??
        library
            .songsWhere((song) => song.hasTag('messa') && song.hasTag('congedo'))
            .firstOrNull;
    if (closing != null &&
        items.every((entry) => entry.songId != closing.id)) {
      items.add(SetlistEntry('congedo', closing.id));
    }

    return SundaySuggestions(
      psalmSongs: psalm,
      alleluiaSongs: alleluia,
      communionSongs: communion,
      items: items,
    );
  }
}

extension on Iterable<Song> {
  Song? get firstOrNull => isEmpty ? null : first;
}
