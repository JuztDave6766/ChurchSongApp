import 'package:flutter/foundation.dart';

import '../domain/models.dart';
import 'local_store.dart';

/// CRUD for user setlists, persisted locally.
///
/// Every setlist carries an optional [Setlist.remoteId] so a future cloud
/// layer can reconcile local and remote copies without a migration.
class SetlistController extends ChangeNotifier {
  SetlistController(this._store) {
    _load();
  }

  final LocalStore _store;
  final List<Setlist> _setlists = [];
  bool _initialised = false;

  static const _key = 'setlists';

  void _load() {
    final raw = _store.readList(_key);
    if (raw != null) {
      _initialised = true;
      _setlists
        ..clear()
        ..addAll(
          raw
              .whereType<Map<String, dynamic>>()
              .map(Setlist.fromJson)
              .toList(),
        );
      _sort();
    } else {
      _seedDemoSetlist();
    }
  }

  void _sort() =>
      _setlists.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  List<Setlist> get all => List.unmodifiable(_setlists);

  Setlist? byId(String id) {
    for (final setlist in _setlists) {
      if (setlist.id == id) return setlist;
    }
    return null;
  }

  Setlist create({
    required String name,
    required String functionId,
    List<SetlistItem> items = const [],
  }) {
    final now = DateTime.now();
    final setlist = Setlist(
      id: 'sl_${now.microsecondsSinceEpoch}',
      name: name,
      functionId: functionId,
      items: items,
      createdAt: now,
      updatedAt: now,
    );
    _setlists.add(setlist);
    _persist();
    notifyListeners();
    return setlist;
  }

  Future<void> save(Setlist setlist) async {
    final index = _setlists.indexWhere((item) => item.id == setlist.id);
    final updated = setlist.copyWith(updatedAt: DateTime.now());
    if (index >= 0) {
      _setlists[index] = updated;
    } else {
      _setlists.add(updated);
    }
    _sort();
    notifyListeners();
    await _persist();
  }

  Future<void> delete(String id) async {
    _setlists.removeWhere((setlist) => setlist.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> restoreDemoData() async {
    _setlists.clear();
    await _store.remove(_key);
    _initialised = false;
    _seedDemoSetlist();
    notifyListeners();
    await _persist();
  }

  Map<String, dynamic> toBackup() => {
        'setlists': _setlists.map((setlist) => setlist.toJson()).toList(),
      };

  Future<void> restoreBackup(Map<String, dynamic> data) async {
    _setlists
      ..clear()
      ..addAll(
        (data['setlists'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(Setlist.fromJson),
      );
    _sort();
    _initialised = true;
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    _initialised = true;
    await _store.writeList(
      _key,
      _setlists.map((setlist) => setlist.toJson()).toList(),
    );
  }

  void _seedDemoSetlist() {
    if (_initialised) return;
    final now = DateTime.now();
    _setlists.add(
      Setlist(
        id: 'sl_demo',
        name: 'Messa domenicale',
        functionId: 'messa',
        createdAt: now,
        updatedAt: now,
        items: [
          _item('ingresso', 'ps_cantiamo-te', 0),
          _item('atto-penitenziale', 'ps_signore-pieta', 1),
          _item('gloria', 'ps_gloria', 2),
          _item('offertorio', 'ps_accogli-i-nostri-doni', 3),
          _item('santo', 'ps_santo', 4),
          _item('comunione', 'ps_agnello-di-dio', 5),
          _item('congedo', 'ps_io-saro-con-te', 6),
        ],
      ),
    );
  }

  SetlistItem _item(String momentId, String songId, int index) => SetlistItem(
        id: 'si_demo_$index',
        songId: songId,
        momentId: momentId,
      );
}
