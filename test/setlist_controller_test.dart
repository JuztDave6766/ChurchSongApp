import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:church_song_app/data/local_store.dart';
import 'package:church_song_app/data/setlist_controller.dart';
import 'package:church_song_app/domain/models.dart';

Future<LocalStore> _freshStore() async {
  SharedPreferences.setMockInitialValues({});
  return LocalStore.open();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('seeds the demo setlist on first launch', () async {
    final controller = SetlistController(await _freshStore());

    expect(controller.all, hasLength(1));
    final demo = controller.all.single;
    expect(demo.id, 'sl_demo');
    expect(demo.name, 'Messa domenicale');
    expect(demo.functionId, 'messa');
    expect(demo.songCount, 6);
    expect(demo.items.first.momentId, 'ingresso');
  });

  test('creates a setlist and persists it', () async {
    final store = await _freshStore();
    final controller = SetlistController(store);

    final created = controller.create(
      name: 'Vespri',
      functionId: 'preghiera',
      items: const [
        SetlistItem(id: 'si_a', songId: 'padre-nostro', momentId: 'apertura'),
      ],
    );

    expect(controller.all, hasLength(2));
    expect(controller.byId(created.id)?.name, 'Vespri');

    final reopened = SetlistController(store);
    expect(reopened.all, hasLength(2));
    expect(reopened.byId(created.id)?.items.single.songId, 'padre-nostro');
  });

  test('updates an existing setlist and moves it to the top', () async {
    final store = await _freshStore();
    final controller = SetlistController(store);
    final demo = controller.all.single;
    final older = controller.create(name: 'Vecchia', functionId: 'messa');

    await controller.save(
      demo.copyWith(
        name: 'Messa aggiornata',
        items: const [
          SetlistItem(id: 'si_new', songId: 'santo-santo', momentId: 'santo'),
        ],
      ),
    );

    expect(controller.all, hasLength(2));
    expect(controller.byId(demo.id)?.name, 'Messa aggiornata');
    expect(controller.all.first.id, demo.id);
    expect(controller.all.last.id, older.id);

    final reopened = SetlistController(store);
    expect(reopened.byId(demo.id)?.name, 'Messa aggiornata');
    expect(reopened.byId(demo.id)?.songCount, 1);
  });

  test('deletes a setlist and persists the deletion', () async {
    final store = await _freshStore();
    final controller = SetlistController(store);
    final demoId = controller.all.single.id;

    await controller.delete(demoId);

    expect(controller.all, isEmpty);
    expect(controller.byId(demoId), isNull);

    final reopened = SetlistController(store);
    expect(reopened.all, isEmpty);
  });

  test('restores the demo data after deletion', () async {
    final store = await _freshStore();
    final controller = SetlistController(store);
    final extra = controller.create(name: 'Da eliminare', functionId: 'messa');

    await controller.delete(extra.id);
    await controller.restoreDemoData();

    expect(controller.all, hasLength(1));
    expect(controller.all.single.id, 'sl_demo');

    final reopened = SetlistController(store);
    expect(reopened.all, hasLength(1));
    expect(reopened.all.single.id, 'sl_demo');
  });

  test('notifies listeners on mutations', () async {
    final controller = SetlistController(await _freshStore());
    var notifications = 0;
    controller.addListener(() => notifications++);

    final created = controller.create(name: 'Nuova', functionId: 'messa');
    expect(notifications, 1);

    await controller.save(created.copyWith(name: 'Rinominata'));
    expect(notifications, 2);

    await controller.delete(created.id);
    expect(notifications, 3);
  });
}
