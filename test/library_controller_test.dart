import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:church_song_app/data/library_controller.dart';
import 'package:church_song_app/data/local_store.dart';
import 'package:church_song_app/domain/models.dart';

const _alpha = Song(
  id: 'ps_alpha',
  titles: {'it': 'Alzo gli occhi'},
  author: 'Autore A',
  version: 'Gen Verde',
  tagIds: ['messa', 'ingresso', 'luce'],
  sections: [SongSection(kind: SectionKind.verse, text: '[Re]Alzo gli occhi')],
  license: SongLicense.personalUse,
  sourceNote: 'Canzoniere, p. 1',
);

const _beta = Song(
  id: 'ps_beta',
  titles: {'it': 'Pane di vita'},
  author: 'Autore B',
  tagIds: ['messa', 'comunione'],
  sections: [SongSection(kind: SectionKind.chorus, text: 'Pane di vita')],
  license: SongLicense.personalUse,
  sourceNote: 'Canzoniere, p. 2',
);

const _gamma = Song(
  id: 'ps_gamma',
  titles: {'it': 'Gloria'},
  author: 'Tradizionale',
  tagIds: ['preghiera', 'apertura'],
  sections: [SongSection(kind: SectionKind.verse, text: 'Gloria a Dio')],
  license: SongLicense.personalUse,
  sourceNote: 'Canzoniere, p. 3',
);

const _catalogue = [_alpha, _beta, _gamma];

Future<LocalStore> _freshStore() async {
  SharedPreferences.setMockInitialValues({});
  return LocalStore.open();
}

