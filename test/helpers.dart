import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:church_song_app/data/personal_songs_service.dart';
import 'package:church_song_app/domain/models.dart';

/// Loads the catalogue bundled with the app.
Future<List<Song>> loadBundledCatalogue() async {
  final raw = await rootBundle.loadString('assets/data/personal_songs.json');
  return PersonalSongsService.parse(raw);
}
