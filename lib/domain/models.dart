/// Core domain models for ChurchSongApp.
///
/// The models are intentionally free of Flutter imports so they can be
/// reused by a future cloud-sync layer or a background isolate.
library;

/// Categories used to organise tags in the UI.
enum TagKind { celebration, moment, theme }

/// A free-form label attached to songs.
///
/// Tags are the backbone of the app: they describe both the celebration a
/// song belongs to (`messa`, `via-crucis`, ...) and the moment inside it
/// (`ingresso`, `offertorio`, ...).
class Tag {
  const Tag({
    required this.id,
    required this.kind,
    required this.it,
    required this.en,
  });

  final String id;
  final TagKind kind;
  final String it;
  final String en;

  String label(String languageCode) => languageCode == 'en' ? en : it;
}

/// The kind of text block a song section represents.
enum SectionKind { verse, chorus, bridge, response }

/// A single block of lyrics (a verse, the refrain, ...).
class SongSection {
  const SongSection({required this.kind, required this.text});

  final SectionKind kind;
  final String text;
}

/// A liturgical song.
///
/// [titles] is keyed by language code so that translated titles can be added
/// without changing the model. Italian content is the default fallback.
class Song {
  const Song({
    required this.id,
    required this.titles,
    required this.tagIds,
    required this.sections,
    this.author,
    this.keySignature,
    this.audioAsset,
    this.sheetAsset,
    this.duration,
  });

  final String id;
  final Map<String, String> titles;
  final String? author;
  final List<String> tagIds;
  final List<SongSection> sections;

  /// Musical key, e.g. `Re maggiore`. Displayed to musicians.
  final String? keySignature;

  /// Optional bundled audio file. Kept as a hook for real playback.
  final String? audioAsset;

  /// Optional bundled PDF/image with the score.
  final String? sheetAsset;

  /// Approximate duration, used by the event timeline.
  final Duration? duration;

  String title(String languageCode) =>
      titles[languageCode] ?? titles['it'] ?? titles.values.first;

  bool hasTag(String tagId) => tagIds.contains(tagId);

  bool matchesAnyTag(Iterable<String> tagIds) =>
      tagIds.any(this.tagIds.contains);
}

/// A moment inside a liturgical celebration (ingresso, offertorio, ...).
class LiturgicalMoment {
  const LiturgicalMoment({
    required this.id,
    required this.it,
    required this.en,
    this.hintIt,
    this.hintEn,
    this.optional = false,
  });

  final String id;
  final String it;
  final String en;
  final String? hintIt;
  final String? hintEn;

  /// Optional moments may be omitted from a celebration.
  final bool optional;

  String label(String languageCode) => languageCode == 'en' ? en : it;

  String? hint(String languageCode) =>
      languageCode == 'en' ? hintEn : hintIt;
}

/// A type of liturgical celebration the user can prepare.
class LiturgicalFunction {
  const LiturgicalFunction({
    required this.id,
    required this.it,
    required this.en,
    required this.descriptionIt,
    required this.descriptionEn,
    required this.moments,
    required this.iconName,
  });

  final String id;
  final String it;
  final String en;
  final String descriptionIt;
  final String descriptionEn;
  final List<LiturgicalMoment> moments;

  /// Icon key resolved by the UI layer to keep this model Flutter-free.
  final String iconName;

  String label(String languageCode) => languageCode == 'en' ? en : it;

  String description(String languageCode) =>
      languageCode == 'en' ? descriptionEn : descriptionIt;

  LiturgicalMoment? momentById(String id) {
    for (final moment in moments) {
      if (moment.id == id) return moment;
    }
    return null;
  }
}

/// One song placed inside a setlist, optionally bound to a moment.
class SetlistItem {
  const SetlistItem({
    required this.id,
    required this.songId,
    this.momentId,
    this.note,
  });

  final String id;
  final String songId;
  final String? momentId;
  final String? note;

  SetlistItem copyWith({String? momentId, String? note}) => SetlistItem(
        id: id,
        songId: songId,
        momentId: momentId ?? this.momentId,
        note: note ?? this.note,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'songId': songId,
        if (momentId != null) 'momentId': momentId,
        if (note != null) 'note': note,
      };

  factory SetlistItem.fromJson(Map<String, dynamic> json) => SetlistItem(
        id: json['id'] as String,
        songId: json['songId'] as String,
        momentId: json['momentId'] as String?,
        note: json['note'] as String?,
      );
}

/// A custom list of songs prepared for a celebration.
class Setlist {
  const Setlist({
    required this.id,
    required this.name,
    required this.functionId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.remoteId,
  });

  final String id;
  final String name;
  final String functionId;
  final List<SetlistItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Identifier used by the (future) cloud sync layer.
  final String? remoteId;

  int get songCount => items.length;

  Setlist copyWith({
    String? name,
    String? functionId,
    List<SetlistItem>? items,
    DateTime? updatedAt,
    String? remoteId,
  }) =>
      Setlist(
        id: id,
        name: name ?? this.name,
        functionId: functionId ?? this.functionId,
        items: items ?? this.items,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        remoteId: remoteId ?? this.remoteId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'functionId': functionId,
        'items': items.map((item) => item.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (remoteId != null) 'remoteId': remoteId,
      };

  factory Setlist.fromJson(Map<String, dynamic> json) => Setlist(
        id: json['id'] as String,
        name: json['name'] as String,
        functionId: json['functionId'] as String,
        items: (json['items'] as List<dynamic>? ?? const [])
            .map((item) =>
                SetlistItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        createdAt:
            DateTime.tryParse(json['createdAt'] as String? ?? '') ??
                DateTime.now(),
        updatedAt:
            DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
                DateTime.now(),
        remoteId: json['remoteId'] as String?,
      );
}

/// User preferences that are not tied to a single feature.
class AppSettings {
  const AppSettings({
    this.languageCode = 'it',
    this.themeMode = 'system',
    this.premiumUnlocked = false,
  });

  final String languageCode;
  final String themeMode;
  final bool premiumUnlocked;

  AppSettings copyWith({
    String? languageCode,
    String? themeMode,
    bool? premiumUnlocked,
  }) =>
      AppSettings(
        languageCode: languageCode ?? this.languageCode,
        themeMode: themeMode ?? this.themeMode,
        premiumUnlocked: premiumUnlocked ?? this.premiumUnlocked,
      );

  Map<String, dynamic> toJson() => {
        'languageCode': languageCode,
        'themeMode': themeMode,
        'premiumUnlocked': premiumUnlocked,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        languageCode: json['languageCode'] as String? ?? 'it',
        themeMode: json['themeMode'] as String? ?? 'system',
        premiumUnlocked: json['premiumUnlocked'] as bool? ?? false,
      );
}
