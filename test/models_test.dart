import 'package:flutter_test/flutter_test.dart';

import 'package:church_song_app/domain/models.dart';

void main() {
  group('Song', () {
    const song = Song(
      id: 'demo',
      titles: {'it': 'Canto demo', 'en': 'Demo song'},
      tagIds: ['messa', 'ingresso'],
      sections: [
        SongSection(kind: SectionKind.chorus, text: 'Ritornello'),
      ],
    );

    test('resolves localised titles with Italian fallback', () {
      expect(song.title('en'), 'Demo song');
      expect(song.title('fr'), 'Canto demo');
    });

    test('builds a display title with the version', () {
      const withVersion = Song(
        id: 'v1',
        titles: {'it': 'Santo'},
        version: 'Gen Verde',
        tagIds: ['messa'],
      );
      const withoutVersion = Song(
        id: 'v2',
        titles: {'it': 'Santo'},
        tagIds: ['messa'],
      );

      expect(withVersion.displayTitle('it'), 'Santo · Gen Verde');
      expect(withoutVersion.displayTitle('it'), 'Santo');
    });

    test('matches tags', () {
      expect(song.hasTag('messa'), isTrue);
      expect(song.hasTag('gloria'), isFalse);
      expect(song.matchesAnyTag({'gloria', 'ingresso'}), isTrue);
      expect(song.matchesAnyTag({'gloria', 'santo'}), isFalse);
      expect(song.matchesAnyTag(const {}), isFalse);
    });

    test('round-trips the version and keeps it in copyWith', () {
      final versioned = Song.fromJson({
        'id': 'v3',
        'titles': {'it': 'Kyrie'},
        'version': 'Gen Rosso',
        'tagIds': ['messa'],
      });
      expect(versioned.version, 'Gen Rosso');
      expect(versioned.toJson()['version'], 'Gen Rosso');
      expect(versioned.copyWith(version: 'Buttazzo').version, 'Buttazzo');
      expect(versioned.copyWith().version, 'Gen Rosso');
    });
  });

  group('Setlist serialisation', () {
    final createdAt = DateTime.utc(2026, 3, 1, 10, 30);
    final updatedAt = DateTime.utc(2026, 3, 2, 18, 45);
    final setlist = Setlist(
      id: 'sl_1',
      name: 'Messa di prova',
      functionId: 'messa',
      createdAt: createdAt,
      updatedAt: updatedAt,
      remoteId: 'remote_1',
      items: const [
        SetlistItem(
          id: 'si_1',
          songId: 'cantiamo-al-signore',
          momentId: 'ingresso',
          note: 'Aprire con forza',
        ),
        SetlistItem(id: 'si_2', songId: 'gloria-a-dio'),
      ],
    );

    test('round-trips through JSON', () {
      final restored = Setlist.fromJson(setlist.toJson());

      expect(restored.id, setlist.id);
      expect(restored.name, setlist.name);
      expect(restored.functionId, setlist.functionId);
      expect(restored.remoteId, 'remote_1');
      expect(restored.createdAt, createdAt);
      expect(restored.updatedAt, updatedAt);
      expect(restored.items, hasLength(2));
      expect(restored.items.first.songId, 'cantiamo-al-signore');
      expect(restored.items.first.momentId, 'ingresso');
      expect(restored.items.first.note, 'Aprire con forza');
      expect(restored.items.last.momentId, isNull);
      expect(restored.songCount, 2);
    });

    test('copyWith updates editable fields and keeps identity', () {
      final copy = setlist.copyWith(
        name: 'Nuovo nome',
        updatedAt: DateTime.utc(2026, 4, 1),
      );

      expect(copy.id, setlist.id);
      expect(copy.name, 'Nuovo nome');
      expect(copy.createdAt, createdAt);
      expect(copy.updatedAt, DateTime.utc(2026, 4, 1));
      expect(copy.items, same(setlist.items));
    });

    test('handles missing optional fields and invalid dates', () {
      final restored = Setlist.fromJson({
        'id': 'sl_plain',
        'name': 'Senza extra',
        'functionId': 'preghiera',
        'items': <dynamic>[],
        'createdAt': 'not-a-date',
      });

      expect(restored.items, isEmpty);
      expect(restored.remoteId, isNull);
      expect(restored.createdAt, isA<DateTime>());
    });
  });

  group('AppSettings', () {
    test('uses sensible defaults', () {
      const settings = AppSettings();

      expect(settings.languageCode, 'it');
      expect(settings.themeMode, 'system');
    });

    test('round-trips through JSON', () {
      const settings = AppSettings(
        languageCode: 'en',
        themeMode: 'dark',
      );

      final restored = AppSettings.fromJson(settings.toJson());

      expect(restored.languageCode, 'en');
      expect(restored.themeMode, 'dark');
    });
  });

  group('LiturgicalFunction', () {
    test('finds moments by id', () {
      const function = LiturgicalFunction(
        id: 'demo',
        it: 'Demo',
        en: 'Demo',
        descriptionIt: 'Demo',
        descriptionEn: 'Demo',
        iconName: 'church',
        moments: [
          LiturgicalMoment(id: 'ingresso', it: 'Ingresso', en: 'Entrance'),
        ],
      );

      expect(function.momentById('ingresso')?.label('it'), 'Ingresso');
      expect(function.momentById('gloria'), isNull);
    });
  });
}
