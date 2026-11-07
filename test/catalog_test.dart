import 'package:flutter_test/flutter_test.dart';

import 'package:church_song_app/domain/catalog.dart';
import 'package:church_song_app/domain/models.dart';

void main() {
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
      final ids = kSongs.map((song) => song.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('every song tag exists in the catalogue', () {
      for (final song in kSongs) {
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
          final songs = kSongs.where((song) => song.hasTag(moment.id));
          if (moment.optional) continue;
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

    test('songs have at least one section and one tag', () {
      for (final song in kSongs) {
        if (song.license == SongLicense.copyrighted) {
          // Protected repertoire ships metadata only, never bundled lyrics.
          expect(song.sections, isEmpty, reason: song.id);
          expect(
            song.sourceNote != null ||
                song.sheetUrl != null ||
                song.youtubeId != null,
            isTrue,
            reason: '${song.id} has no source pointer',
          );
        } else {
          expect(song.sections, isNotEmpty, reason: song.id);
        }
        expect(song.tagIds, isNotEmpty, reason: song.id);
      }
    });

    test('every function has at least one celebration song', () {
      for (final function in kFunctions) {
        expect(
          kSongs.where((song) => song.hasTag(function.id)),
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
            kSongsById.containsKey(entry.songId),
            isTrue,
            reason: '${template.id} / ${entry.songId}',
          );
          // The suggested song must belong to the template's function.
          expect(
            kSongsById[entry.songId]!.hasTag(template.functionId),
            isTrue,
            reason: '${template.id} / ${entry.songId}',
          );
        }
      }
    });
  });
}
