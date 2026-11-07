import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:church_song_app/app.dart';
import 'package:church_song_app/data/local_store.dart';

import 'package:church_song_app/domain/models.dart';

import 'helpers.dart';


late List<Song> _catalogue;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    _catalogue = await loadBundledCatalogue();
  });

  testWidgets('renders the home screen and navigates between tabs',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.open();

    await tester.pumpWidget(
      ChurchSongApp(store: store, personalSongs: _catalogue),
    );
    await tester.pumpAndSettle();

    expect(find.text('Canti Liturgici'), findsOneWidget);
    expect(find.text('IL SIGNORE SIA CON VOI'), findsOneWidget);

    await tester.tap(find.text('Canti'));
    await tester.pumpAndSettle();
    expect(find.text('Canti Liturgici'), findsNothing);
    expect(
      find.text('Tutti i canti, ordinati per tag e momento.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Scalette'));
    await tester.pumpAndSettle();
    expect(find.text('Messa domenicale'), findsWidgets);
  });

  testWidgets('switches language to English', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.open();

    await tester.pumpWidget(
      ChurchSongApp(store: store, personalSongs: _catalogue),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Impostazioni'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
  });
}
