import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:church_song_app/data/library_controller.dart';
import 'package:church_song_app/data/local_store.dart';
import 'package:church_song_app/data/services.dart';
import 'package:church_song_app/domain/catalog.dart';
import 'package:church_song_app/domain/models.dart';

class _FakeDownloadService implements DownloadService {
  _FakeDownloadService({this.completer});

  final Completer<void>? completer;
  final List<String> downloaded = [];
  final List<String> removed = [];

  @override
  Future<void> download(Song song) async {
    if (completer != null) await completer!.future;
    downloaded.add(song.id);
  }

  @override
  Future<void> remove(Song song) async {
    removed.add(song.id);
  }
}

Future<LocalStore> _freshStore() async {
  SharedPreferences.setMockInitialValues({});
  return LocalStore.open();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LibraryController filtering', () {
    late LibraryController library;

    setUp(() async {
      library = LibraryController(store: await _freshStore());
    });

    test('returns all songs alphabetically by Italian title', () {
      final songs = library.filter();

      expect(songs, hasLength(kSongs.length));
      final titles = songs.map((song) => song.title('it')).toList();
      expect(titles, orderedEquals([...titles]..sort()));
    });

    test('filters by moment and optional function', () {
      final entranceSongs = library.songsForMoment('ingresso');

      expect(entranceSongs, isNotEmpty);
      expect(entranceSongs.every((song) => song.hasTag('ingresso')), isTrue);

      final prayerEntrance = library.songsForMoment(
        'santo',
        functionId: 'preghiera',
      );
      expect(prayerEntrance, isEmpty);
    });

    test('searches title and author case-insensitively', () {
      final byTitle = library.filter(query: '  gloria ');
      expect(byTitle, isNotEmpty);
      expect(
        byTitle.every(
          (song) =>
              song.title('it').toLowerCase().contains('gloria') ||
              (song.author ?? '').toLowerCase().contains('gloria'),
        ),
        isTrue,
      );

      final byAuthor = library.filter(query: 'tradizionale');
      expect(byAuthor, isNotEmpty);
      expect(
        byAuthor.every(
          (song) => (song.author ?? '').toLowerCase().contains('tradizionale'),
        ),
        isTrue,
      );

      expect(library.filter(query: 'nessun-canto-cosi'), isEmpty);
    });

    test('combines tag filters with any-match semantics', () {
      final lightOrPeace = library.filter(tagIds: {'luce', 'pace'});

      expect(lightOrPeace, isNotEmpty);
      expect(
        lightOrPeace.every((song) => song.hasTag('luce') || song.hasTag('pace')),
        isTrue,
      );
    });

    test('filters favourites only', () {
      final first = library.filter().first;
      expect(library.filter(favoritesOnly: true), isEmpty);

      library.toggleFavorite(first.id);

      final favourites = library.filter(favoritesOnly: true);
      expect(favourites.map((song) => song.id), [first.id]);
    });

    test('counts songs for a moment', () {
      expect(
        library.countForMoment('ingresso'),
        library.songsForMoment('ingresso').length,
      );
    });
  });

  group('favourites persistence', () {
    test('persists favourites across controller instances', () async {
      final store = await _freshStore();
      final first = LibraryController(store: store);

      await first.toggleFavorite('gloria-a-dio');
      expect(first.isFavorite('gloria-a-dio'), isTrue);

      final reopened = LibraryController(store: store);
      expect(reopened.isFavorite('gloria-a-dio'), isTrue);

      await reopened.toggleFavorite('gloria-a-dio');
      final reopenedAgain = LibraryController(store: store);
      expect(reopenedAgain.isFavorite('gloria-a-dio'), isFalse);
    });
  });

  group('downloads', () {
    test('marks a song as downloading then downloaded', () async {
      final store = await _freshStore();
      final completer = Completer<void>();
      final service = _FakeDownloadService(completer: completer);
      final library = LibraryController(
        store: store,
        downloadService: service,
      );
      final song = library.filter().first;

      final future = library.downloadSong(song);
      expect(library.isDownloading(song.id), isTrue);
      expect(library.isDownloaded(song.id), isFalse);

      completer.complete();
      await future;

      expect(library.isDownloading(song.id), isFalse);
      expect(library.isDownloaded(song.id), isTrue);
      expect(service.downloaded, [song.id]);
      expect(library.downloadedSongs.map((item) => item.id), [song.id]);
    });

    test('persists downloads and supports removal', () async {
      final store = await _freshStore();
      final service = _FakeDownloadService();
      final library = LibraryController(
        store: store,
        downloadService: service,
      );
      final song = library.filter().first;

      await library.downloadSong(song);
      final reopened = LibraryController(
        store: store,
        downloadService: service,
      );
      expect(reopened.isDownloaded(song.id), isTrue);

      await reopened.removeDownload(song);
      expect(reopened.isDownloaded(song.id), isFalse);
      expect(service.removed, [song.id]);
    });

    test('ignores duplicate download requests', () async {
      final store = await _freshStore();
      final service = _FakeDownloadService();
      final library = LibraryController(
        store: store,
        downloadService: service,
      );
      final song = library.filter().first;

      await Future.wait([
        library.downloadSong(song),
        library.downloadSong(song),
      ]);

      expect(service.downloaded, [song.id]);
    });
  });

  group('resetUserData', () {
    test('clears favourites, downloads and user songs', () async {
      final store = await _freshStore();
      final library = LibraryController(
        store: store,
        downloadService: _FakeDownloadService(),
      );
      final first = library.filter().first;
      final second = library.filter()[1];

      await library.toggleFavorite(first.id);
      await library.downloadSong(second);

      await library.resetUserData();

      expect(library.isFavorite(first.id), isFalse);
      expect(library.isDownloaded(second.id), isFalse);
      expect(library.downloadedSongs, isEmpty);

      final reopened = LibraryController(store: store);
      expect(reopened.isFavorite(first.id), isFalse);
      expect(reopened.isDownloaded(second.id), isFalse);
    });
  });

  group('personal repertoire', () {
    const imported = Song(
      id: 'ps_test',
      titles: {'it': 'Canto del canzoniere'},
      tagIds: ['messa', 'ingresso', 'avvento'],
      sections: [
        SongSection(kind: SectionKind.verse, text: 'Testo importato.'),
      ],
      license: SongLicense.personalUse,
      sourceNote: 'Canzoniere personale, p. 1',
    );

    test('merges extras with the catalogue without touching user songs', () async {
      final library = LibraryController(
        store: await _freshStore(),
        extraSongs: const [imported],
      );

      expect(library.songs, hasLength(kSongs.length + 1));
      expect(library.userSongs, isEmpty);
      expect(library.songById('ps_test')?.title('it'), 'Canto del canzoniere');
      expect(library.filter(query: 'canzoniere').single.id, 'ps_test');
      expect(
        library.songsForMoment('ingresso').map((song) => song.id),
        contains('ps_test'),
      );
    });

    test('sorts imported songs with the rest of the library', () async {
      final library = LibraryController(
        store: await _freshStore(),
        extraSongs: const [imported],
      );
      final titles = library.filter().map((song) => song.title('it')).toList();
      expect(titles, orderedEquals([...titles]..sort()));
    });
  });

  group('user songs', () {
    test('saves and finds a user song', () async {
      final library = LibraryController(store: await _freshStore());
      const song = Song(
        id: 'us_1',
        titles: {'it': 'Mio canto'},
        tagIds: ['messa', 'ingresso', 'gioia'],
        sections: [
          SongSection(kind: SectionKind.chorus, text: 'Ritornello di prova.'),
        ],
      );

      await library.saveUserSong(song);

      expect(library.userSongs.map((item) => item.id), ['us_1']);
      expect(library.songs, hasLength(kSongs.length + 1));
      expect(library.songById('us_1'), isNotNull);
      expect(library.filter(query: 'Mio canto'), isNotEmpty);
      expect(library.songsForMoment('ingresso'), isNotEmpty);
    });

    test('updates an existing user song', () async {
      final library = LibraryController(store: await _freshStore());
      final song = const Song(
        id: 'us_2',
        titles: {'it': 'Prima versione'},
        tagIds: ['messa'],
      );

      await library.saveUserSong(song);
      await library.saveUserSong(
        const Song(
          id: 'us_2',
          titles: {'it': 'Versione corretta'},
          tagIds: ['preghiera'],
        ),
      );

      expect(library.userSongs, hasLength(1));
      expect(library.songById('us_2')!.title('it'), 'Versione corretta');
    });

    test('persists user songs across controller instances', () async {
      final store = await _freshStore();
      final library = LibraryController(store: store);
      await library.saveUserSong(
        const Song(
          id: 'us_3',
          titles: {'it': 'Persistente'},
          tagIds: ['preghiera', 'apertura'],
          sections: [SongSection(kind: SectionKind.verse, text: 'Testo.')],
          keySignature: 'Do minore',
          youtubeId: 'abcdefghijk',
        ),
      );
      final reopened = LibraryController(store: store);
      final restored = reopened.songById('us_3');
      expect(restored!.title('it'), 'Persistente');
      expect(restored.keySignature, 'Do minore');
      expect(restored.youtubeId, 'abcdefghijk');
      expect(restored.sections, hasLength(1));
    });

    test('deletes a user song and cleans up user state', () async {
      final store = await _freshStore();
      final library = LibraryController(store: store);
      await library.saveUserSong(
        const Song(id: 'us_4', titles: {'it': 'Temporaneo'}, tagIds: ['messa']),
      );
      await library.toggleFavorite('us_4');

      await library.deleteUserSong('us_4');

      expect(library.userSongs, isEmpty);
      expect(library.songById('us_4'), isNull);
      expect(library.isFavorite('us_4'), isFalse);

      final reopened = LibraryController(store: store);
      expect(reopened.songById('us_4'), isNull);
    });

    test('catalogue ids are not shadowed', () async {
      final library = LibraryController(store: await _freshStore());
      await library.saveUserSong(
        const Song(
          id: 'us_5',
          titles: {'it': 'Mio pane di vita'},
          tagIds: ['messa'],
        ),
      );
      expect(library.songById('pane-di-vita'), isNot('us_5'));
      expect(library.songById('pane-di-vita')!.id, 'pane-di-vita');
      expect(library.userSongs, hasLength(1));
    });
  });
}
