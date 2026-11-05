import '../domain/models.dart';

/// Abstraction over audio/sheet downloads.
///
/// The prototype ships [DemoDownloadService], which only simulates the
/// download and stores the song ids. When real assets are available (remote
/// URLs or a CDN), only this class needs to change: the rest of the app
/// already treats downloads as an asynchronous, premium-gated operation.
abstract class DownloadService {
  Future<void> download(Song song);
  Future<void> remove(Song song);
}

class DemoDownloadService implements DownloadService {
  const DemoDownloadService();

  @override
  Future<void> download(Song song) =>
      Future<void>.delayed(const Duration(milliseconds: 650));

  @override
  Future<void> remove(Song song) =>
      Future<void>.delayed(const Duration(milliseconds: 200));
}

/// Placeholder for the future multi-device synchronisation.
///
/// The UI already surfaces the feature, while this implementation keeps the
/// app local-first. A cloud implementation would merge remote setlists and
/// favourites using the existing `remoteId` fields on [Setlist].
enum SyncStatus { unavailable, idle, syncing, error }

abstract class SyncService {
  SyncStatus get status;
  DateTime? get lastSync;
  Future<void> syncNow();
}

class LocalOnlySyncService implements SyncService {
  @override
  SyncStatus get status => SyncStatus.unavailable;

  @override
  DateTime? get lastSync => null;

  @override
  Future<void> syncNow() async {}
}
