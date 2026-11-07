import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:church_song_app/app.dart';
import 'package:church_song_app/data/local_store.dart';
import 'package:church_song_app/domain/models.dart';
import 'package:church_song_app/ui/shared/song_tile.dart';

import 'helpers.dart';

late List<Song> _catalogue;

Future<void> _pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final store = await LocalStore.open();
  await tester.pumpWidget(
    ChurchSongApp(store: store, personalSongs: _catalogue),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    _catalogue = await loadBundledCatalogue();
  });

  testWidgets('searches the library and opens the song sheet', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpApp(tester);

    await tester.tap(find.text('Canti'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Cantiamo Te');
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(SongTile),
        matching: find.text('Cantiamo Te'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Modifica canto'), findsOneWidget);
    expect(find.text('Stampa'), findsOneWidget);
    expect(find.text('Cerca su YouTube'), findsOneWidget);

    await tester.tap(find.byTooltip('Chiudi').last);
    await tester.pumpAndSettle();
  });

  testWidgets('starts the demo setlist celebration and finishes it',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpApp(tester);

    await tester.tap(find.text('Scalette'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Messa domenicale').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Avvia la celebrazione'), findsOneWidget);
    await tester.tap(find.textContaining('Avvia la celebrazione'));
    await tester.pumpAndSettle();

    expect(find.text('CELEBRAZIONE'), findsOneWidget);
    expect(find.text('Cantiamo Te'), findsOneWidget);

    await tester.tap(find.text('Termina la celebrazione'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(FilledButton, 'Termina la celebrazione'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Celebrazione conclusa'), findsOneWidget);
    await tester.tap(find.text('Torna alla scaletta'));
    await tester.pumpAndSettle();
    expect(find.text('Scaletta'), findsOneWidget);

    // Dispose the tree so the event timer cannot leak into another test.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
