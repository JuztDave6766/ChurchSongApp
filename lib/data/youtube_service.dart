import 'dart:convert';

import 'package:http/http.dart' as http;

/// Details fetched for a song, either from a YouTube URL (oEmbed) or from a
/// title search (YouTube Data API v3, optional key).
class YouTubeSongInfo {
  const YouTubeSongInfo({required this.title, this.author, this.videoId});

  final String title;
  final String? author;
  final String? videoId;
}

typedef FetchJson = Future<Map<String, dynamic>> Function(Uri uri);

/// Default [FetchJson] implementation using package:http.
Future<Map<String, dynamic>> httpFetchJson(Uri uri) async {
  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 12));
  if (response.statusCode != 200) {
    throw FormatException('HTTP ${response.statusCode}');
  }
  final decoded = jsonDecode(response.body);
  return decoded is Map<String, dynamic> ? decoded : {};
}

class YouTubeService {
  YouTubeService({FetchJson? fetchJson})
      : _fetchJson = fetchJson ?? httpFetchJson;

  final FetchJson _fetchJson;

  static final RegExp _videoIdPattern =
      RegExp(r'(?:v=|youtu\.be/|embed/|shorts/)([A-Za-z0-9_-]{8,20})');

  /// Extracts a video id from plain text (a URL or a raw id).
  static String? extractVideoId(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    final match = _videoIdPattern.firstMatch(trimmed);
    if (match != null) return match.group(1);
    if (RegExp(r'^[A-Za-z0-9_-]{11}?$').hasMatch(trimmed)) return trimmed;
    return null;
  }

  static Uri _oembedUri(String videoId) => Uri.parse(
      'https://www.youtube.com/oembed?url='
      '${Uri.encodeComponent('https://www.youtube.com/watch?v=$videoId')}'
      '&format=json');

  /// Fetches title/author for a pasted YouTube link or id via oEmbed.
  /// Returns null when the link does not point to a valid public video.
  Future<YouTubeSongInfo?> fetchInfoFromUrl(String input) async {
    final videoId = extractVideoId(input);
    if (videoId == null) return null;
    try {
      final data = await _fetchJson(_oembedUri(videoId));
      final title = data['title'];
      if (title is! String || title.isEmpty) return null;
      return YouTubeSongInfo(
        title: title,
        author: data['author_name'] is String
            ? data['author_name'] as String
            : null,
        videoId: videoId,
      );
    } on Exception {
      return null;
    }
  }

  /// Searches by title with the YouTube Data API v3. Requires a key.
  Future<YouTubeSongInfo?> searchByTitle(
    String query,
    String apiKey,
  ) async {
    if (query.trim().isEmpty || apiKey.trim().isEmpty) return null;
    final uri = Uri.https('www.googleapis.com', '/youtube/v3/search',
        {'part': 'snippet', 'type': 'video', 'q': query, 'key': apiKey});
    try {
      final data = await _fetchJson(uri);
      final items = data['items'];
      if (items is! List || items.isEmpty) return null;
      final first = items.first;
      if (first is! Map<String, dynamic>) return null;
      final snippet = first['snippet'];
      if (snippet is! Map<String, dynamic>) return null;
      final title = snippet['title'];
      if (title is! String || title.isEmpty) return null;
      return YouTubeSongInfo(
        title: title,
        author: snippet['channelTitle'] is String
            ? snippet['channelTitle'] as String
            : null,
        videoId: (first['id'] as Map<String, dynamic>?)?['videoId'] as String?,
      );
    } on Exception {
      return null;
    }
  }

  /// Fallback: a YouTube search URL the user can open in a browser.
  static Uri searchUrl(String query) => Uri.parse(
      'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}');

  static Uri watchUrl(String videoId) =>
      Uri.parse('https://www.youtube.com/watch?v=$videoId');
}
