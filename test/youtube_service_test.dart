import 'package:flutter_test/flutter_test.dart';

import 'package:church_song_app/data/youtube_service.dart';

void main() {
  group('extractVideoId', () {
    test('parses standard watch links', () {
      expect(
        YouTubeService.extractVideoId(
          'https://www.youtube.com/watch?v=z9zvDBPkgOk',
        ),
        'z9zvDBPkgOk',
      );
      expect(
        YouTubeService.extractVideoId('https://youtu.be/Z1fR4SV55qg'),
        'Z1fR4SV55qg',
      );
      expect(
        YouTubeService.extractVideoId(
          'https://www.youtube.com/embed/MxObjsQpoG4',
        ),
        'MxObjsQpoG4',
      );
      expect(YouTubeService.extractVideoId('z9zvDBPkgOk'), 'z9zvDBPkgOk');
      expect(
        YouTubeService.extractVideoId('https://www.youtube.com/other'),
        isNull,
      );
      expect(YouTubeService.extractVideoId('   '), isNull);
    });
  });

  group('fetchInfoFromUrl (mocked transport)', () {
    test('returns title and author from oEmbed payload', () async {
      Uri? requested;
      final service = YouTubeService(
        fetchJson: (uri) async {
          requested = uri;
          return {
            'title': 'Taizé: Ubi caritas',
            'author_name': 'St. Bart\'s Singers',
          };
        },
      );

      final info = await service.fetchInfoFromUrl(
        'https://www.youtube.com/watch?v=z9zvDBPkgOk',
      );

      expect(requested, isNotNull);
      expect(requested!.host, 'www.youtube.com');
      expect(requested!.path, '/oembed');
      expect(
        requested!.queryParameters['url'],
        contains('youtube.com/watch?v=z9zvDBPkgOk'),
      );
      expect(info!.title, 'Taizé: Ubi caritas');
      expect(info.author, 'St. Bart\'s Singers');
      expect(info.videoId, 'z9zvDBPkgOk');
    });

    test('returns null for a non-matching input', () async {
      var called = false;
      final service = YouTubeService(
        fetchJson: (uri) async {
          called = true;
          return {};
        },
      );
      expect(await service.fetchInfoFromUrl('solo titolo, nessun link'), isNull);
      expect(called, isFalse);
    });

    test('returns null when the transport fails', () async {
      final service = YouTubeService(
        fetchJson: (uri) => Future.error(const FormatException('boom')),
      );
      expect(
        await service.fetchInfoFromUrl(
          'https://www.youtube.com/watch?v=abcdefghijk',
        ),
        isNull,
      );
    });
  });

  group('searchByTitle with the Data API (mocked transport)', () {
    test('parses the first search result', () async {
      Uri? requested;
      final service = YouTubeService(
        fetchJson: (uri) async {
          requested = uri;
          return {
            'items': [
              {
                'id': {'videoId': 'Hh4PX1BnyJY'},
                'snippet': {
                  'title': 'Santo - Gen Rosso e Gen Verde',
                  'channelTitle': 'Gen Rosso',
                },
              },
            ],
          };
        },
      );

      final info = await service.searchByTitle('Santo Gen Rosso', 'my-key');

      expect(info!.title, 'Santo - Gen Rosso e Gen Verde');
      expect(info.author, 'Gen Rosso');
      expect(info.videoId, 'Hh4PX1BnyJY');
      expect(requested!.host, 'www.googleapis.com');
      expect(requested!.queryParameters['key'], 'my-key');
      expect(requested!.queryParameters['q'], 'Santo Gen Rosso');
    });

    test('refuses to run without a key', () async {
      var called = false;
      final service = YouTubeService(
        fetchJson: (uri) async {
          called = true;
          return {};
        },
      );
      expect(await service.searchByTitle('X', ''), isNull);
      await service.searchByTitle('X', '  '); // whitespace only
      expect(called, isFalse);
    });
  });
}
