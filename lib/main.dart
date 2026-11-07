import 'package:flutter/material.dart';

import 'app.dart';
import 'data/local_store.dart';
import 'data/personal_songs_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await LocalStore.open();
  final personalSongs = await const PersonalSongsService().load();
  runApp(ChurchSongApp(store: store, personalSongs: personalSongs));
}
