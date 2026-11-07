import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:church_song_app/data/personal_songs_service.dart';
import 'package:church_song_app/domain/catalog.dart';
import 'package:church_song_app/domain/models.dart';

const _sample = '''
{
  "songs": [
    {
      "id": "ps_demo",
      "titles": {"it": "Canto personale"},
      "author": "Autore",
      "tagIds": ["messa", "ingresso", "avvento"],
      "sections": [
        {"kind": "chorus", "text": "Ritornello"},
        {"kind": "verse", "text": "Verso"}
      ],
      "license": "personalUse",
      "sourceNote": "Canzoniere personale, p. 1"
    }
  ]
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PersonalSongsService', () {
    test('parses personal songs and their licence', () {
      final songs = PersonalSongsService.parse(_sample);

      expect(songs, hasLength(1));
      final song = songs.single;
      expect(song.id, 'ps_demo');
      expect(song.title('it'), 'Canto personale');
      expect(song.license, SongLicense.personalUse);
      expect(song.sections, hasLength(2));
      expect(song.sections.first.kind, SectionKind.chorus);
      expect(song.sourceNote, contains('p. 1'));
    });

    test('loads through an injected transport and survives bad input', () async {
      final loaded = await PersonalSongsService(
        loader: () async => _sample,
      ).load();
      expect(loaded.single.id, 'ps_demo');

      final empty = await PersonalSongsService(
        loader: () async => 'not json',
      ).load();
      expect(empty, isEmpty);
    });

    test('bundled catalogue is complete and references known tags', () async {
      final raw = await rootBundle.loadString('assets/data/personal_songs.json');
      final songs = PersonalSongsService.parse(raw);

      expect(songs.length, greaterThan(200));
      final ids = songs.map((song) => song.id).toList();
      expect(ids.toSet(), hasLength(ids.length), reason: 'duplicate song id');

      for (final song in songs) {
        expect(song.id.startsWith('ps_'), isTrue, reason: song.id);
        expect(song.license, SongLicense.personalUse, reason: song.id);
        expect(song.titles['it'], isNotEmpty, reason: song.id);
        expect(song.sections, isNotEmpty, reason: song.id);
        expect(song.sourceNote, isNotEmpty, reason: song.id);
        expect(song.tagIds, isNotEmpty, reason: song.id);
        for (final section in song.sections) {
          expect(section.text.trim(), isNotEmpty, reason: song.id);
        }
        for (final tagId in song.tagIds) {
          expect(
            kTagsById.containsKey(tagId),
            isTrue,
            reason: '${song.id} references unknown tag "$tagId"',
          );
        }
      }
    });
  });
}
