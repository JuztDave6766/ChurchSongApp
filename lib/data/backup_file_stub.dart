/// Non-web fallback for backup file export/import.
///
/// On mobile and desktop the settings screen falls back to the clipboard,
/// which keeps the demo dependency-free while remaining fully functional.
Future<bool> saveBackupFile(String content, String fileName) async => false;

Future<String?> pickBackupFile() async => null;
