import 'package:flutter/foundation.dart';

import '../domain/catalog.dart';
import '../domain/models.dart';
import 'local_store.dart';

/// Read-side of the song library plus all per-song user state.
///
/// The catalogue imported from the user's songbooks is the primary
/// repertoire. Songs in the catalogue can be corrected through local
/// overrides; completely new songs use the `us_` prefix.
class LibraryController extends ChangeNotifier {
  LibraryController({
    required this.store,
    List<Song> catalogue = const [],
  }) : _catalogue = List.unmodifiable(catalogue) {
    _catalogueById = {for (final song in _catalogue) song.id: song};
    _load();
  }

  /// Replaces the bundled catalogue at runtime (used to defer loading the
  /// large JSON asset until after the first frame).
  Future<void> loadCatalogue(List<Song> catalogue) async {
    _catalogue = List.unmodifiable(catalogue);
    _catalogueById
      ..clear()
      ..addAll({for (final song in _catalogue) song.id: song});
    notifyListeners();
  }

  final LocalStore store;

  /// Repertoire imported from the user's own songbooks.
  List<Song> _catalogue;
  late Map<String, Song> _catalogueById;

  /// Local corrections keyed by catalogue song id.
  final Map<String, Song> _overrides = {};

  final List<Song> _userSongs = [];
  final Set<String> _favoriteIds = {};

  static const _favoritesKey = 'favorites';
  static const _overridesKey = 'song_overrides';
  static const _userSongsKey = 'user_songs';

  void _load() {
    final favorites = store.readList(_favoritesKey);
    if (favorites != null) {
      _favoriteIds
        ..clear()
        ..addAll(favorites.whereType<String>());
    }
    final overrides = store.readList(_overridesKey);
    if (overrides != null) {
      for (final raw in overrides.whereType<Map<String, dynamic>>()) {
        final song = Song.fromJson(raw);
        if (_catalogueById.containsKey(song.id)) {
          _overrides[song.id] = song;
        }
      }
    }
    final userRaw = store.readList(_userSongsKey);
    if (userRaw != null) {
      _userSongs
        ..clear()
        ..addAll(
          userRaw
              .whereType<Map<String, dynamic>>()
              .map(Song.fromJson)
              .toList(),
        );
    }
  }

  /// Catalogue + local overrides + user-created songs, sorted by title.
  List<Song> get songs {
    final result = <Song>[
      for (final song in _catalogue) _overrides[song.id] ?? song,
      ..._userSongs,
    ];
    result.sort((a, b) => a.title('it').compareTo(b.title('it')));
    return result;
  }

  /// Only the songs created by the user.
  List<Song> get userSongs => List.unmodifiable(_userSongs);

  /// Number of catalogue songs corrected locally.
  int get overrideCount => _overrides.length;

  List<Song> songsWhere(bool Function(Song song) predicate) =>
      songs.where(predicate).toList();

  Song? songById(String id) {
    for (final song in _userSongs) {
      if (song.id == id) return song;
    }
    return _overrides[id] ?? _catalogueById[id];
  }

  /// The untouched catalogue entry, used by "restore original".
  Song? originalSongById(String id) => _catalogueById[id];

  bool isOverridden(String id) => _overrides.containsKey(id);

  Song? userSongById(String id) {
    for (final song in _userSongs) {
      if (song.id == id) return song;
    }
    return null;
  }

  /// Creates or updates a user song (id prefixed `us_`).
  Future<void> saveUserSong(Song song) async {
    assert(song.isUserSong, 'user songs must use the us_ id prefix');
    final index = _userSongs.indexWhere((entry) => entry.id == song.id);
    if (index >= 0) {
      _userSongs[index] = song;
    } else {
      _userSongs.add(song);
    }
    notifyListeners();
    await _persistUserSongs();
  }

  /// Saves a local correction for a catalogue song.
  Future<void> saveOverride(Song song) async {
    if (!_catalogueById.containsKey(song.id)) {
      throw ArgumentError.value(song.id, 'song', 'unknown catalogue id');
    }
    _overrides[song.id] = song;
    notifyListeners();
    await _persistOverrides();
  }

