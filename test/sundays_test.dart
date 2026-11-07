import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:church_song_app/data/library_controller.dart';
import 'package:church_song_app/data/local_store.dart';
import 'package:church_song_app/data/sundays_service.dart';
import 'package:church_song_app/domain/models.dart';

Future<Map<String, dynamic>> _mockLoader() async => {
      'sundays': [
        {
          'date': '2026-02-01',
          'titleIt': '4ª domenica del Tempo ordinario',
          'titleEn': '4th Sunday in Ordinary Time',
          'firstReading': 'Dt 18,15-20',
          'psalmCitation': 'Salmo 94 (95)',
          'psalmResponse': "Se oggi ascoltate la sua voce, non irrigidite i vostri cuori.",
          'gospel': 'Mc 1,21-28',
          'themeIds': ['fiducia'],
        },
        {
          'date': '2026-05-31',
          'titleIt': 'Pentecoste',
          'titleEn': 'Pentecost',
          'gospel': 'Gv 20,19-23',
          'themeIds': ['spirito-santo', 'pace'],
        },
      ],
    };

Future<LocalStore> _freshStore() async {
  SharedPreferences.setMockInitialValues({});
  return LocalStore.open();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SundaysController with a mocked loader', () {
    late SundaysController controller;

    setUp(() async {
      controller = SundaysController(loader: _mockLoader);
      await controller.ensureLoaded();
    });

    test('parses readings', () {
      expect(controller.sundays, hasLength(2));
      expect(controller.loaded, isTrue);
      final first = controller.sundays.first;
      expect(first.date.year, 2026);
      expect(first.date.month, 2);
      expect(first.psalmCitation, 'Salmo 94 (95)');
      expect(first.themeIds, ['fiducia']);
      expect(first.title('en'), '4th Sunday in Ordinary Time');
    });

    test('finds the Sunday by exact date or the upcoming one', () {
      final sunday = controller.forDate(DateTime(2026, 2, 4));
      expect(sunday!.title('it'), '4ª domenica del Tempo ordinario');

      // Sunday itself.
      final sameDay = controller.forDate(DateTime(2026, 2, 1));
      expect(sameDay!.title('it'), '4ª domenica del Tempo ordinario');
    });

    test('falls back to the nearest future entry for unknown dates', () {
      final unknown = controller.forDate(DateTime(2050, 1, 1));
      expect(unknown!.title('it'), 'Pentecoste');
    });
  });

  group('suggestions (mocked library)', () {
    test('prioritises themed songs for psalm and alleluia', () async {
      final library = LibraryController(store: await _freshStore());
      await library.saveUserSong(
        const Song(
          id: 'us_psalm_test',
          titles: {'it': 'Mio salmo a tema'},
          tagIds: ['messa', 'salmo', 'fiducia'],
          sections: [SongSection(kind: SectionKind.response, text: 'R.')],
        ),
      );

      final sundays = SundaysController(loader: _mockLoader);
      await sundays.ensureLoaded();
      final reading = sundays.forDate(DateTime(2026, 2, 4))!;
      final suggestions = reading.buildSuggestions(library);

      expect(suggestions.psalmSongs, isNotEmpty);
      expect(
        suggestions.psalmSongs.map((song) => song.title('it')),
        contains('Mio salmo a tema'),
      );
      expect(suggestions.alleluiaSongs, isNotEmpty);
      // Golden alleluia songs (tagged versetto-alleluia with gioia) first.
      expect(suggestions.alleluiaSongs.first.hasTag('versetto-alleluia'), isTrue);
      expect(suggestions.communionSongs, isNotEmpty);
      expect(suggestions.items, isNotEmpty);
    });
  });
}
