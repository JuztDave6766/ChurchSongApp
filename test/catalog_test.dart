import 'package:flutter_test/flutter_test.dart';

import 'package:church_song_app/domain/catalog.dart';
import 'package:church_song_app/domain/models.dart';

import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<Song> catalogue;

  setUpAll(() async {
    catalogue = await loadBundledCatalogue();
  });

  group('catalog integrity', () {
    test('tag ids are unique', () {
      final ids = kTags.map((tag) => tag.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('function ids are unique', () {
      final ids = kFunctions.map((function) => function.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('song ids are unique', () {
      final ids = catalogue.map((song) => song.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('every song tag exists in the catalogue', () {
      for (final song in catalogue) {
        for (final tagId in song.tagIds) {
          expect(
            kTagsById.containsKey(tagId),
            isTrue,
            reason: '${song.id} references unknown tag "$tagId"',
          );
        }
      }
    });

    test('every function has at least one song for each required moment', () {
      for (final function in kFunctions) {
        for (final moment in function.moments) {
          if (moment.optional) continue;
          final songs = catalogue.where((song) => song.hasTag(moment.id));
          expect(
            songs,
            isNotEmpty,
            reason: '${function.id} has no song for "${moment.id}"',
          );
        }
      }
    });

    test('every moment id belongs to the shared moment set', () {
      for (final function in kFunctions) {
        for (final moment in function.moments) {
          expect(
            kMomentIds,
            contains(moment.id),
            reason: '${moment.id} is missing from kMomentIds',
          );
        }
      }
    });

    test('songs carry text, a source note and at least one tag', () {
      for (final song in catalogue) {
        expect(song.sections, isNotEmpty, reason: song.id);
        expect(song.tagIds, isNotEmpty, reason: song.id);
        expect(song.sourceNote, isNotEmpty, reason: song.id);
        expect(song.license, SongLicense.personalUse, reason: song.id);
        expect(song.titles['it'], isNotEmpty, reason: song.id);
      }
    });

    test('every function has at least one celebration song', () {
      for (final function in kFunctions) {
        expect(
          catalogue.where((song) => song.hasTag(function.id)),
          isNotEmpty,
          reason: function.id,
        );
      }
    });
  });

  group('themed templates', () {
    test('template ids are unique', () {
      final ids = kSetlistTemplates.map((template) => template.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('every template references existing functions, moments and songs',
        () {
      final songsById = {for (final song in catalogue) song.id: song};
      for (final template in kSetlistTemplates) {
        expect(
          kFunctionsById.containsKey(template.functionId),
          isTrue,
          reason: template.id,
        );
        for (final entry in template.entries) {
          expect(
            kMomentIds.contains(entry.momentId),
            isTrue,
            reason: '${template.id} / ${entry.momentId}',
          );
          expect(
            songsById.containsKey(entry.songId),
            isTrue,
            reason: '${template.id} / ${entry.songId}',
          );
          // The suggested song must belong to the template's function.
          expect(
            songsById[entry.songId]!.hasTag(template.functionId),
            isTrue,
            reason: '${template.id} / ${entry.songId}',
          );
        }
      }
    });
  });

  group('demo setlist', () {
    test('every id refers to a song in the bundled catalogue', () async {
      final songs = {for (final song in catalogue) song.id};
      for (final id in const [
        'ps_cantiamo-te',
        'ps_signore-pieta',
        'ps_gloria',
        'ps_accogli-i-nostri-doni',
        'ps_santo',
        'ps_agnello-di-dio',
        'ps_io-saro-con-te',
      ]) {
        expect(songs, contains(id));
      }
    });
  });
}