  /// Drops the local correction, restoring the imported text.
  Future<void> resetOverride(String id) async {
    _overrides.remove(id);
    notifyListeners();
    await _persistOverrides();
  }

  Future<void> deleteUserSong(String id) async {
    _userSongs.removeWhere((song) => song.id == id);
    _favoriteIds.remove(id);
    notifyListeners();
    await _persistUserSongs();
    await store.writeList(_favoritesKey, _favoriteIds.toList());
  }

  Future<void> _persistUserSongs() => store.writeList(
        _userSongsKey,
        _userSongs.map((song) => song.toJson()).toList(),
      );

  Future<void> _persistOverrides() => store.writeList(
        _overridesKey,
        _overrides.values.map((song) => song.toJson()).toList(),
      );

  List<Tag> tagsFor(Song song) =>
      song.tagIds.map((id) => kTagsById[id]).whereType<Tag>().toList();

  List<Tag> tagsForSongOfKind(Song song, TagKind kind) =>
      tagsFor(song).where((tag) => tag.kind == kind).toList();

  List<Song> songsForMoment(String momentId, {String? functionId}) {
    final result = songs
        .where((song) => song.hasTag(momentId))
        .where((song) => functionId == null || song.hasTag(functionId))
        .toList();
    result.sort((a, b) => a.title('it').compareTo(b.title('it')));
    return result;
  }

  int countForMoment(String momentId, {String? functionId}) =>
      songsForMoment(momentId, functionId: functionId).length;

  List<Song> filter({
    String query = '',
    Set<String> tagIds = const {},
    bool favoritesOnly = false,
  }) {
    final normalized = query.trim().toLowerCase();
    final result = songs.where((song) {
      if (favoritesOnly && !isFavorite(song.id)) return false;
      if (tagIds.isNotEmpty && !song.matchesAnyTag(tagIds)) return false;
      if (normalized.isEmpty) return true;
      final title = song.title('it').toLowerCase();
      final author = (song.author ?? '').toLowerCase();
      final version = (song.version ?? '').toLowerCase();
      return title.contains(normalized) ||
          author.contains(normalized) ||
          version.contains(normalized);
    }).toList();
    result.sort((a, b) => a.title('it').compareTo(b.title('it')));
    return result;
  }

  bool isFavorite(String songId) => _favoriteIds.contains(songId);

  Future<void> toggleFavorite(String songId) async {
    if (!_favoriteIds.remove(songId)) {
      _favoriteIds.add(songId);
    }
    notifyListeners();
    await store.writeList(_favoritesKey, _favoriteIds.toList());
  }

  Map<String, dynamic> toBackup() => {
        'favorites': _favoriteIds.toList()..sort(),
        'userSongs': _userSongs.map((song) => song.toJson()).toList(),
        'overrides': _overrides.values.map((song) => song.toJson()).toList(),
      };

  Future<void> restoreBackup(Map<String, dynamic> data) async {
    final favorites = data['favorites'];
    _favoriteIds
      ..clear()
      ..addAll((favorites as List<dynamic>? ?? const []).whereType<String>());

    _userSongs
      ..clear()
      ..addAll(
        (data['userSongs'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(Song.fromJson),
      );

    _overrides.clear();
    for (final raw in (data['overrides'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()) {
      final song = Song.fromJson(raw);
      if (_catalogueById.containsKey(song.id)) {
        _overrides[song.id] = song;
      }
    }

    notifyListeners();
    await store.writeList(_favoritesKey, _favoriteIds.toList());
    await _persistUserSongs();
    await _persistOverrides();
  }

  Future<void> resetUserData() async {
    _favoriteIds.clear();
    _overrides.clear();
    _userSongs.clear();
    notifyListeners();
    await store.remove(_favoritesKey);
    await store.remove(_overridesKey);
    await store.remove(_userSongsKey);
  }
}