LibraryController _controller(LocalStore store) =>
    LibraryController(store: store, catalogue: _catalogue);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('catalogue and filtering', () {
    late LibraryController library;

    setUp(() async {
      library = _controller(await _freshStore());
    });

    test('exposes the catalogue alphabetically', () {
      final songs = library.filter();
      expect(songs.map((song) => song.id), ['ps_alpha', 'ps_gamma', 'ps_beta']);
      expect(library.songs, hasLength(3));
      expect(library.userSongs, isEmpty);
    });

    test('filters by moment and optional function', () {
      expect(
        library.songsForMoment('ingresso').map((song) => song.id),
        ['ps_alpha'],
      );
      expect(
        library.songsForMoment('comunione', functionId: 'messa').map(
          (song) => song.id,
        ),
        ['ps_beta'],
      );
      expect(library.songsForMoment('comunione', functionId: 'preghiera'),
          isEmpty);
    });

    test('searches title, author and version case-insensitively', () {
      expect(library.filter(query: '  GLORIA ').single.id, 'ps_gamma');
      expect(library.filter(query: 'autore b').single.id, 'ps_beta');
      expect(library.filter(query: 'gen verde').single.id, 'ps_alpha');
      expect(library.filter(query: 'nessun-canto-cosi'), isEmpty);
    });

    test('combines tag filters with any-match semantics', () {
      final results = library.filter(tagIds: {'luce', 'comunione'});
      expect(results.map((song) => song.id), ['ps_alpha', 'ps_beta']);
    });

    test('filters favourites only', () {
      expect(library.filter(favoritesOnly: true), isEmpty);
      library.toggleFavorite('ps_beta');
      expect(
        library.filter(favoritesOnly: true).map((song) => song.id),
        ['ps_beta'],
      );
    });

    test('counts songs for a moment', () {
      expect(library.countForMoment('ingresso'), 1);
    });
  });

  group('favourites persistence', () {
    test('persists favourites across controller instances', () async {
      final store = await _freshStore();
      final first = _controller(store);

      await first.toggleFavorite('ps_alpha');
      expect(first.isFavorite('ps_alpha'), isTrue);

      final reopened = _controller(store);
      expect(reopened.isFavorite('ps_alpha'), isTrue);

      await reopened.toggleFavorite('ps_alpha');
      expect(_controller(store).isFavorite('ps_alpha'), isFalse);
    });
  });

  group('local overrides', () {
    test('saves, exposes and restores a catalogued song', () async {
      final store = await _freshStore();
      final library = _controller(store);

      await library.saveOverride(
        _alpha.copyWith(titles: {'it': 'Alzo gli occhi (corretto)'}),
      );

      expect(library.isOverridden('ps_alpha'), isTrue);
      expect(library.overrideCount, 1);
      expect(library.songById('ps_alpha')!.title('it'),
          'Alzo gli occhi (corretto)');
      expect(library.originalSongById('ps_alpha')!.title('it'),
          'Alzo gli occhi');

      final reopened = _controller(store);
      expect(reopened.isOverridden('ps_alpha'), isTrue);
      expect(reopened.songById('ps_alpha')!.title('it'),
          'Alzo gli occhi (corretto)');

      await reopened.resetOverride('ps_alpha');
      expect(reopened.isOverridden('ps_alpha'), isFalse);
      expect(reopened.songById('ps_alpha')!.title('it'), 'Alzo gli occhi');
      expect(_controller(store).isOverridden('ps_alpha'), isFalse);
    });

    test('rejects overrides for unknown ids', () async {
      final library = _controller(await _freshStore());
      expect(
        () => library.saveOverride(
          const Song(id: 'ps_unknown', titles: {'it': 'X'}, tagIds: ['messa']),
        ),
        throwsArgumentError,
      );
    });
  });

  group('user songs', () {
    test('saves, updates and persists a user song', () async {
      final store = await _freshStore();
      final library = _controller(store);

      await library.saveUserSong(
        const Song(
          id: 'us_1',
          titles: {'it': 'Mio canto'},
          tagIds: ['messa', 'ingresso'],
          sections: [SongSection(kind: SectionKind.verse, text: 'Testo')],
        ),
      );

      expect(library.userSongs.map((song) => song.id), ['us_1']);
      expect(library.songs, hasLength(4));
      expect(library.songById('us_1'), isNotNull);

      await library.saveUserSong(
        const Song(id: 'us_1', titles: {'it': 'Titolo corretto'}, tagIds: ['messa']),
      );
      expect(library.userSongs, hasLength(1));
      expect(library.songById('us_1')!.title('it'), 'Titolo corretto');

      final reopened = _controller(store);
      expect(reopened.songById('us_1')!.title('it'), 'Titolo corretto');
    });

    test('deletes a user song and cleans favourites', () async {
      final library = _controller(await _freshStore());
      await library.saveUserSong(
        const Song(id: 'us_2', titles: {'it': 'Temporaneo'}, tagIds: ['messa']),
      );
      await library.toggleFavorite('us_2');

      await library.deleteUserSong('us_2');

      expect(library.userSongs, isEmpty);
      expect(library.songById('us_2'), isNull);
      expect(library.isFavorite('us_2'), isFalse);
    });
  });

  group('backup and reset', () {
    test('round-trips favourites, overrides and user songs', () async {
      final store = await _freshStore();
      final library = _controller(store);
      await library.toggleFavorite('ps_beta');
      await library.saveOverride(
        _alpha.copyWith(titles: {'it': 'Alzo gli occhi (locale)'}),
      );
      await library.saveUserSong(
        const Song(id: 'us_3', titles: {'it': 'Nuovo'}, tagIds: ['messa']),
      );
      final backup = library.toBackup();

      await library.resetUserData();
      expect(library.isFavorite('ps_beta'), isFalse);
      expect(library.isOverridden('ps_alpha'), isFalse);
      expect(library.userSongs, isEmpty);

      await library.restoreBackup(backup);
      expect(library.isFavorite('ps_beta'), isTrue);
      expect(library.songById('ps_alpha')!.title('it'), 'Alzo gli occhi (locale)');
      expect(library.userSongs, hasLength(1));
    });

    test('reset clears local data but keeps the catalogue', () async {
      final library = _controller(await _freshStore());
      await library.toggleFavorite('ps_alpha');
      await library.saveOverride(
        _alpha.copyWith(titles: {'it': 'Modificato'}),
      );
      await library.saveUserSong(
        const Song(id: 'us_4', titles: {'it': 'Utente'}, tagIds: ['messa']),
      );

      await library.resetUserData();

      expect(library.songs, hasLength(3));
      expect(library.overrideCount, 0);
      expect(library.userSongs, isEmpty);
      expect(library.filter(favoritesOnly: true), isEmpty);
    });

    test('catalogue ids cannot be shadowed by user songs', () async {
      final library = _controller(await _freshStore());
      expect(library.songById('ps_alpha')!.id, 'ps_alpha');
      expect(library.songById('ps_alpha')!.title('it'), 'Alzo gli occhi');
    });
  });
}
