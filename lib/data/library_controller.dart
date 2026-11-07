import 'package:flutter/foundation.dart';

import '../domain/catalog.dart';
import '../domain/models.dart';
import 'local_store.dart';
import 'services.dart';

/// Read-side of the song library plus all per-song user state
/// (favourites, offline downloads and user-created songs).
class LibraryController extends ChangeNotifier {
  LibraryController({
    required this.store,
    this.downloadService = const DemoDownloadService(),
    List<Song> extraSongs = const [],
  }) : _extraSongs = List.unmodifiable(extraSongs) {
    _extraSongsById = {for (final song in _extraSongs) song.id: song};
    _load();
  }

  final LocalStore store;
  final DownloadService downloadService;

  /// Repertoire imported from the user's own songbooks.
  final List<Song> _extraSongs;
  late final Map<String, Song> _extraSongsById;

  final List<Song> _userSongs = [];
  final Set<String> _favoriteIds = {};
  final Set<String> _downloadedIds = {};
  final Set<String> _inProgressIds = {};

  static const _favoritesKey = 'favorites';
  static const _downloadsKey = 'downloads';
  static const _userSongsKey = 'user_songs';

  void _load() {
    final favorites = store.readList(_favoritesKey);
    if (favorites != null) {
      _favoriteIds
        ..clear()
        ..addAll(favorites.whereType<String>());
    }
    final downloads = store.readList(_downloadsKey);
    if (downloads != null) {
      _downloadedIds
        ..clear()
        ..addAll(downloads.whereType<String>());
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

  /// Catalogue + personal repertoire + user-created songs, sorted by title.
  List<Song> get songs {
    final result = <Song>[...kSongs, ..._extraSongs, ..._userSongs];
    result.sort((a, b) => a.title('it').compareTo(b.title('it')));
    return result;
  }

  /// Only the songs created by the user.
  List<Song> get userSongs => List.unmodifiable(_userSongs);

  List<Song> songsWhere(bool Function(Song song) predicate) =>
      songs.where(predicate).toList();

  Song? songById(String id) {
    for (final song in _userSongs) {
      if (song.id == id) return song;
    }
    return _extraSongsById[id] ?? kSongsById[id];
  }

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

  Future<void> deleteUserSong(String id) async {
    _userSongs.removeWhere((song) => song.id == id);
    _favoriteIds.remove(id);
    _downloadedIds.remove(id);
    notifyListeners();
    await _persistUserSongs();
    await store.writeList(_favoritesKey, _favoriteIds.toList());
    await store.writeList(_downloadsKey, _downloadedIds.toList());
  }

  Future<void> _persistUserSongs() => store.writeList(
        _userSongsKey,
        _userSongs.map((song) => song.toJson()).toList(),
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
      return title.contains(normalized) || author.contains(normalized);
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

  bool isDownloaded(String songId) => _downloadedIds.contains(songId);

  bool isDownloading(String songId) => _inProgressIds.contains(songId);

  List<Song> get downloadedSongs => songs
      .where((song) => _downloadedIds.contains(song.id))
      .toList()
    ..sort((a, b) => a.title('it').compareTo(b.title('it')));

  Future<void> downloadSong(Song song) async {
    if (_downloadedIds.contains(song.id) || _inProgressIds.contains(song.id)) {
      return;
    }
    _inProgressIds.add(song.id);
    notifyListeners();
    try {
      await downloadService.download(song);
      _downloadedIds.add(song.id);
      await store.writeList(_downloadsKey, _downloadedIds.toList());
    } finally {
      _inProgressIds.remove(song.id);
      notifyListeners();
    }
  }

  Future<void> removeDownload(Song song) async {
    await downloadService.remove(song);
    _downloadedIds.remove(song.id);
    notifyListeners();
    await store.writeList(_downloadsKey, _downloadedIds.toList());
  }

  Future<void> resetUserData() async {
    _favoriteIds.clear();
    _downloadedIds.clear();
    _inProgressIds.clear();
    _userSongs.clear();
    notifyListeners();
    await store.remove(_favoritesKey);
    await store.remove(_downloadsKey);
    await store.remove(_userSongsKey);
  }
}
