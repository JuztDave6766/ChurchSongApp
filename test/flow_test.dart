import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:church_song_app/app.dart';
import 'package:church_song_app/data/local_store.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final store = await LocalStore.open();
  await tester.pumpWidget(ChurchSongApp(store: store));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('creates a setlist, starts the event and finishes it', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpApp(tester);

    // Home -> celebration chooser -> Mass.
    await tester.tap(find.text('Inizia a preparare'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Messa'));
    await tester.pumpAndSettle();
    expect(find.text('Crea una scaletta'), findsOneWidget);

    // Mass -> new setlist editor.
    await tester.tap(find.text('Crea una scaletta'));
    await tester.pumpAndSettle();
    expect(find.text('Nuova scaletta'), findsOneWidget);

    // Add an entrance song through the picker.
    await tester.tap(find.byTooltip('Aggiungi canti').first);
    await tester.pumpAndSettle();
    expect(find.text('Scegli un canto'), findsOneWidget);

    await tester.tap(find.text('Cantiamo al Signore'));
    await tester.pump();
    await tester.tap(find.text('Aggiungi'));
    await tester.pumpAndSettle();

    expect(find.text('Cantiamo al Signore'), findsOneWidget);

    // Save: the editor pops and its detail page opens (dismiss the snackbar so
    // it does not cover the bottom bar).
    await tester.tap(find.text('Salva').last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Scaletta'), findsOneWidget);
    expect(
      find.textContaining('Avvia la celebrazione'),
      findsOneWidget,
    );

    // Start the guided celebration.
    await tester.tap(find.textContaining('Avvia la celebrazione'));
    await tester.pumpAndSettle();
    expect(find.text('CELEBRAZIONE'), findsOneWidget);
    expect(find.text('Cantiamo al Signore'), findsOneWidget);

    // Advance the timer and finish the event.
    await tester.pump(const Duration(seconds: 2));
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

    // Dispose the tree so the event timer cannot leak into the next test.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('premium gate unlocks demo downloads from the song sheet', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpApp(tester);

    await tester.tap(find.text('Canti'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adoriamo te, Signore'));
    await tester.pumpAndSettle();

    expect(find.text('Scarica'), findsOneWidget);
    await tester.tap(find.text('Scarica'));
    await tester.pumpAndSettle();

    // Premium dialog explains the feature before unlocking it.
    expect(find.text('Attiva demo'), findsOneWidget);
    await tester.tap(find.text('Attiva demo'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Scaricato'), findsOneWidget);

    await tester.tap(find.byTooltip('Chiudi').last);
    await tester.pumpAndSettle();

    // The downloaded state is reflected in the library tile.
    expect(find.byIcon(Icons.offline_pin_rounded), findsWidgets);
  });
}
