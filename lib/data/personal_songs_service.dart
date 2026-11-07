import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models.dart';

/// Loads the songs extracted from the personal songbooks.
///
/// The catalogue is deliberately kept outside `kSongs`: those songs are built
/// from the user's own PDFs and may only be shown in this personal build.
class PersonalSongsService {
  const PersonalSongsService({
    this.assetPath = 'assets/data/personal_songs.json',
    this.loader,
  });

  final String assetPath;

  /// Injectable transport used by tests; production reads the asset bundle.
  final Future<String> Function()? loader;

  Future<List<Song>> load() async {
    try {
      final raw = await (loader?.call() ?? rootBundle.loadString(assetPath));
      return parse(raw);
    } catch (_) {
      // A missing or broken asset must not prevent the app from starting.
      return const [];
    }
  }

  static List<Song> parse(String raw) {
    final decoded = jsonDecode(raw);
    final entries = decoded is Map<String, dynamic>
        ? decoded['songs']
        : decoded;
    if (entries is! List) return const [];
    return entries
        .whereType<Map<String, dynamic>>()
        .map(Song.fromJson)
        .toList(growable: false);
  }
}
