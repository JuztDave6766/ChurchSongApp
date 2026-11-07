/// Minimal ChordPro support.
///
/// Chords are written inline above the syllable they belong to:
///
/// ```text
/// [Re]Alzo gli occhi verso i [Sim]monti
/// ```
///
/// The same text is stored in [SongSection.text], so importing a ChordPro
/// file, editing a song and printing it all use one representation.
library;

class ChordSegment {
  const ChordSegment({required this.lyric, this.chord});

  final String lyric;
  final String? chord;
}

class ChordLine {
  const ChordLine({required this.segments});

  final List<ChordSegment> segments;

  bool get hasChords => segments.any((segment) => segment.chord != null);

  String get plainText => segments.map((segment) => segment.lyric).join();
}

class ChordProParser {
  const ChordProParser._();

  static final RegExp _chord = RegExp(r'\[([^\]]+)\]');

  static List<ChordLine> parse(String text) =>
      text.split('\n').map(parseLine).toList(growable: false);

  static ChordLine parseLine(String line) {
    if (!line.contains('[')) {
      return ChordLine(
        segments: [ChordSegment(lyric: line)],
      );
    }

    final segments = <ChordSegment>[];
    var cursor = 0;
    String? pending;

    for (final match in _chord.allMatches(line)) {
      final lyric = line.substring(cursor, match.start);
      if (pending != null || lyric.isNotEmpty) {
        segments.add(ChordSegment(chord: pending, lyric: lyric));
      }
      pending = match.group(1)!;
      cursor = match.end;
    }

    final rest = line.substring(cursor);
    if (pending != null) {
      segments.add(ChordSegment(chord: pending, lyric: rest));
    } else if (rest.isNotEmpty) {
      segments.add(ChordSegment(lyric: rest));
    }

    if (segments.isEmpty) {
      segments.add(ChordSegment(lyric: line));
    }
    return ChordLine(segments: segments);
  }

  /// Strips the chord markers, useful for search and plain exports.
  static String strip(String text) => text.replaceAllMapped(
        _chord,
        (_) => '',
      );
}
